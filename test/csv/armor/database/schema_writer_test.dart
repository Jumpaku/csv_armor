import 'dart:convert';
import 'dart:io';

import 'package:csv_armor/csv/armor/database/schema_writer.dart';
import 'package:csv_armor/csv/armor/schema/table_schema.dart';
import 'package:path/path.dart' as path;
import 'package:test/test.dart';
import 'package:yaml/yaml.dart';

void main() {
  group('SchemaWriter', () {
    final workdir =
        (Directory('./test_tmp')..createSync(recursive: true)).createTempSync();

    test('should write schema file in YAML', () {
      final want = TableSchema(
        columns: [Column("a")],
        primaryKey: ["a"],
      );

      final schemaFile = File(path.join(workdir.path, "schema.yaml"))
        ..createSync(recursive: true);

      const sut = FileSchemaWriter(schemaFormat: SchemaFormat.yaml);
      sut.write(schemaFile.path, want);

      final json =
          jsonDecode(jsonEncode(loadYaml(schemaFile.readAsStringSync())))
              as Map<String, dynamic>;
      final got = TableSchema.fromJson(json);

      expect(got, equals(want));
    });

    test('should write schema file in JSON', () {
      final want = TableSchema(
        columns: [Column("a")],
        primaryKey: ["a"],
      );

      final schemaFile = File(path.join(workdir.path, "schema.json"))
        ..createSync(recursive: true);

      const sut = FileSchemaWriter(schemaFormat: SchemaFormat.json);
      sut.write(schemaFile.path, want);

      final json =
          jsonDecode(jsonEncode(loadYaml(schemaFile.readAsStringSync())))
              as Map<String, dynamic>;
      final got = TableSchema.fromJson(json);

      expect(got, equals(want));
    });
  });
}
