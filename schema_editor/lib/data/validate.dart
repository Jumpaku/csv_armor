import 'package:schema_editor/data/buffer/buffer.dart';
import 'package:schema_editor/data/index.dart';
import 'package:schema_editor/data/reader/csv_reader.dart';
import 'package:schema_editor/data/reader/csv_reader_exception.dart';
import 'package:schema_editor/data/store/data_store.dart';
import 'package:schema_editor/data/store/data_store_exception.dart';
import 'package:schema_editor/data/validation_result.dart';
import 'package:schema_editor/schema/schema.dart';
import 'package:schema_editor/sqlite3/database_access.dart';

DataValidationResult validateData(Schema schema, CsvReader reader) {
  final result = DataValidationResult();

  DataBuffer buf;
  try {
    buf = reader.readAll(schema.tableConfig);
  } catch (e) {
    if (e is CsvReaderException) {
      result.addError(DataValidationError(
        message: 'CSV error: ${e.toString()}',
        code: DataValidationError.codeCsvReadError,
      ));
      return result;
    }
    rethrow;
  }

  result.merge(validateDataColumn(schema.columnType, schema.tableConfig, buf));

  final index = buildIndex(schema.tableConfig, buf);
  result.merge(validateDataUniqueness(schema.tableConfig, index));
  result.merge(validateDataForeignKey(schema.tableConfig, buf, index));
  if (result.errors.isNotEmpty) {
    return result;
  }

  DataStore store;
  try {
    store = DataStore(db: DatabaseAccess.openInMemory());
    store.initialize(schema.tableConfig);
    store.import(schema.tableConfig, buf);
  } catch (e) {
    if (e is DataStoreException) {
      result.addError(DataValidationError(
        message: 'Data store error: ${e.toString()}',
        code: DataValidationError.codeQueryExecutionError,
      ));
      return result;
    }
    rethrow;
  }

  for (final validation in schema.validation) {
    List<String> columns;
    List<List<String>> rows;
    try {
      (columns: columns, rows: rows) = store.query(validation.validationQuery);
    } catch (e) {
      if (e is DataStoreException) {
        result.addError(DataValidationError(
          message: 'Query error: ${e.toString()}',
          code: DataValidationError.codeQueryExecutionError,
        ));
        continue;
      }
      rethrow;
    }

    result.addError(DataValidationError(
      message: validation.message,
      code: DataValidationError.codeValidationFailed,
      validationErrorKey: columns,
      validationErrorValues: rows,
    ));
  }

  return result;
}

DataValidationResult validateDataForeignKey(List<TableConfig> tableConfig,
    DataBuffer data, Map<String, Map<String, Index>> index) {
  final result = DataValidationResult();

  for (final t in tableConfig) {
    final (columns: columns, records: records) = data[t.name]!;
    final columnIdx = {
      for (final (idx, column) in columns.indexed) column: idx
    };
    for (final row in records) {
      for (final fk in t.foreignKey.entries) {
        final refTable = fk.value.reference.table;
        final indexName = fk.value.reference.uniqueKey ?? '';
        final refIndex = index[refTable]![indexName]!;
        final key = Key([for (final c in fk.value.columns) row[columnIdx[c]!]]);
        if (refIndex.getRows(key).isEmpty) {
          result.addError(DataValidationError(
            message:
                'Foreign key violation in table "${t.name}" for foreign key "${fk.key}" referencing table "${fk.value.reference.table}" with key "$key"',
            code: DataValidationError.codeForeignKeyViolation,
            validationErrorKey: key.key,
            validationErrorValues: [row],
          ));
        }
      }
    }
  }

  return result;
}

DataValidationResult validateDataColumn(
  Map<String, String> columnType,
  List<TableConfig> tableConfig,
  DataBuffer data,
) {
  final result = DataValidationResult();

  for (final t in tableConfig) {
    final (columns: columns, records: records) = data[t.name]!;
    final columnIdx = {
      for (final (idx, column) in columns.indexed) column: idx
    };
    for (final row in records) {
      for (final column in t.columns) {
        final value = row[columnIdx[column.name]!];
        if (column.allowEmpty && value.isEmpty) {
          continue;
        }
        if (column.type != null) {
          if (!RegExp(columnType[column.type]!).hasMatch(value)) {
            result.addError(DataValidationError(
              message: 'Invalid data format: ',
              code: DataValidationError.codeInvalidFormatType,
              validationErrorKey: columns,
              validationErrorValues: [row],
            ));
          }
        }
        if (column.regexp != null) {
          if (!RegExp(column.regexp!).hasMatch(value)) {
            result.addError(DataValidationError(
              message: 'Invalid data format: ',
              code: DataValidationError.codeInvalidFormatRegexp,
              validationErrorKey: columns,
              validationErrorValues: [row],
            ));
          }
        }
      }
    }
  }
  return result;
}

DataValidationResult validateDataUniqueness(
    List<TableConfig> tableConfig, Map<String, Map<String, Index>> index) {
  final result = DataValidationResult();

  for (final t in tableConfig) {
    index[t.name]!.forEach((indexName, index) {
      for (final (key: key, rows: rows) in index.data()) {
        if (rows.length > 1) {
          result.addError(DataValidationError(
            message:
                'Uniqueness violation in table "${t.name}" for index "${indexName == '' ? '(PRIMARY KEY)' : indexName}" for key "$key"',
            code: DataValidationError.codeValidationFailed,
            validationErrorKey: key.key,
            validationErrorValues: rows,
          ));
        }
      }
    });
  }

  return result;
}

Map<String, Map<String, Index>> buildIndex(
    List<TableConfig> tableConfig, DataBuffer data) {
  Map<String, Map<String, Index>> indexes = {};
  for (final t in tableConfig) {
    final columnIdx = {
      for (final (idx, column) in t.columns.indexed) column.name: idx,
    };
    final records = data[t.name]!.records;

    Map<String, Index> index = {};

    // Create indexes for unique keys
    for (final uk in t.uniqueKey.entries) {
      index[uk.key] = _buildIndex(uk.value, columnIdx, records);
    }

    // Create index for primary key
    index[''] = _buildIndex(t.primaryKey, columnIdx, records);

    indexes[t.name] = index;
  }
  return indexes;
}

Index _buildIndex(
    List<String> key, Map<String, int> columnIdx, List<List<String>> data) {
  final index = Index();
  final ukColumns = key.map((col) => columnIdx[col]!);
  for (final row in data) {
    index.add(Key([for (final i in ukColumns) row[i]]), row);
  }
  return index;
}
