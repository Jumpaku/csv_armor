import 'dart:collection';

import 'package:sqlite3/sqlite3.dart';

class ResultRow extends MapView<String, dynamic> {
  final Row row;

  ResultRow(this.row) : super({for (final k in row.keys) k: row[k]});

  List<String> keyList() {
    return row.keys;
  }

  List<dynamic> valueList() {
    return row.values;
  }

  bool isNull(String key) {
    if (!row.containsKey(key)) {
      throw ArgumentError('Key "$key" not found in ResultRow');
    }
    return row[key] == null;
  }

  bool isNotNull(String key) {
    return !isNull(key);
  }

  T getAs<T>(String key) {
    if (!row.containsKey(key)) {
      throw ArgumentError('Key "$key" not found in ResultRow');
    }
    final value = row[key];
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
      return result.map((r) => ResultRow(r)).toList();
    } catch (e) {
      throw Exception(
          'Failed to execute query: "$sql" with params [${params.join(",")}], Error: $e');
    }
  }
}
