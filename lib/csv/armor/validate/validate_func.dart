import 'package:collection/collection.dart';
import 'package:csv_armor/csv/armor/schema/schema.dart';
import 'package:csv_armor/csv/armor/validate/result.dart';
import 'package:csv_armor/csv/store/index.dart';

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
  final pkIndex = Index.build(
    schema.primaryKey.map((k) => columnIndex[k]!).toList(),
    csv.skip(schema.headers).toList(),
  );

  final errors = <ValidationError>[];
  pkIndex.collectKeys().forEach((key) {
    if (pkIndex.get(key).length > 1) {
      errors.add(
        DuplicatedPrimaryKey(
          key.key,
          pkIndex.get(key).map((i) => i + schema.headers).toList(),
        ),
      );
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
    final ukIndex = Index.build(
      uk.map((k) => columnIndex[k]!).toList(),
      csv.skip(schema.headers).toList(),
    );
    ukIndex.collectKeys().forEach((key) {
      if (ukIndex.get(key).length > 1) {
        errors.add(
          DuplicatedUniqueKey(
            ukName,
            key.key,
            ukIndex.get(key).map((i) => i + schema.headers).toList(),
          ),
        );
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

      final regex = column.type.regex();
      final typeMatch = regex.hasMatch(value);
      final bool regexMatch;
      if (column.regex == null) {
        regexMatch = true;
      } else {
        regexMatch = RegExp(column.regex!).hasMatch(value);
      }

      if (value.isEmpty) {
        if (column.allowEmpty || (typeMatch && regexMatch)) {
          continue;
        } else {
          errors.add(
            EmptyFieldNotAllowed(rowIndex, columnIndex),
          );
        }
      }
      if (!typeMatch) {
        errors.add(
          FieldHasNoTypeMatch(rowIndex, columnIndex, column.type.name),
        );
      }
      if (!regexMatch) {
        errors.add(
          FieldHasNoRegexMatch(rowIndex, columnIndex, column.regex!),
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
    bool referenceColumnInForeignColumns = true;
    for (final foreignColumn in fk.reference.columns) {
      if (foreignSchema.columns.where((c) => c.name == foreignColumn).isEmpty) {
        errors.add(
          ForeignKeyReferenceColumnNotInForeignColumns(fkName, foreignColumn),
        );
        referenceColumnInForeignColumns = false;
      }
    }
    if (!referenceColumnInForeignColumns) {
      return;
    }

    bool foreignKeyReferenceUnique = false;
    if (const ListEquality<String>()
        .equals(fk.reference.columns, foreignSchema.primaryKey)) {
      foreignKeyReferenceUnique = true;
    }
    foreignSchema.uniqueKey.forEach((ukName, uk) {
      if (const ListEquality<String>().equals(fk.reference.columns, uk)) {
        foreignKeyReferenceUnique = true;
      }
    });
    if (!foreignKeyReferenceUnique) {
      errors.add(ForeignKeyReferenceNotUniqueInForeignColumns(fkName));
    }
  });
  return errors;
}

List<ValidationError> validateForeignKey(
  String fkName,
  Schema baseSchema,
  List<List<String>> baseCSV,
  Schema foreignSchema,
  List<List<String>> foreignCSV,
) {
  final errors = <ValidationError>[];
  final fk = baseSchema.foreignKey[fkName]!;
  final foreignColumnIndex =
      fk.reference.columns.map((c) => foreignSchema.columnIndex()[c]!).toList();
  final foreignIndex = Index.build(foreignColumnIndex, foreignCSV);

  for (final (rowIndex, row) in baseCSV.indexed.skip(baseSchema.headers)) {
    final baseColumnIndex = baseSchema.columnIndex();
    final baseKay = fk.columns.map((k) => row[baseColumnIndex[k]!]).toList();
    if (foreignIndex.get(IndexKey(baseKay)).isEmpty) {
      errors.add(ForeignKeyViolation(fkName, rowIndex, baseKay));
    }
  }

  return errors;
}
