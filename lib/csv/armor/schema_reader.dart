import 'dart:io';

import 'package:csv_armor/csv/armor/error.dart';
import 'package:csv_armor/csv/armor/schema/schema.dart';

abstract interface class SchemaReader {
  Schema read(String schemaPath);
}

class FileSchemaReader implements SchemaReader {
  const FileSchemaReader();

  @override
  Schema read(String schemaPath) {
    String schemaString;
    try {
      schemaString = File(schemaPath).readAsStringSync();
    } catch (e) {
      throw FileCacheException(
        "Failed to read schema file",
        fileCacheErrorSchemaReadFailure,
        schemaPath,
        cause: e,
      );
    }

    return Schema.load(schemaString);
  }
}
