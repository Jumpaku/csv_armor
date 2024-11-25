import 'dart:io';

import 'package:csv_armor/csv/decoder.dart';
import 'package:csv_armor/csv/decoder_config.dart';
import 'package:glob/glob.dart';
import 'package:glob/list_local_fs.dart';
import 'package:path/path.dart';

abstract interface class CSVReader {
  List<List<String>> read(String csvPath);
}

class GlobCSVReader implements CSVReader {
  GlobCSVReader({
    Context? ctx,
    Decoder? decoder,
  }) : _ctx = ctx ?? Context(),
       _decoder = decoder ?? Decoder(const DecoderConfig());

  final Context _ctx;
  final Decoder _decoder;

  @override
  List<List<String>> read(String csvPath) {
    final csv = <List<String>>[];
    final csvGlob = Glob(csvPath, context: _ctx);
    for (final csvFile in csvGlob.listSync()) {
      if (csvFile is! File) {}
      final m = csvGlob.matchAsPrefix(csvFile.path);
      if (m == null) {
        throw Exception('Failed to load csv: $csvPath');
      }
      final pathVal = [for (int n = 1; n <= m.groupCount; n++) m.group(n)!];
      final content = (csvFile as File).readAsStringSync();
      final rows = _decoder.decode(content);

      csv.addAll(rows.map((r) => r..addAll(pathVal)));
    }
    return csv;
  }
}
