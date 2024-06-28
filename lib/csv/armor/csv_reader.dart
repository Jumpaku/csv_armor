import 'dart:io';

import 'package:csv_armor/csv/armor/error.dart';
import 'package:csv_armor/csv/armor/schema/schema.dart';
import 'package:csv_armor/csv/decoder.dart';
import 'package:path/path.dart' as path;

class CSVReader {
  CSVReader(String absoluteWorkingPath)
      : _workingPath = path.normalize(absoluteWorkingPath) {
    if (!path.isAbsolute(_workingPath)) {
      throw ArgumentError(
          "Working path must be an absolute path", "absoluteWorkingPath");
    }
  }

  final String _workingPath;

  List<List<String>> read(String schemaPath, Schema schema) {
    String csvString;
    String absoluteSchemaPath = path.normalize(schemaPath);
    String absoluteCSVPath = path.normalize(schema.csvPath);
    try {
      if (path.isRelative(absoluteSchemaPath)) {
        absoluteSchemaPath =
            path.normalize(path.join(_workingPath, schemaPath));
      }
      if (path.isRelative(absoluteCSVPath)) {
        absoluteCSVPath = path.normalize(
            path.join(path.dirname(absoluteSchemaPath), schema.csvPath));
      }

      final csvFile = File(absoluteCSVPath);
      csvString = csvFile.readAsStringSync();
    } catch (e) {
      throw ReadWriteException(
        "Failed to read CSV file",
        readWriteErrorCSVReadFailure,
        schema.csvPath,
        absoluteSchemaPath,
        cause: e,
      );
    }

    Decoder decoder = Decoder(
      recordSeparator: schema.recordSeparator,
      fieldSeparator: schema.fieldSeparator,
      fieldQuote: schema.fieldQuote,
      escapedQuote: schema.fieldQuote.value() + schema.fieldQuote.value(),
    );

    return decoder.decode(csvString);
  }
}
