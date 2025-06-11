import 'dart:collection';

import 'package:schema_editor/csv/csv_reader.dart';
import 'package:schema_editor/schema/schema.dart';

// <placeholder> := '[' <text> ']'
// <text> := character sequence excluding '[', ']', '/', and '*'
final _csvPathPlaceholderRegExp = RegExp(r'\[[^*\/\[\]]+\]');

typedef TableData = ({List<String> columns, List<List<String>> values});

class DataBuffer extends MapView<String, TableData> {
  factory DataBuffer.load(List<TableConfig> tableConfig, CsvReader reader) {
    Map<String, TableData> tableData = {};
    for (final t in tableConfig) {
      final columns =
          _reorderColumns(t.csvPath, t.columns.map((c) => c.name).toList());
      final values = _readValues(reader, t.csvPath);

      tableData[t.name] = (columns: columns, values: values);
    }
    return DataBuffer(tableData);
  }

  DataBuffer(Map<String, TableData> tableData) : super(tableData);

  static List<String> _reorderColumns(String csvPath, List<String> columns) {
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

    return csvColumns + pathColumns;
  }

  static List<List<String>> _readValues(CsvReader reader, String csvPath) {
    final csvPathGlob = csvPath.replaceAll(_csvPathPlaceholderRegExp, '*');
    final data = reader.readAll(csvPathGlob);
    final values = <List<String>>[];
    for (final (path: path, headers: _, records: records) in data) {
      // <placeholder-value> := character sequence excluding '[', ']', '/', and '*'
      final csvPathRegexp = RegExp(
          '^${csvPath.replaceAll(_csvPathPlaceholderRegExp, r'([^*\/\[\]]*)')}\$');
      final match = csvPathRegexp.firstMatch(path)!;
      final pathValues = [
        for (int i = 1; i <= match.groupCount; i++) match.group(i)!
      ];
      for (final csvValues in records) {
        values.add(csvValues + pathValues);
      }
    }

    return values;
  }
}
