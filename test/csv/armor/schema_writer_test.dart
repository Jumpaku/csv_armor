import 'dart:io';

import 'package:csv_armor/csv/armor/schema/schema.dart';
import 'package:csv_armor/csv/armor/schema_writer.dart';
import 'package:csv_armor/csv/decoder.dart';
import 'package:path/path.dart' as path;
import 'package:test/test.dart';

typedef _Testcase = ({
  String description,
  String inSchemaPath,
  File schemaFile,
});

void main() {
  group('SchemaWriter', () {
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
        final sut = SchemaWriter(workdir.absolute.path);
        sut.write(want, testcase.inSchemaPath);

        final got = Schema.load(testcase.schemaFile.readAsStringSync());
        expect(got.toJson(), equals(want.toJson()));
      });
    }
  });
}
