import 'dart:io';

import 'package:csv_armor/csv/armor/io/csv_reader.dart';
import 'package:csv_armor/csv/decoder.dart';
import 'package:csv_armor/csv/decoder_config.dart';
import 'package:csv_armor/csv/record_separator.dart';
import 'package:path/path.dart' as path;
import 'package:test/test.dart';

void main() {
  group('CSVReader', () {
    final decoder = Decoder(const DecoderConfig(
      fieldSeparator: ",",
      recordSeparator: RecordSeparator.CRLF,
      fieldQuote: const DecoderConfigQuote(
        quote: '"',
        quoteEscape: '""',
      ),
    ));
    final workdir =
        (Directory('./test_tmp')..createSync(recursive: true)).createTempSync();

    test('should write CSV file', () {
      final want = [
        ['aaa']
      ];
      final csvFile = File(path.join(workdir.path, "data.csv"))
        ..createSync(recursive: true);
      csvFile.writeAsStringSync('aaa', flush: true);

      final sut = GlobCSVReader();
      final got = sut.read(csvFile.path);
      expect(got, equals(want));
    });
  });
}
