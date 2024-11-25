import 'dart:io';

import 'package:csv_armor/csv/armor/database/schema_reader.dart';
import 'package:csv_armor/csv/armor/schema/table_schema.dart';
import 'package:path/path.dart' as path;
import 'package:test/test.dart';

void main() {
  group('SchemaReader', () {
    final workdir =
        (Directory('./test_tmp')..createSync(recursive: true)).createTempSync();

    test('should read CSV schema file', () {
      final want = TableSchema(
        columns: [Column("a")],
        primaryKey: ["a"],
      );
      final schemaFile = File(path.join(workdir.path, "schema.yaml"))
        ..createSync(recursive: true);
      schemaFile.writeAsStringSync(
        '''{csv_path: data.csv, columns: [{name: a}], primary_key: [a]}''',
      );

      final sut = FileSchemaReader();
      final got = sut.read(schemaFile.path);

      expect(got, equals(want));
    });
  });
}
