import 'dart:convert';
import 'dart:io';

import 'package:csv_armor/csv/armor/error.dart';
import 'package:csv_armor/csv/armor/schema/schema.dart';
import 'package:yaml_edit/yaml_edit.dart';

enum SchemaFormat { json, yaml }

abstract interface class SchemaWriter {
  void write(String schemaPath, Schema schema);
}

class FileSchemaWriter implements SchemaWriter {
  const FileSchemaWriter({SchemaFormat schemaFormat = SchemaFormat.yaml})
      : _schemaFormat = schemaFormat;

  final SchemaFormat _schemaFormat;

  @override
  void write(String schemaPath, Schema schema) {
    final schemaString = switch (_schemaFormat) {
      SchemaFormat.yaml =>
        (YamlEditor('')..update([], schema.toJson())).toString(),
      SchemaFormat.json => jsonEncode(schema.toJson()),
    };

    try {
      final schemaFile = File(schemaPath);
      (schemaFile..createSync(recursive: true))
          .writeAsStringSync(schemaString, flush: true);
    } catch (e) {
      throw FileCacheException(
        "Failed to write schema file",
        fileCacheErrorSchemaWriteFailure,
        schemaPath,
        cause: e,
      );
    }
  }
}
