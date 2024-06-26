import 'package:csv_armor/csv/armor/schema/schema.dart';
import 'package:csv_armor/csv/armor/schema_reader.dart';
import 'package:csv_armor/csv/armor/schema_writer.dart';
import 'package:path/path.dart';

class SchemaCache {
  SchemaCache(this._pathContext, this._reader, this._writer);

  final Context _pathContext;
  final SchemaReader _reader;
  final SchemaWriter _writer;

  final Map<String, Schema> _schemaCache = {};

  Context get pathContext => _pathContext;

  String resolveKey(String baseSchemaPath) {
    return _pathContext.canonicalize(baseSchemaPath);
  }

  String resolve(String baseSchemaPath, String path) {
    final schemaPathKey = resolveKey(baseSchemaPath);
    return _pathContext.canonicalize(join(dirname(schemaPathKey), path));
  }

  Schema readSchema(String schemaPath, {bool forceRead = false}) {
    final schemaPathKey = resolveKey(schemaPath);
    final storedSchema = _schemaCache[schemaPathKey];
    if (storedSchema != null && !forceRead) {
      return storedSchema;
    }

    final schema = _reader.read(schemaPathKey);
    return _schemaCache[schemaPathKey] = schema;
  }

  void writeSchema(
    String schemaPath,
    Schema schema, {
    bool forceWrite = true,
    SchemaFormat schemaFormat = SchemaFormat.yaml,
  }) {
    final schemaPathKey = resolveKey(schemaPath);
    final storedSchema = _schemaCache[schemaPathKey];
    if (storedSchema != null && !forceWrite && storedSchema == schema) {
      return;
    }

    _writer.write(schemaPathKey, schema);
    _schemaCache[schemaPath] = schema;
  }
}
