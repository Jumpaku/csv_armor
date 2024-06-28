import 'package:collection/collection.dart';
import 'package:csv_armor/csv/armor/csv_reader.dart';
import 'package:csv_armor/csv/armor/csv_writer.dart';
import 'package:csv_armor/csv/armor/schema_cache.dart';
import 'package:csv_armor/csv/decoder.dart';
import 'package:csv_armor/csv/encoder.dart';
import 'package:path/path.dart';

class CSVCache {
  CSVCache(SchemaCache schemaCache, this._reader, this._writer)
      : _schemaCache = schemaCache;

  final SchemaCache _schemaCache;
  final CSVReader _reader;
  final CSVWriter _writer;

  final Map<String, List<List<String>>> _csvCache = {};

  List<List<String>> readCSV(String schemaPath, {bool forceRead = false}) {
    final schemaPathKey = _schemaCache.pathContext.canonicalize(schemaPath);
    final storedCSV = _csvCache[schemaPathKey];
    if (storedCSV != null && !forceRead) {
      return storedCSV;
    }

    final schema = _schemaCache.readSchema(schemaPathKey, forceRead: forceRead);
    final csvPath = _schemaCache.pathContext
        .canonicalize(join(dirname(schemaPathKey), schema.csvPath));

    final decoder = Decoder(
      recordSeparator: schema.recordSeparator,
      fieldSeparator: schema.fieldSeparator,
      fieldQuote: schema.fieldQuote,
      escapedQuote: schema.fieldQuote.value() + schema.fieldQuote.value(),
    );

    return _csvCache[schemaPathKey] = _reader.read(csvPath, decoder);
  }

  void writeCSV(String schemaPath, List<List<String>> csv,
      {bool forceWrite = false}) {
    final schemaPathKey = _schemaCache.pathContext.canonicalize(schemaPath);
    final storedCSV = _csvCache[schemaPathKey];
    const csvEquals = ListEquality<List<String>>(ListEquality<String>());
    if (storedCSV != null && !forceWrite && csvEquals.equals(storedCSV, csv)) {
      return;
    }

    final schema = _schemaCache.readSchema(schemaPathKey);
    final csvPath = _schemaCache.pathContext
        .canonicalize(join(dirname(schemaPathKey), schema.csvPath));

    final encoder = Encoder(
      recordSeparator: schema.recordSeparator,
      fieldSeparator: schema.fieldSeparator,
      fieldQuote: schema.fieldQuote,
      forceQuote: schema.fieldQuote != FieldQuote.NONE,
    );

    _writer.write(csvPath, csv, encoder);
    _csvCache[schemaPathKey] = csv;
  }
}
