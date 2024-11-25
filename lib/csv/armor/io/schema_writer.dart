import 'dart:convert';
import 'dart:io';

import 'package:csv_armor/csv/armor/schema/table_schema.dart';
import 'package:yaml_edit/yaml_edit.dart';

enum SchemaFormat { json, yaml }

abstract interface class SchemaWriter {
  void write(String schemaPath, TableSchema schema);
}

class FileSchemaWriter implements SchemaWriter {
  const FileSchemaWriter({SchemaFormat schemaFormat = SchemaFormat.yaml})
      : _schemaFormat = schemaFormat;

  final SchemaFormat _schemaFormat;

  @override
  void write(String schemaPath, TableSchema schema) {
    final schemaString = switch (_schemaFormat) {
      SchemaFormat.yaml =>
        (YamlEditor('')..update([], schema.toJson())).toString(),
      SchemaFormat.json => jsonEncode(schema.toJson()),
    };

    final f = File(schemaPath)..createSync(recursive: true);
    f.writeAsStringSync(schemaString, flush: true);
  }
}
