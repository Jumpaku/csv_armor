// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'validation_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ValidationError _$ValidationErrorFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    allowedKeys: const ['path', 'code', 'message'],
  );
  return ValidationError(
    (json['path'] as List<dynamic>).map((e) => e as String).toList(),
    json['code'] as String,
    json['message'] as String,
  );
}

Map<String, dynamic> _$ValidationErrorToJson(ValidationError instance) =>
    <String, dynamic>{
      'path': instance.path,
      'code': instance.code,
      'message': instance.message,
    };

ValidationResult _$ValidationResultFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    allowedKeys: const ['errors'],
  );
  return ValidationResult(
    errors: (json['errors'] as List<dynamic>?)
            ?.map((e) => ValidationError.fromJson(e as Map<String, dynamic>))
            .toList() ??
        const [],
  );
}

Map<String, dynamic> _$ValidationResultToJson(ValidationResult instance) =>
    <String, dynamic>{
      'errors': instance.errors.map((e) => e.toJson()).toList(),
    };
