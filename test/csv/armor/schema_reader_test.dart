import 'dart:io';

import 'package:csv_armor/csv/armor/schema/schema.dart';
import 'package:csv_armor/csv/armor/schema_reader.dart';
import 'package:csv_armor/csv/field_quote.dart';
import 'package:csv_armor/csv/field_separator.dart';
import 'package:csv_armor/csv/record_separator.dart';
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
        recordSeparator: RecordSeparator.CRLF,
        fieldSeparator: FieldSeparator.COMMA,
        fieldQuote: FieldQuote.DQUOTE,
      );
      final schemaFile = File(path.join(workdir.path, "schema.yaml"))
        ..createSync(recursive: true);
      schemaFile.writeAsStringSync(
        '''{csv_path: data.csv, columns: [{name: a}], primary_key: [a], record_separator: CRLF, field_separator: COMMA, field_quote: DQUOTE}''',
      );

      const sut = SchemaReader();
      final got = sut.read(schemaFile.path);

      expect(got, equals(want));
    });
  });
}
