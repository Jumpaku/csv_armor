import 'dart:io';

import 'package:csv_armor/csv/armor/error.dart';
import 'package:csv_armor/csv/armor/schema/schema.dart';
import 'package:path/path.dart' as path;

enum SchemaFormat { json, yaml }

class SchemaReader {
  SchemaReader(String workingPath)
      : _workingPath = path.normalize(workingPath) {
    if (!path.isAbsolute(_workingPath)) {
      throw ArgumentError(
          "Working path must be an absolute path", "absoluteWorkingPath");
    }
  }

  final String _workingPath;

  Schema read(String schemaPath) {
    String schemaString;
    try {
      String absoluteSchemaPath = schemaPath;
      if (!path.isAbsolute(absoluteSchemaPath)) {
        absoluteSchemaPath = path.join(_workingPath, schemaPath);
      }
      final schemaFile = File(absoluteSchemaPath);
      schemaString = schemaFile.readAsStringSync();
    } catch (e) {
      throw ReadWriteException(
        "Failed to read schema file",
        readWriteErrorSchemaReadFailure,
        schemaPath,
        _workingPath,
        cause: e,
      );
    }

    return Schema.load(schemaString);
  }
}
