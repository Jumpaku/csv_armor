import 'dart:io';

import 'package:csv_armor/csv/armor/csv_writer.dart';
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
  group('CSVWriter', () {
    final csvData = [
      ['aaa']
    ];
    final want = 'aaa\r\n';
    final workdir =
        (Directory('./test_tmp')..createSync(recursive: true)).createTempSync();
    final absoluteSchemaDir = workdir.absolute.path;
    final relativeSchemaDir = "./schema";
    final absoluteCSVDir = workdir.absolute.path;
    final relativeCSVDir = "./data";
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

    for (var testcase in testcases) {
      test(testcase.description, () {
        final sut = CSVWriter(workdir.absolute.path);
        sut.write(csvData, testcase.inSchemaPath, testcase.inSchema);

        final got = testcase.csvFile.readAsStringSync();
        expect(got, equals(want));
      });
    }
  });
}
