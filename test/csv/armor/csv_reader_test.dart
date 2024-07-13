import 'dart:io';

import 'package:csv_armor/csv/armor/csv_reader.dart';
import 'package:csv_armor/csv/decoder.dart';
import 'package:csv_armor/csv/field_quote.dart';
import 'package:csv_armor/csv/field_separator.dart';
import 'package:csv_armor/csv/record_separator.dart';
import 'package:path/path.dart' as path;
import 'package:test/test.dart';

void main() {
  group('CSVReader', () {
    final decoder = Decoder(
      recordSeparator: RecordSeparator.CRLF,
      fieldSeparator: FieldSeparator.COMMA,
      fieldQuote: FieldQuote.DQUOTE,
      escapedQuote: FieldQuote.DQUOTE.value() + FieldQuote.DQUOTE.value(),
    );
    final workdir =
        (Directory('./test_tmp')..createSync(recursive: true)).createTempSync();

    test('should write CSV file', () {
      final want = [
        ['aaa']
      ];
      final csvFile = File(path.join(workdir.path, "data.csv"))
        ..createSync(recursive: true);
      csvFile.writeAsStringSync('aaa', flush: true);

      final sut = FileCSVReader();
      final got = sut.read(csvFile.path, decoder);
      expect(got, equals(want));
    });
  });
}
