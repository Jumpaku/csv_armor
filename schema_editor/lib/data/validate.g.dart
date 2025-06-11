// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'validate.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DataValidationError _$DataValidationErrorFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    allowedKeys: const ['message', 'queryError', 'key', 'values'],
  );
  return DataValidationError(
    json['message'] as String,
    json['queryError'] as String,
    (json['key'] as List<dynamic>).map((e) => e as String).toList(),
    (json['values'] as List<dynamic>)
        .map((e) => (e as List<dynamic>).map((e) => e as String).toList())
        .toList(),
  );
}

Map<String, dynamic> _$DataValidationErrorToJson(
        DataValidationError instance) =>
    <String, dynamic>{
      'message': instance.message,
      'queryError': instance.queryError,
      'key': instance.key,
      'values': instance.values,
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
