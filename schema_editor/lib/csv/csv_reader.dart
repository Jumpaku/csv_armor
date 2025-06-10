import 'dart:io';

import 'package:glob/glob.dart';
import 'package:glob/list_local_fs.dart';
import 'package:path/path.dart';
import 'package:schema_editor/csv/decoder.dart';

typedef PathRecords = ({String path, List<List<String>> records});

class GlobCSVReader {
  GlobCSVReader({required Context ctx, required Decoder decoder})
      : _ctx = ctx,
        _decoder = decoder;

  final Context _ctx;
  final Decoder _decoder;

  List<PathRecords> readAll(String csvPathGlob) {
    final result = <PathRecords>[];
    final csvGlob = Glob(csvPathGlob, context: _ctx);
    final csvFiles = csvGlob.listSync().whereType<File>().toList();
    for (final csvFile in csvFiles) {
      final content = csvFile.readAsStringSync();
      final records = _decoder.decode(content);

      result.add((path: csvFile.path, records: records));
    }

    result.sort((a, b) => a.path.compareTo(b.path));

    return result;
  }
}
