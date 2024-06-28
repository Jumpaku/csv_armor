import 'dart:io';

import 'package:csv_armor/csv/armor/csv_reader.dart';
import 'package:csv_armor/csv/armor/schema/schema.dart';
import 'package:csv_armor/csv/decoder.dart';
import 'package:path/path.dart' as path;
import 'package:test/test.dart';

typedef _Testcase = ({
  String description,
  String inSchemaPath,
  Schema inSchema,
  File csvFile,
});

void main() {
  group('CSVReader', () {
    const csvText = 'aaa';
    final want = [
      ['aaa']
    ];
    final workdir =
        (Directory('./test_tmp')..createSync(recursive: true)).createTempSync();
    final absoluteSchemaDir = workdir.absolute.path;
    const relativeSchemaDir = "./schema";
    final absoluteCSVDir = workdir.absolute.path;
    const relativeCSVDir = "./data";
    final testcases = <_Testcase>[
      (
        description:
            'should resolve relative csv path from relative schema path',
        inSchemaPath: path.join(relativeSchemaDir, "schema.yaml"),
        inSchema: Schema(
            path.join(relativeCSVDir, "data.csv"), [Column("a")], ["a"],
            recordSeparator: RecordSeparator.CRLF,
            fieldSeparator: FieldSeparator.COMMA,
            fieldQuote: FieldQuote.DQUOTE),
        csvFile: File(path.join(
            workdir.path, relativeSchemaDir, relativeCSVDir, "data.csv")),
      ),
      (
        description:
            'should resolve relative csv path from absolute schema path',
        inSchemaPath: path.join(absoluteSchemaDir, "schema.yaml"),
        inSchema: Schema(
            path.join(relativeCSVDir, "data.csv"), [Column("a")], ["a"],
            recordSeparator: RecordSeparator.CRLF,
            fieldSeparator: FieldSeparator.COMMA,
            fieldQuote: FieldQuote.DQUOTE),
        csvFile: File(path.join(absoluteSchemaDir, relativeCSVDir, "data.csv")),
      ),
      (
        description: 'should resolve absolute csv path',
        inSchemaPath: path.join(relativeSchemaDir, "schema.yaml"),
        inSchema: Schema(
            path.join(absoluteCSVDir, "data.csv"), [Column("a")], ["a"],
            recordSeparator: RecordSeparator.CRLF,
            fieldSeparator: FieldSeparator.COMMA,
            fieldQuote: FieldQuote.DQUOTE),
        csvFile: File(path.join(absoluteCSVDir, "data.csv")),
      ),
      (
        description: 'should resolve absolute csv path 2',
        inSchemaPath: path.join(absoluteSchemaDir, "schema.yaml"),
        inSchema: Schema(
            path.join(absoluteCSVDir, "data.csv"), [Column("a")], ["a"],
            recordSeparator: RecordSeparator.CRLF,
            fieldSeparator: FieldSeparator.COMMA,
            fieldQuote: FieldQuote.DQUOTE),
        csvFile: File(path.join(absoluteCSVDir, "data.csv")),
      ),
    ];

    for (final testcase in testcases) {
      test(testcase.description, () {
        testcase.csvFile
          ..createSync(recursive: true)
          ..writeAsStringSync(csvText);

        final sut = CSVReader(workdir.absolute.path);
        final got = sut.read(testcase.inSchemaPath, testcase.inSchema);

        expect(got, equals(want));
      });
    }
  });
}
