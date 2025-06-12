
import 'package:json_annotation/json_annotation.dart';
part 'validation_result.g.dart';

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
