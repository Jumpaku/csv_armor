import 'dart:io';

import 'package:csv_armor/csv/armor/schema/schema.dart';
import 'package:csv_armor/csv/armor/schema_reader.dart';
import 'package:csv_armor/csv/armor/schema_writer.dart';
import 'package:csv_armor/csv/field_quote.dart';
import 'package:csv_armor/csv/field_separator.dart';
import 'package:csv_armor/csv/record_separator.dart';
import 'package:path/path.dart' as path;
import 'package:test/test.dart';

void main() {
  group('SchemaWriter', () {
    final workdir =
        (Directory('./test_tmp')..createSync(recursive: true)).createTempSync();

    test('should write schema file in YAML', () {
      final want = Schema(
        "data.csv",
        [Column("a")],
        ["a"],
        recordSeparator: RecordSeparator.CRLF,
        fieldSeparator: FieldSeparator.COMMA,
        fieldQuote: FieldQuote.DQUOTE,
      );

      final schemaFile = File(path.join(workdir.path, "schema.yaml"))
        ..createSync(recursive: true);

      const sut = SchemaWriter(schemaFormat: SchemaFormat.yaml);
      sut.write(schemaFile.path, want);

      final got = Schema.load(schemaFile.readAsStringSync());

      expect(got, equals(want));
    });

    test('should write schema file in JSON', () {
      final want = Schema(
        "data.csv",
        [Column("a")],
        ["a"],
        recordSeparator: RecordSeparator.CRLF,
        fieldSeparator: FieldSeparator.COMMA,
        fieldQuote: FieldQuote.DQUOTE,
      );

      final schemaFile = File(path.join(workdir.path, "schema.json"))
        ..createSync(recursive: true);

      const sut = SchemaWriter(schemaFormat: SchemaFormat.json);
      sut.write(schemaFile.path, want);

      final got = Schema.load(schemaFile.readAsStringSync());

      expect(got, equals(want));
    });
  });
}
