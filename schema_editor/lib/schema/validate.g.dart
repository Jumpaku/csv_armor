// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'validate.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SchemaValidationError _$SchemaValidationErrorFromJson(
    Map<String, dynamic> json) {
  $checkKeys(
    json,
    allowedKeys: const ['path', 'code', 'message'],
  );
  return SchemaValidationError(
    (json['path'] as List<dynamic>).map((e) => e as String).toList(),
    json['code'] as String,
    json['message'] as String,
  );
}

Map<String, dynamic> _$SchemaValidationErrorToJson(
        SchemaValidationError instance) =>
    <String, dynamic>{
      'path': instance.path,
      'code': instance.code,
      'message': instance.message,
    };

SchemaValidationResult _$SchemaValidationResultFromJson(
    Map<String, dynamic> json) {
  $checkKeys(
    json,
    allowedKeys: const ['errors'],
  );
  return SchemaValidationResult(
    errors: (json['errors'] as List<dynamic>?)
            ?.map((e) =>
                SchemaValidationError.fromJson(e as Map<String, dynamic>))
            .toList() ??
        const [],
  );
}

Map<String, dynamic> _$SchemaValidationResultToJson(
        SchemaValidationResult instance) =>
    <String, dynamic>{
      'errors': instance.errors.map((e) => e.toJson()).toList(),
    };
