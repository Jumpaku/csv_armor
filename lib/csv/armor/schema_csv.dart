import 'package:csv_armor/csv/armor/csv_reader.dart';
import 'package:csv_armor/csv/armor/csv_writer.dart';
import 'package:csv_armor/csv/armor/schema/schema.dart';
import 'package:csv_armor/csv/armor/schema_reader.dart';
import 'package:csv_armor/csv/armor/schema_writer.dart';
import 'package:csv_armor/csv/decoder.dart';
import 'package:csv_armor/csv/encoder.dart';
import 'package:path/path.dart' as path;

class SchemaCSV {
  SchemaCSV(this.schema, this.csv);

  final Schema schema;
  final List<List<String>> csv;
}

class SchemaCSVCache {
  SchemaCSVCache(
    this._pathContext,
    this._schemaReader,
    this._schemaWriter,
    this._csvReader,
    this._csvWriter,
  );

  final path.Context _pathContext;

  final SchemaReader _schemaReader;
  final SchemaWriter _schemaWriter;
  final CSVReader _csvReader;
  final CSVWriter _csvWriter;

  final Map<String, SchemaCSV> _cache = {};

  String _resolveKey(String baseSchemaPath) {
    return _pathContext.canonicalize(baseSchemaPath);
  }

  String _resolve(String baseSchemaPath, String targetPath) {
    final schemaPathKey = _resolveKey(baseSchemaPath);
    return _pathContext
        .canonicalize(path.join(path.dirname(schemaPathKey), targetPath));
  }

  void load(List<String> schemaPaths) {
    for (final schemaPath in schemaPaths) {
      final schemaPathKey = _resolveKey(schemaPath);
      final schema = _schemaReader.read(schemaPathKey);
      final decoder = Decoder(
        recordSeparator: schema.recordSeparator,
        fieldSeparator: schema.fieldSeparator,
        fieldQuote: schema.fieldQuote,
        escapedQuote: schema.fieldQuote.value() + schema.fieldQuote.value(),
      );
      final csvPath = _resolve(schemaPathKey, schema.csvPath);
      final csv = _csvReader.read(csvPath, decoder);
      _cache[schemaPathKey] = SchemaCSV(schema, csv);
    }
  }

  void save() {
    _cache.forEach((schemaPathKey, schemaCSV) {
      final encoder = Encoder(
        recordSeparator: schemaCSV.schema.recordSeparator,
        fieldSeparator: schemaCSV.schema.fieldSeparator,
        fieldQuote: schemaCSV.schema.fieldQuote,
      );
      _schemaWriter.write(schemaPathKey, schemaCSV.schema);
      final csvPath = _resolve(schemaPathKey, schemaCSV.schema.csvPath);
      _csvWriter.write(csvPath, schemaCSV.csv, encoder);
    });
  }

  SchemaCSV? operator [](String schemaPath) {
    return _cache[_resolveKey(schemaPath)];
  }

  void operator []=(String schemaPath, SchemaCSV? schemaCSV) {
    if (schemaCSV == null) {
      _cache.remove(_resolveKey(schemaPath));
      return;
    }
    _cache[_resolveKey(schemaPath)] = schemaCSV;
  }

  Iterable<String> getKeys() {
    return _cache.keys;
  }
}
