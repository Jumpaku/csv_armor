import 'dart:io';

import 'package:csv_armor/csv/armor/schema/table_schema.dart';
import 'package:path/path.dart';
import 'package:yaml/yaml.dart';

abstract interface class SchemaReader {
  TableSchema read(String schemaPath);
}

class FileSchemaReader implements SchemaReader {
  FileSchemaReader({
    Context? ctx,
  }) : _ctx = ctx ?? Context();

  final Context _ctx;

  @override
  TableSchema read(String schemaPath) {
    final content = File(_ctx.canonicalize(schemaPath)).readAsStringSync();
    final json = (loadYaml(content) as YamlMap).cast<String, dynamic>();
    return TableSchema.fromJson(json);
  }
}
