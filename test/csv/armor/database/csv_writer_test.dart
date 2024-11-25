import 'dart:io';

import 'package:csv_armor/csv/armor/io/csv_writer.dart';
import 'package:csv_armor/csv/encoder.dart';
import 'package:csv_armor/csv/encoder_config.dart';
import 'package:csv_armor/csv/record_separator.dart';
import 'package:path/path.dart' as path;
import 'package:test/test.dart';

void main() {
  group('CSVWriter', () {
    final encoder = Encoder(EncoderConfig(
      recordSeparator: RecordSeparator.CRLF,
      fieldSeparator: ",",
      terminatesWithRecordSeparator: false,
      fieldQuote: const EncoderConfigQuote(
        quote: '"',
        quoteEscape: '""',
        always: true,
      ),
    ));
    final workdir =
        (Directory('./test_tmp')..createSync(recursive: true)).createTempSync();

    test('should write CSV file', () {
      const want = '"aaa"';
      final csvFile = File(path.join(workdir.path, "data.csv"));

      final sut = GlobCSVWriter();
      sut.write(
        csvFile.path,
        [
          ['aaa'],
        ],
      );

      final got = csvFile.readAsStringSync();
      expect(got, equals(want));
    });
  });
}
