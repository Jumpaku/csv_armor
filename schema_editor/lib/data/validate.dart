import 'package:json_annotation/json_annotation.dart';
import 'package:schema_editor/data/data_store.dart';
import 'package:schema_editor/schema/schema.dart';

part 'validate.g.dart';

@JsonSerializable(
    disallowUnrecognizedKeys: true, explicitToJson: true, includeIfNull: false)
class DataValidationError {
  DataValidationError(this.message, this.queryError, this.key, this.values);

  @JsonKey(name: "message")
  final String message;
  @JsonKey(name: "queryError")
  final String queryError;
  @JsonKey(name: "key")
  final List<String> key;
  @JsonKey(name: "values")
  final List<List<String>> values;

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

  void addError(String message, String queryError, List<String> key,
      List<List<String>> values) {
    errors = [...errors, DataValidationError(message, queryError, key, values)];
  }

  void merge(DataValidationResult other) {
    errors = [...errors, ...other.errors];
  }

  factory DataValidationResult.fromJson(Map<String, dynamic> json) =>
      _$DataValidationResultFromJson(json);

  Map<String, dynamic> toJson() => _$DataValidationResultToJson(this);
}

DataValidationResult validateData(
    DataStore store, List<Validation> validations) {
  final result = DataValidationResult();

  for (final validation in validations) {
    final r = store.query(validation.queryError);
    result.addError(
        validation.message, validation.queryError, r.columns, r.rows);
  }

  return result;
}
