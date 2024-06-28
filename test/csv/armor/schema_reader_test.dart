import 'dart:io';

import 'package:csv_armor/csv/armor/schema/schema.dart';
import 'package:csv_armor/csv/armor/schema_reader.dart';
import 'package:csv_armor/csv/decoder.dart';
import 'package:path/path.dart' as path;
import 'package:test/test.dart';

typedef _Testcase = ({
  String description,
  String inSchemaPath,
  File schemaFile,
});

void main() {
  group('SchemaReader', () {
    final want = Schema("data.csv", [Column("a")], ["a"],
        recordSeparator: RecordSeparator.CRLF,
        fieldSeparator: FieldSeparator.COMMA,
        fieldQuote: FieldQuote.DQUOTE);
    final workdir =
        (Directory('./test_tmp')..createSync(recursive: true)).createTempSync();
    final absoluteSchemaDir = workdir.absolute.path;
    const relativeSchemaDir = "./schema";
    final testcases = <_Testcase>[
      (
        description:
            'should resolve relative csv path from relative schema path',
        inSchemaPath: path.join(relativeSchemaDir, "schema.yaml"),
        schemaFile:
            File(path.join(workdir.path, relativeSchemaDir, "schema.yaml")),
      ),
      (
        description:
            'should resolve relative csv path from absolute schema path',
        inSchemaPath: path.join(absoluteSchemaDir, "schema.yaml"),
        schemaFile: File(path.join(absoluteSchemaDir, "schema.yaml")),
      ),
    ];

    for (final testcase in testcases) {
      test(testcase.description, () {
        testcase.schemaFile
          ..createSync(recursive: true)
          ..writeAsStringSync(
            '''{csv_path: data.csv, columns: [{name: a}], primary_key: [a], record_separator: CRLF, field_separator: COMMA, field_quote: DQUOTE}''',
          );

        final sut = SchemaReader(workdir.absolute.path);
        final got = sut.read(testcase.inSchemaPath);

        expect(got.toJson(), equals(want.toJson()));
      });
    }
  });
}
