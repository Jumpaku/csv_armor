import 'dart:collection';

import 'package:sqlite3/sqlite3.dart';

class ResultRow extends MapView<String, dynamic> {
  final List<String> _keys;
  final List<dynamic> _values;

  factory ResultRow.ofMap(Map<String, dynamic> row) {
    return ResultRow(
      keys: row.keys.toList(),
      values: row.keys.map((k) => row[k]).toList(),
    );
  }

  ResultRow({
    required List<String> keys,
    required List<dynamic> values,
  })  : _keys = keys,
        _values = values,
        super({for (final (index, k) in keys.indexed) k: values[index]});

  List<String> keyList() {
    return _keys;
  }

  List<dynamic> valueList() {
    return _values;
  }

  bool isNull(String key) {
    if (!containsKey(key)) {
      throw ArgumentError('Key "$key" not found in ResultRow');
    }
    return this[key] == null;
  }

  bool isNotNull(String key) {
    return !isNull(key);
  }

  T getAs<T>(String key) {
    if (!containsKey(key)) {
      throw ArgumentError('Key "$key" not found in ResultRow');
    }
    final value = this[key];
    if (value is! T) {
      throw ArgumentError('Value for key "$key" is not of type $T');
    }
    return value;
  }
}

class DatabaseAccess {
  factory DatabaseAccess.openInMemory() {
    return DatabaseAccess._(db: sqlite3.openInMemory());
  }

  factory DatabaseAccess.openFile(String path) {
    return DatabaseAccess._(db: sqlite3.open(path));
  }

  DatabaseAccess._({required db}) : _db = db;

  Database _db;

  void close() {
    _db.dispose();
  }

  void define(String ddl) {
    try {
      _db.execute(ddl);
    } catch (e) {
      throw Exception('Failed to execute DDL: $ddl, Error: $e');
    }
  }

  void manip(String dml, [List<dynamic> params = const []]) {
    try {
      _db.execute(dml, params);
    } catch (e) {
      throw Exception(
          'Failed to execute DML: "$dml" with params [${params.join(",")}], Error: $e');
    }
  }

  List<ResultRow> query(String sql, [List<dynamic> params = const []]) {
    try {
      final result = _db.select(sql, params);
      return result
          .map((r) => ResultRow(keys: r.keys, values: r.values))
          .toList();
    } catch (e) {
      throw Exception(
          'Failed to execute query: "$sql" with params [${params.join(",")}], Error: $e');
    }
  }
}
