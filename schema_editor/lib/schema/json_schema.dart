import 'dart:convert';

import 'package:embed_annotation/embed_annotation.dart';
import 'package:json_schema/json_schema.dart' as json_schema;
import 'package:schema_editor/schema/schema.dart';
import 'package:schema_editor/schema/validation_result.dart';
import 'package:yaml/yaml.dart';

part 'json_schema.g.dart';

@EmbedBinary("../../json-schema/csv-armor-schema.yaml")
const csvArmorSchemaYamlBytes = _$csvArmorSchemaYamlBytes;

json_schema.JsonSchema _getValidator() {
  final schema = loadYaml(utf8.decode(csvArmorSchemaYamlBytes));
  return json_schema.JsonSchema.create(schema);
}

final _validator = _getValidator();

ValidationResult validateByJsonSchema(Schema schema) {
  final result = ValidationResult();

  final errors = _validator.validate(schema.toJson());
  for (final error in errors.errors) {
    result.addError([], ValidationError.codeInvalidAgainstJsonSchema,
        'Invalid against JSON Schema (csv-armor-schema) [${error.schemaPath}]: ${error.instancePath}: ${error.message}');
  }
  return result;
}
