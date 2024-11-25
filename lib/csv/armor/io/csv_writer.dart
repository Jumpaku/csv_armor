import 'dart:io';

import 'package:collection/collection.dart';
import 'package:csv_armor/csv/encoder.dart';
import 'package:csv_armor/csv/encoder_config.dart';
import 'package:path/path.dart';

abstract interface class CSVWriter {
  void write(String csvPath, List<List<String>> records,
      {List<List<String>> headers = const []});
}

class GlobCSVWriter implements CSVWriter {
  GlobCSVWriter({
    Context? ctx,
    Encoder? encoder,
  })  : _ctx = ctx ?? Context(),
        _encoder = encoder ?? Encoder(EncoderConfig());

  final Context _ctx;
  final Encoder _encoder;

  @override
  void write(String csvPath, List<List<String>> records,
      {List<List<String>> headers = const []}) {
    final asterisks = '*'.allMatches(csvPath);
    final n = asterisks.length;
    final recordGroups =
        groupBy(records, (r) => r.sublist(r.length - n, r.length));

    for (final key in recordGroups.keys) {
      var path = csvPath;
      for (final k in key) {
        path = path.replaceFirst('*', k);
      }
      final records =
          recordGroups[key]!.map((r) => r.sublist(0, r.length - n)).toList();
      final csvString = _encoder.encode(headers..addAll(records));

      final f = (File(_ctx.canonicalize(path))..createSync(recursive: true));
      f.writeAsStringSync(csvString, flush: true);
    }
  }
}
