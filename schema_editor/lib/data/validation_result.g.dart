// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'validation_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DataValidationError _$DataValidationErrorFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    allowedKeys: const [
      'code',
      'message',
      'validation_error_key',
      'validation_error_values'
    ],
  );
  return DataValidationError(
    message: json['message'] as String,
    code: json['code'] as String,
    validationErrorKey: (json['validation_error_key'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    validationErrorValues: (json['validation_error_values'] as List<dynamic>?)
        ?.map((e) => (e as List<dynamic>).map((e) => e as String).toList())
        .toList(),
  );
}

Map<String, dynamic> _$DataValidationErrorToJson(
        DataValidationError instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      if (instance.validationErrorKey case final value?)
        'validation_error_key': value,
      if (instance.validationErrorValues case final value?)
        'validation_error_values': value,
    };

DataValidationResult _$DataValidationResultFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    allowedKeys: const ['errors'],
  );
  return DataValidationResult(
    errors: (json['errors'] as List<dynamic>?)
            ?.map(
                (e) => DataValidationError.fromJson(e as Map<String, dynamic>))
            .toList() ??
        const [],
  );
}

Map<String, dynamic> _$DataValidationResultToJson(
        DataValidationResult instance) =>
    <String, dynamic>{
      'errors': instance.errors.map((e) => e.toJson()).toList(),
    };
