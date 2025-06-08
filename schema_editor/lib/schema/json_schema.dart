import 'dart:convert';

import 'package:embed_annotation/embed_annotation.dart';
import 'package:json_schema/json_schema.dart';
import 'package:schema_editor/schema/validate.dart';
import 'package:yaml/yaml.dart';

part 'json_schema.g.dart';

@EmbedBinary("../../json-schema/csv-armor-schema.yaml")
const csvArmorSchemaYamlBytes = _$csvArmorSchemaYamlBytes;

JsonSchema _getValidator() {
  final schema = loadYaml(utf8.decode(csvArmorSchemaYamlBytes));
  return JsonSchema.create(schema);
}

final _validator = _getValidator();

SchemaValidationResult validateByJsonSchema(Map<String, dynamic> json) {
  final result = SchemaValidationResult();

  final errors = _validator.validate(json);
  for (final error in errors.errors) {
    result.addError([], SchemaValidationError.codeInvalidAgainstJsonSchema,
        'Invalid against JSON Schema (csv-armor-schema) [${error.schemaPath}]: ${error.instancePath}: ${error.message}');
  }
  return result;
}
