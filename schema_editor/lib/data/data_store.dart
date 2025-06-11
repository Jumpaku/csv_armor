import 'package:schema_editor/csv/csv_reader.dart';
import 'package:schema_editor/schema/schema.dart';
import 'package:schema_editor/sqlite3/database_access.dart';

// <placeholder> := '[' <text> ']'
// <text> := character sequence excluding '[', ']', '/', and '*'
final _csvPathPlaceholderRegExp = RegExp(r'\[[^*\/\[\]]+\]');

class DataStore {
  DataStore({required DatabaseAccess db}) : _db = db;

  final DatabaseAccess _db;

  void initialize(List<TableConfig> tableConfig, CsvReader reader) {
    final tableMap = {for (final t in tableConfig) t.name: t};
    for (final t in tableConfig) {
      final stmt = _createTable(tableMap, t);
      _db.define(stmt);
    }
  }

  void import(List<TableConfig> tableConfig, CsvReader reader) {
    for (final t in tableConfig) {
      final stmt = _insertValues(reader, t);
      _db.manip(stmt);
    }
  }

  ({List<String> columns, List<List<String>> rows}) query(String stmt,
      [List<dynamic> params = const []]) {
    final result = _db.query(stmt, params);
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

  String _insertValues(CsvReader reader, TableConfig t) {
    final columns =
        _reorderColumns(t.csvPath, t.columns.map((c) => c.name).toList());
    final values = _readValues(reader, t.csvPath);

    final sb = StringBuffer();
    final cols = columns.map((col) => '"$col"').join(", ");
    sb.writeln('INSERT INTO "${t.name}" ($cols) VALUES ');
    for (final (index, values) in values.indexed) {
      if (index > 0) {
        sb.writeln(',');
      }
      final row = values.map((v) => "'${v.replaceAll("'", "''")}'").join(", ");
      sb.write('  ($row)');
    }
    sb.writeln(';');

    return sb.toString();
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

    return csvColumns + pathColumns;
  }

  List<List<String>> _readValues(CsvReader reader, String csvPath) {
    final csvPathGlob = csvPath.replaceAll(_csvPathPlaceholderRegExp, '*');
    final data = reader.readAll(csvPathGlob);
    final values = <List<String>>[];
    for (final (path: path, headers: _, records: records) in data) {
      final matches = csvPathGlob.allMatches(path);
      final pathValues = [for (final match in matches) match.group(0)!];
      for (final csvValues in records) {
        values.add(csvValues + pathValues);
      }
    }

    return values;
  }
}
