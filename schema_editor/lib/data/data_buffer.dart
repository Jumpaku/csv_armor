import 'dart:collection';

import 'package:schema_editor/data/index.dart';
import 'package:schema_editor/schema/schema.dart';

typedef TableData = ({List<String> columns, List<List<String>> values});

class DataBuffer extends MapView<String, TableData> {
  DataBuffer(Map<String, TableData> tableData) : super(tableData);

  Map<String, Map<String, Index>> buildIndex(List<TableConfig> tableConfig) {
    Map<String, Map<String, Index>> indexes = {};
    for (final t in tableConfig) {
      final columnIdx = {
        for (final (idx, column) in t.columns.indexed) column.name: idx,
      };
      final data = this[t.name]!.values;

      Map<String, Index> index = {};

      // Create indexes for unique keys
      for (final uk in t.uniqueKey.entries) {
        index[uk.key] = _buildIndex(uk.value, columnIdx, data);
      }

      // Create index for primary key
      index[''] = _buildIndex(t.primaryKey, columnIdx, data);

      indexes[t.name] = index;
    }
    return indexes;
  }

  Index _buildIndex(
      List<String> key, Map<String, int> columnIdx, List<List<String>> data) {
    final index = Index();
    final ukColumns = key.map((col) => columnIdx[col]!);
    for (final row in data) {
      index.add(Key([for (final i in ukColumns) row[i]]), row);
    }
    return index;
  }
}
