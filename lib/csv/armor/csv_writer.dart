import 'dart:io';

import 'package:csv_armor/csv/armor/error.dart';
import 'package:csv_armor/csv/armor/schema/schema.dart';
import 'package:csv_armor/csv/encoder.dart';
import 'package:path/path.dart' as path;

class CSVWriter {
  CSVWriter(String workingPath) : _workingPath = path.normalize(workingPath) {
    if (!path.isAbsolute(_workingPath)) {
      throw ArgumentError(
          "Working path must be an absolute path", "absoluteWorkingPath");
    }
  }

  final String _workingPath;

  void write(List<List<String>> records, String schemaPath, Schema schema) {
    Encoder encoder = Encoder(
      recordSeparator: schema.recordSeparator,
      fieldSeparator: schema.fieldSeparator,
      fieldQuote: schema.fieldQuote,
    );

    final csvString = encoder.encode(records);

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

      final csvFile = File(absoluteCSVPath)..createSync(recursive: true);
      csvFile.writeAsStringSync(csvString, flush: true);
    } catch (e) {
      throw ReadWriteException(
        "Failed to write CSV file",
        readWriteErrorCSVWriteFailure,
        schema.csvPath,
        absoluteSchemaPath,
        cause: e,
      );
    }
  }
}
