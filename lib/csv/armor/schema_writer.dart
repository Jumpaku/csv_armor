import 'dart:convert';
import 'dart:io';

import 'package:csv_armor/csv/armor/error.dart';
import 'package:csv_armor/csv/armor/schema/schema.dart';
import 'package:csv_armor/csv/armor/schema_reader.dart';
import 'package:path/path.dart' as path;
import 'package:yaml_edit/yaml_edit.dart';

class SchemaWriter {
  SchemaWriter(String workingPath,
      {SchemaFormat schemaFormat = SchemaFormat.yaml})
      : _schemaFormat = schemaFormat,
        _workingPath = path.normalize(workingPath) {
    if (!path.isAbsolute(_workingPath)) {
      throw ArgumentError(
          "Working path must be an absolute path", "absoluteWorkingPath");
    }
  }

  final String _workingPath;
  final SchemaFormat _schemaFormat;

  void write(Schema schema, String schemaPath) {
    final schemaString = switch (_schemaFormat) {
      SchemaFormat.yaml =>
        (YamlEditor('')..update([], schema.toJson())).toString(),
      SchemaFormat.json => jsonEncode(schema.toJson()),
    };

    try {
      String absoluteSchemaPath = schemaPath;
      if (!path.isAbsolute(absoluteSchemaPath)) {
        absoluteSchemaPath = path.join(_workingPath, schemaPath);
      }
      final schemaFile = File(absoluteSchemaPath);
      (schemaFile..createSync(recursive: true))
          .writeAsStringSync(schemaString, flush: true);
    } catch (e) {
      throw ReadWriteException(
        "Failed to write schema file",
        readWriteErrorSchemaWriteFailure,
        schemaPath,
        _workingPath,
        cause: e,
      );
    }
  }
}
