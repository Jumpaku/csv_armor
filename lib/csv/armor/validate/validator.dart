import 'dart:collection';

import 'package:collection/collection.dart';
import 'package:csv_armor/csv/armor/csv_cache.dart';
import 'package:csv_armor/csv/armor/csv_reader.dart';
import 'package:csv_armor/csv/armor/csv_writer.dart';
import 'package:csv_armor/csv/armor/schema/schema.dart';
import 'package:csv_armor/csv/armor/schema_cache.dart';
import 'package:csv_armor/csv/armor/validate/result.dart';
import 'package:csv_armor/csv/store/index.dart';
import 'package:csv_armor/errors/base_exception.dart';

class Validator {
  Validator(this._schemaCache)
      : _csvCache = CSVCache(_schemaCache, CSVReader(), const CSVWriter());

  final SchemaCache _schemaCache;
  final CSVCache _csvCache;

  ValidationResult validate(String schemaPath) {
    final Schema schema;
    try {
      schema = _schemaCache.readSchema(schemaPath);
    } on BaseException catch (e) {
      return ValidationResult(errors: [InvalidSchema(schemaPath, e)]);
    }

    final List<List<String>> csv;
    try {
      csv = _csvCache.readCSV(schemaPath);
    } on BaseException catch (e) {
      return ValidationResult(
        errors: [
          InvalidCSV(_schemaCache.resolve(schemaPath, schema.csvPath), e),
        ],
      );
    }

    final errors = validateShape(schema, csv);
    if (errors.isNotEmpty) {
      return ValidationResult(errors: errors);
    }

    errors.addAll(validatePrimaryKey(schema, csv));
    errors.addAll(validateUniqueKey(schema, csv));
    errors.addAll(validateFieldFormat(schema, csv));
    schema.foreignKey.forEach((fkName, fk) {
      final foreignSchemaPath =
          _schemaCache.resolve(schemaPath, fk.reference.schemaPath);
      final Schema foreignSchema;
      try {
        foreignSchema = _schemaCache.readSchema(foreignSchemaPath);
      } on BaseException catch (e) {
        errors.add(InvalidSchema(foreignSchemaPath, e));
        return;
      }

      final fkSchemaErrors = validateForeignKeySchema(schema, foreignSchema);
      if (fkSchemaErrors.isNotEmpty) {
        errors.addAll(fkSchemaErrors);
        return;
      }

      final List<List<String>> foreignCSV;
      try {
        foreignCSV = _csvCache.readCSV(foreignSchemaPath);
      } on BaseException catch (e) {
        errors.add(
          InvalidCSV(
            _schemaCache.resolve(foreignSchemaPath, foreignSchema.csvPath),
            e,
          ),
        );
        return;
      }

      errors.addAll(
          validateForeignKey(fkName, schema, csv, foreignSchema, foreignCSV));
    });

    return ValidationResult(errors: errors);
  }
}

List<ValidationError> validateShape(
  Schema schema,
  List<List<String>> csv,
) {
  if (csv.length < schema.headers) {
    return [TooFewHeaders(csv.length)];
  }
  final errors = <ValidationError>[];
  for (final (rowIndex, row) in csv.indexed.skip(schema.headers)) {
    if (row.length != schema.columns.length) {
      errors.add(ColumnCountMismatch(rowIndex, row.length));
    }
  }
  return errors;
}

List<ValidationError> validatePrimaryKey(
  Schema schema,
  List<List<String>> csv,
) {
  final columnIndex = schema.columnIndex();
  final pkIndex =
      Index.build(schema.primaryKey.map((k) => columnIndex[k]!).toList(), csv);

  final errors = <ValidationError>[];
  pkIndex.collectKeys().forEach((key) {
    if (pkIndex.get(key).length > 1) {
      errors.add(DuplicatedPrimaryKey(key.key, pkIndex.get(key)));
    }
  });

  return errors;
}

List<ValidationError> validateUniqueKey(
  Schema schema,
  List<List<String>> csv,
) {
  final columnIndex = schema.columnIndex();
  final errors = <ValidationError>[];
  schema.uniqueKey.forEach((ukName, uk) {
    final ukIndex = Index.build(uk.map((k) => columnIndex[k]!).toList(), csv);
    ukIndex.collectKeys().forEach((key) {
      if (ukIndex.get(key).length > 1) {
        errors.add(DuplicatedUniqueKey(ukName, key.key, ukIndex.get(key)));
      }
    });
  });
  return errors;
}

List<ValidationError> validateFieldFormat(
  Schema schema,
  List<List<String>> csv,
) {
  final errors = <ValidationError>[];
  for (final (rowIndex, row) in csv.indexed.skip(schema.headers)) {
    for (final (columnIndex, column) in schema.columns.indexed) {
      final value = row[columnIndex];
      if (column.allowEmpty && value.isEmpty) {
        continue;
      }
      if (column.formatRegex != null) {
        if (!RegExp(column.formatRegex!).hasMatch(value)) {
          errors.add(
              InvalidFieldFormat(rowIndex, columnIndex, column.formatRegex!));
        }
      }
      final regex = column.formatType.regex();
      if (!regex.hasMatch(value)) {
        errors.add(
          InvalidFieldFormat(rowIndex, columnIndex, column.formatType.name),
        );
      }
    }
  }
  return errors;
}

List<ValidationError> validateForeignKeySchema(
  Schema baseSchema,
  Schema foreignSchema,
) {
  final errors = <ValidationError>[];
  baseSchema.foreignKey.forEach((fkName, fk) {
    bool foreignKeyColumnUnique = false;
    if (const ListEquality<String>()
        .equals(fk.reference.columns, foreignSchema.primaryKey)) {
      foreignKeyColumnUnique = true;
    }
    foreignSchema.uniqueKey.forEach((ukName, uk) {
      if (const ListEquality<String>().equals(fk.reference.columns, uk)) {
        foreignKeyColumnUnique = true;
      }
    });
    if (!foreignKeyColumnUnique) {
      errors.add(ForeignKeyNonUniqueReference(fkName));
    }

    for (final foreignColumn in fk.reference.columns) {
      if (foreignSchema.columns.where((c) => c.name == foreignColumn).isEmpty) {
        errors.add(
          ForeignKeyReferenceColumnNotInForeignColumns(fkName, foreignColumn),
        );
      }
    }
  });
  return errors;
}

List<ValidationError> validateForeignKey(
  String fkName,
  Schema baseSchema,
  List<List<String>> base,
  Schema foreignSchema,
  List<List<String>> foreign,
) {
  final errors = <ValidationError>[];
  final fk = baseSchema.foreignKey[fkName]!;
  final foreignColumnIndex =
      fk.reference.columns.map((c) => foreignSchema.columnIndex()[c]!).toList();
  final foreignIndex = Index.build(foreignColumnIndex, foreign);

  for (final (rowIndex, row) in base.indexed.skip(baseSchema.headers)) {
    final baseColumnIndex = baseSchema.columnIndex();
    final baseKay = fk.columns.map((k) => row[baseColumnIndex[k]!]).toList();
    if (foreignIndex.get(IndexKey(baseKay)).isEmpty) {
      errors.add(ForeignKeyNotFound(fkName, rowIndex, baseKay));
    }
  }

  return errors;
}
