import 'dart:collection';
import 'dart:io';

import 'package:glob/glob.dart';
import 'package:glob/list_local_fs.dart';
import 'package:path/path.dart';
import 'package:schema_editor/csv/decoder.dart';
import 'package:schema_editor/data/data_exception.dart';
import 'package:schema_editor/schema/schema.dart';

typedef TableData = ({List<String> columns, List<List<String>> values});

class DataBuffer extends MapView<String, TableData> {
  DataBuffer(Map<String, TableData> tableData) : super(tableData);
}

class CsvReader {
  CsvReader({required Context ctx, required Decoder decoder})
      : _ctx = ctx,
        _decoder = decoder;

  final Context _ctx;
  final Decoder _decoder;

  DataBuffer readAll(List<TableConfig> tableConfig) {
    Map<String, TableData> tableData = {};
    for (final t in tableConfig) {
      final columns =
          _reorderColumns(t.csvPath, t.columns.map((c) => c.name).toList());
      final values = _readValues(t.name, t.csvPath);

      tableData[t.name] = (columns: columns, values: values);
    }

    return DataBuffer(tableData);
  }

  List<String> _reorderColumns(String csvPath, List<String> columns) {
    // Extract path columns from csvPath
    final pathColumns = <String>[];
    final matches = _csvPathPlaceholderRegExp.allMatches(csvPath);
    for (final match in matches) {
      final placeholder = match.group(0)!;
      final colName = placeholder.substring(1, placeholder.length - 1);
      pathColumns.add(colName);
    }

    // Extract csv columns from table config
    final csvColumns = <String>[];
    for (final col in columns) {
      if (!pathColumns.contains(col)) {
        csvColumns.add(col);
      }
    }

    return pathColumns + csvColumns;
  }

  List<List<String>> _readValues(String tableName, String schemaCsvPath) {
    final csvPathGlob =
        schemaCsvPath.replaceAll(_csvPathPlaceholderRegExp, '*');

    List<File> csvFiles = _listCsvFiles(tableName, csvPathGlob);

    final values = <List<String>>[];
    for (final csvFile in csvFiles) {
      // Extract path values from csvPath
      List<String> pathValues = _extractPathValues(schemaCsvPath, csvFile.path);

      // Decode CSV content
      final records = _decodeCsvValues(tableName, csvFile);

      for (final csvValues in records) {
        values.add(pathValues + csvValues);
      }
    }

    return values;
  }

  List<File> _listCsvFiles(String tableName, String csvPathGlob) {
    try {
      final glob = Glob(csvPathGlob, context: _ctx);
      return glob.listSync().whereType<File>().toList();
    } catch (e) {
      throw DataException(
        'failed to find CSV files: glob="$csvPathGlob": ${e.toString()}',
        DataException.codeInvalidCsvFailed,
      );
    }
  }

  List<String> _extractPathValues(String csvPath, String csvFilePath) {
    // <placeholder-value> := character sequence excluding '[', ']', '/', and '*'
    final csvPathRegexp = RegExp(
        '^${csvPath.replaceAll(_csvPathPlaceholderRegExp, r'([^*\/\[\]]*)')}\$');
    final match = csvPathRegexp.firstMatch(csvFilePath)!;
    return [for (int i = 1; i <= match.groupCount; i++) match.group(i)!];
  }

  List<List<String>> _decodeCsvValues(String tableName, File csvFile) {
    try {
      final content = csvFile.readAsStringSync();
      final (headers: _, records: records) = _decoder.decode(content);
      return records;
    } catch (e) {
      throw DataException(
        'failed to decode CSV file: table: "$tableName", path="${csvFile.path}": ${e.toString()}',
        DataException.codeInvalidCsvFailed,
      );
    }
  }
}

// <placeholder> := '[' <text> ']'
// <text> := character sequence excluding '[', ']', '/', and '*'
final _csvPathPlaceholderRegExp = RegExp(r'\[[^*\/\[\]]+\]');
