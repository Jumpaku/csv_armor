import 'package:json_annotation/json_annotation.dart';

part 'validation_result.g.dart';

@JsonSerializable(
    disallowUnrecognizedKeys: true, explicitToJson: true, includeIfNull: false)
class ValidationError {
  static const codeUndefinedColumnType = 'undefined_column_type';
  static const codeInvalidColumnRegexp = 'invalid_column_regexp';
  static const codeEmptyPrimaryKey = 'empty_primary_key';
  static const codeUndefinedPrimaryKeyColumn = 'undefined_primary_key_column';
  static const codeEmptyUniqueKeyColumns = 'empty_unique_key_columns';
  static const codeEmptyUniqueKeyName = 'empty_unique_key_name';
  static const codeUndefinedUniqueKeyColumn = 'undefined_unique_key_column';
  static const codeEmptyForeignKeyName = 'empty_foreign_key_name';
  static const codeEmptyForeignKeyColumns = 'empty_foreign_key_columns';
  static const codeUndefinedForeignKeyColumn = 'undefined_foreign_key_column';
  static const codeUndefinedForeignKeyReferenceTable =
      'undefined_foreign_key_reference_table';
  static const codeInvalidColumnTypeRegexp = 'invalid_column_type_regexp';
  static const codeUndefinedForeignKeyReferenceUniqueKey =
      'undefined_foreign_key_reference_unique_key';
  static const codeInvalidAgainstJsonSchema = 'invalid_against_json_schema';
  static const codeEmptyTableName = 'empty_table_name';
  static const codeEmptyCsvPath = 'empty_csv_path';
  static const codeInvalidCsvPath = 'invalid_csv_path';
  static const codeUndefinedCsvPathPlaceholder =
      'undefined_csv_path_placeholder';

  ValidationError(this.path, this.code, this.message);

  @JsonKey(name: "path")
  final List<String> path;
  @JsonKey(name: "code")
  final String code;
  @JsonKey(name: "message")
  final String message;

  factory ValidationError.fromJson(Map<String, dynamic> json) =>
      _$ValidationErrorFromJson(json);

  Map<String, dynamic> toJson() => _$ValidationErrorToJson(this);
}

@JsonSerializable(
    disallowUnrecognizedKeys: true, explicitToJson: true, includeIfNull: false)
class ValidationResult {
  ValidationResult({this.errors = const []});

  @JsonKey(name: "errors")
  List<ValidationError> errors;

  bool get isValid => errors.isEmpty;

  void addError(List<String> path, String code, String message) {
    errors = [...errors, ValidationError(path, code, message)];
  }

  void merge(ValidationResult other) {
    errors = [...errors, ...other.errors];
  }

  factory ValidationResult.fromJson(Map<String, dynamic> json) =>
      _$ValidationResultFromJson(json);

  Map<String, dynamic> toJson() => _$ValidationResultToJson(this);
}
