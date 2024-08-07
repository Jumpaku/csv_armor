import 'dart:io';

import 'package:csv_armor/csv/armor/error.dart';
import 'package:csv_armor/csv/encoder.dart';

abstract interface class CSVWriter {
  void write(String csvPath, List<List<String>> records, Encoder encoder);
}

class FileCSVWriter implements CSVWriter {
  const FileCSVWriter();

  @override
  void write(String csvPath, List<List<String>> records, Encoder encoder) {
    final csvString = encoder.encode(records);

    try {
      (File(csvPath)..createSync(recursive: true)).writeAsStringSync(csvString);
    } catch (e) {
      throw FileCacheException(
        "Failed to write CSV file",
        fileCacheErrorCSVWriteFailure,
        csvPath,
        cause: e,
      );
    }
  }
}
