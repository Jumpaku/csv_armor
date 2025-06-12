import 'package:json_annotation/json_annotation.dart';
import 'package:schema_editor/data/csv_reader.dart';
import 'package:schema_editor/data/data_store.dart';
import 'package:schema_editor/schema/schema.dart';
import 'package:schema_editor/sqlite3/database_access.dart';

part 'validate.g.dart';

@JsonSerializable(
    disallowUnrecognizedKeys: true, explicitToJson: true, includeIfNull: false)
class DataValidationError {
  DataValidationError({
    required this.message,
    required this.code,
    this.validationErrorKey,
    this.validationErrorValues,
  });

  static const codeCsvReadFailed = 'csv_read_failed';
  static const codeQueryExecutionFailed = 'query_execution_failed';
  static const codeRowLengthMismatch = 'row_length_mismatch';
  static const codeValidationFailed = 'validation_failed';

  @JsonKey(name: "code")
  final String code;
  @JsonKey(name: "message")
  final String message;
  @JsonKey(name: "validation_error_key")
  final List<String>? validationErrorKey;
  @JsonKey(name: "validation_error_values")
  final List<List<String>>? validationErrorValues;

  factory DataValidationError.fromJson(Map<String, dynamic> json) =>
      _$DataValidationErrorFromJson(json);

  Map<String, dynamic> toJson() => _$DataValidationErrorToJson(this);
}

@JsonSerializable(
    disallowUnrecognizedKeys: true, explicitToJson: true, includeIfNull: false)
class DataValidationResult {
  DataValidationResult({this.errors = const []});

  @JsonKey(name: "errors")
  List<DataValidationError> errors;

  bool get isValid => errors.isEmpty;

  void addError(DataValidationError err) {
    errors = [...errors, err];
  }

  void merge(DataValidationResult other) {
    errors = [...errors, ...other.errors];
  }

  factory DataValidationResult.fromJson(Map<String, dynamic> json) =>
      _$DataValidationResultFromJson(json);

  Map<String, dynamic> toJson() => _$DataValidationResultToJson(this);
}

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
