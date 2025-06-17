import 'dart:collection';

import 'package:schema_editor/data/buffer.dart';
import 'package:schema_editor/data/data_store_exception.dart';
import 'package:schema_editor/schema/schema.dart';
import 'package:schema_editor/sqlite3/database_access.dart';

class DataStore {
  DataStore({required DatabaseAccess db}) : _db = db;

  final DatabaseAccess _db;

  void initialize(List<TableConfig> tableConfig) {
    final tableMap = {for (final t in tableConfig) t.name: t};
    for (final t in tableConfig) {
      final stmt = _createTable(tableMap, t);
      try {
        _db.define(stmt);
      } catch (e) {
        throw DataStoreException(
          'Failed to create table "${t.name}": ${e.toString()}',
          stmt,
          tableName: t.name,
          cause: e,
        );
      }
    }
  }

  void import(List<TableConfig> tableConfig, DataBuffer buffer) {
    for (final t in tableConfig) {
      final data = buffer[t.name]!;
      if (data.records.isEmpty) {
        continue;
      }
      final stmt = _insertValues(t, buffer[t.name]!);
      try {
        _db.manip(stmt);
      } catch (e) {
        throw DataStoreException(
          'Failed to insert data into table "${t.name}": ${e.toString()}',
          stmt,
          tableName: t.name,
          cause: e,
        );
      }
    }
  }

  ({List<String> columns, List<List<String>> rows}) query(String stmt,
      [List<dynamic> params = const []]) {
    List<ResultRow> result;
    try {
      result = _db.query(stmt, params);
    } catch (e) {
      throw DataStoreException(
        'Failed to execute query: "$stmt" with params [${params.join(",")}]: ${e.toString()}',
        stmt,
        params: params,
        cause: e,
      );
    }

    if (result.isEmpty) {
      return (columns: [], rows: []);
    }
    final columns = result[0].keys.toList();
    final rows = [
      for (final row in result)
        [for (final key in row.keys) row.getAs<String>(key)]
    ];

    return (columns: columns, rows: rows);
  }

  String _createTable(Map<String, TableConfig> tableMap, TableConfig t) {
    final sb = StringBuffer();
    sb.writeln('CREATE TABLE IF NOT EXISTS "${t.name}" (');
    for (final col in t.columns) {
      sb.writeln('  "${col.name}" TEXT NOT NULL,');
    }
    for (final uk in t.uniqueKey.entries) {
      final name = uk.key;
      final ukColumns = uk.value.map((pk) => '"$pk"').join(", ");
      sb.writeln('  CONSTRAINT "$name" UNIQUE ($ukColumns),');
    }
    for (final fk in t.foreignKey.entries) {
      final name = fk.key;
      final fkColumns = fk.value.columns.map((pk) => '"$pk"').join(", ");
      final fkRef = fk.value.reference;
      final refTable = tableMap[fkRef.table]!;
      final refKey = fkRef.uniqueKey == null
          ? refTable.primaryKey
          : refTable.uniqueKey[fkRef.uniqueKey]!;
      final refColumns = refKey.map((pk) => '"$pk"').join(", ");
      sb.writeln(
          '  CONSTRAINT "$name" FOREIGN KEY ($fkColumns) REFERENCES "${refTable.name}" ($refColumns),');
    }
    final pkColumns = t.primaryKey.map((pk) => '"$pk"').join(", ");
    sb.writeln('  PRIMARY KEY ($pkColumns)');
    sb.writeln(');');

    return sb.toString();
  }

  String _insertValues(TableConfig t, TableData d) {
    final (columns: columns, records: records) = d;

    final sb = StringBuffer();
    final cols = columns.map((col) => '"$col"').join(", ");
    sb.writeln('INSERT INTO "${t.name}" ($cols) VALUES ');
    for (final (index, records) in records.indexed) {
      if (index > 0) {
        sb.writeln(',');
      }
      final row = records.map((v) => "'${v.replaceAll("'", "''")}'").join(", ");
      sb.write('  ($row)');
    }
    sb.writeln(';');

    return sb.toString();
  }
}
