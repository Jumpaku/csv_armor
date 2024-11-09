import 'dart:io';

import 'package:csv_armor/csv/armor/schema/schema.dart';
import 'package:csv_armor/csv/armor/schema_reader.dart';
import 'package:path/path.dart' as path;
import 'package:test/test.dart';

void main() {
  group('SchemaReader', () {
    final workdir =
        (Directory('./test_tmp')..createSync(recursive: true)).createTempSync();

    test('should read CSV schema file', () {
      final want = Schema(
        "data.csv",
        [Column("a")],
        ["a"],
      );
      final schemaFile = File(path.join(workdir.path, "schema.yaml"))
        ..createSync(recursive: true);
      schemaFile.writeAsStringSync(
        '''{csv_path: data.csv, columns: [{name: a}], primary_key: [a]}''',
      );

      const sut = FileSchemaReader();
      final got = sut.read(schemaFile.path);

      expect(got, equals(want));
    });
  });
}
