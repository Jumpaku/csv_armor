import 'package:csv_armor/csv/armor/csv_reader.dart';
import 'package:csv_armor/csv/armor/csv_writer.dart';
import 'package:csv_armor/csv/armor/schema/schema.dart';
import 'package:csv_armor/csv/armor/schema_reader.dart';
import 'package:csv_armor/csv/armor/schema_writer.dart';
import 'package:csv_armor/csv/decoder.dart';
import 'package:csv_armor/csv/decoder_config.dart';
import 'package:csv_armor/csv/encoder.dart';
import 'package:csv_armor/csv/encoder_config.dart';
import 'package:csv_armor/csv/record_separator.dart';
import 'package:path/path.dart' as path;

class SchemaCSV {
  SchemaCSV(this.schema, this.csv);

  final Schema schema;
  final List<List<String>> csv;
}

class SchemaCSVCache {
  SchemaCSVCache(
    this.pathContext,
    this._schemaReader,
    this._schemaWriter,
    this._csvReader,
    this._csvWriter,
  );

  final path.Context pathContext;

  final SchemaReader _schemaReader;
  final SchemaWriter _schemaWriter;
  final CSVReader _csvReader;
  final CSVWriter _csvWriter;

  final Map<String, SchemaCSV> _cache = {};

  String resolveKey(String baseSchemaPath) {
    return pathContext.canonicalize(baseSchemaPath);
  }

  String resolveFromSchema(String baseSchemaPath, String targetPath) {
    final schemaPathKey = resolveKey(baseSchemaPath);
    return pathContext
        .canonicalize(path.join(path.dirname(schemaPathKey), targetPath));
  }

  void load(List<String> schemaPaths) {
    for (final schemaPath in schemaPaths) {
      final schemaPathKey = resolveKey(schemaPath);
      final schema = _schemaReader.read(schemaPathKey);
      final decoder = Decoder(const DecoderConfig());
      final csvPath = resolveFromSchema(schemaPathKey, schema.csvPath);
      final csv = _csvReader.read(csvPath, decoder);
      _cache[schemaPathKey] = SchemaCSV(schema, csv);
    }
  }

  void save() {
    _cache.forEach((schemaPathKey, schemaCSV) {
      final encoder = Encoder(EncoderConfig(
        recordSeparator: RecordSeparator.CRLF,
        terminatesWithRecordSeparator: false,
        fieldSeparator: ",",
        fieldQuote: const EncoderConfigQuote(
          quote: '"',
          quoteEscape: '""',
          always: false,
        ),
      ));
      _schemaWriter.write(schemaPathKey, schemaCSV.schema);
      final csvPath =
          resolveFromSchema(schemaPathKey, schemaCSV.schema.csvPath);
      _csvWriter.write(csvPath, schemaCSV.csv, encoder);
    });
  }

  SchemaCSV? operator [](String schemaPath) {
    return _cache[resolveKey(schemaPath)];
  }

  void operator []=(String schemaPath, SchemaCSV? schemaCSV) {
    if (schemaCSV == null) {
      _cache.remove(resolveKey(schemaPath));
      return;
    }
    _cache[resolveKey(schemaPath)] = schemaCSV;
  }

  Iterable<String> getKeys() {
    return _cache.keys;
  }
}
