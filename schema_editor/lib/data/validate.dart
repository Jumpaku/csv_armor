import 'package:json_annotation/json_annotation.dart';
import 'package:schema_editor/data/csv_reader.dart';
import 'package:schema_editor/data/data_buffer.dart';
import 'package:schema_editor/data/data_store.dart';
import 'package:schema_editor/data/validation_result.dart';
import 'package:schema_editor/schema/schema.dart';
import 'package:schema_editor/sqlite3/database_access.dart';


DataValidationResult validateData(Schema schema, CsvReader reader) {
  final result = DataValidationResult();

  DataBuffer buf;
  try {
    buf = reader.readAll(schema.tableConfig);
  } catch (e) {
    result.addError(DataValidationError(
      message: 'CSV error: ${e.toString()}',
      code: DataValidationError.codeCsvReadFailed,
    ));
    return result;
  }

  DataStore store;
  try {
    store = DataStore(db: DatabaseAccess.openInMemory());
    store.initialize(schema.tableConfig);
    store.import(schema.tableConfig, buf);
  } catch (e) {
    result.addError(DataValidationError(
      message: 'Query error: ${e.toString()}',
      code: DataValidationError.codeQueryExecutionFailed,
    ));
    return result;
  }

  for (final validation in schema.validation) {
    List<String> columns;
    List<List<String>> rows;
    try {
      final r = store.query(validation.validationQuery);
      columns = r.columns;
      rows = r.rows;
    } catch (e) {
      result.addError(DataValidationError(
        message: 'Query error: ${e.toString()}',
        code: DataValidationError.codeQueryExecutionFailed,
      ));
      continue;
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
