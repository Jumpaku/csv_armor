import 'dart:io';

import 'package:csv_armor/csv/armor/error.dart';
import 'package:csv_armor/csv/decoder.dart';

class CSVReader {
  CSVReader();

  List<List<String>> read(String csvPath, Decoder decoder) {
    String csvString;
    try {
      final csvFile = File(csvPath);
      csvString = csvFile.readAsStringSync();
    } catch (e) {
      throw FileCacheException(
        "Failed to read CSV file",
        fileCacheErrorCSVReadFailure,
        csvPath,
        cause: e,
      );
    }

    return decoder.decode(csvString);
  }
}
