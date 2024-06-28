// This file is 'main.dart'

// Import annotations
import 'dart:convert';

import 'package:embed_annotation/embed_annotation.dart';
import 'package:json_schema/json_schema.dart';
import 'package:yaml/yaml.dart';

part 'schema_validator.g.dart';

@EmbedBinary("csv-armor.schema.yaml")
const csvArmorSchemaYAMLBytes = _$csvArmorSchemaYAMLBytes;

typedef SchemaValidator = JsonSchema;

SchemaValidator getSchemaValidator() {
  final csvArmorSchemaYAML = utf8.decode(csvArmorSchemaYAMLBytes);
  final schema = jsonEncode(loadYaml(csvArmorSchemaYAML));
  return JsonSchema.create(schema);
}
