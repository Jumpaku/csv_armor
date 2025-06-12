import 'package:flutter_test/flutter_test.dart';
import 'package:schema_editor/data/csv_reader.dart';
import 'package:schema_editor/data/data_buffer.dart';
import 'package:schema_editor/data/data_store.dart';
import 'package:schema_editor/schema/schema.dart';
import 'package:schema_editor/sqlite3/database_access.dart';

class FakeDatabaseAccess implements DatabaseAccess {
  final List<String> defined = [];
  final List<String> manipulated = [];
  List<List<Map<String, String>>> queryResults = [];
  List<List<dynamic>> queryParams = [];
  int queryCallCount = 0;

  @override
  void define(String stmt) {
    defined.add(stmt);
  }

  @override
  void manip(String stmt, [List<dynamic> params = const []]) {
    manipulated.add(stmt);
  }

  @override
  List<ResultRow> query(String stmt, [List<dynamic> params = const []]) {
    queryCallCount++;
    queryParams.add(params);
    if (queryResults.isEmpty) return [];
    final result = queryResults.removeAt(0);
    return result.map(ResultRow.ofMap).toList();
  }

  @override
  void close() {}
}

void main() {
  group('DataStore', () {
    late FakeDatabaseAccess db;
    late DataStore store;
    setUp(() {
      db = FakeDatabaseAccess();
      store = DataStore(db: db);
    });

    test('initialize calls define for each table', () {
      final tableConfig = [
        TableConfig(
          name: 't1',
          columns: [TableColumn(name: 'c1')],
          primaryKey: ['c1'],
          uniqueKey: {},
          foreignKey: {},
          csvPath: 't1.csv',
        ),
        TableConfig(
          name: 't2',
          columns: [TableColumn(name: 'c2')],
          primaryKey: ['c2'],
          uniqueKey: {},
          foreignKey: {},
          csvPath: 't2.csv',
        ),
      ];
      store.initialize(tableConfig);
      expect(db.defined.length, 2);
      expect(db.defined[0], contains('CREATE TABLE IF NOT EXISTS "t1"'));
      expect(db.defined[1], contains('CREATE TABLE IF NOT EXISTS "t2"'));
    });

    test('initialize with empty tableConfig does not call define', () {
      store.initialize([]);
      expect(db.defined, isEmpty);
    });

    test('initialize creates table with unique key', () {
      final tableConfig = [
        TableConfig(
          name: 't1',
          columns: [TableColumn(name: 'c1'), TableColumn(name: 'c2')],
          primaryKey: ['c1'],
          uniqueKey: {
            'uk1': ['c2']
          },
          foreignKey: {},
          csvPath: 't1.csv',
        ),
      ];
      store.initialize(tableConfig);
      expect(db.defined.length, 1);
      expect(db.defined[0], contains('CONSTRAINT "uk1" UNIQUE ("c2")'));
    });

    test('initialize creates table with foreign key', () {
      final tableConfig = [
        TableConfig(
          name: 'parent',
          columns: [TableColumn(name: 'id')],
          primaryKey: ['id'],
          uniqueKey: {},
          foreignKey: {},
          csvPath: 'parent.csv',
        ),
        TableConfig(
          name: 'child',
          columns: [TableColumn(name: 'parent_id')],
          primaryKey: ['parent_id'],
          uniqueKey: {},
          foreignKey: {
            'fk1': ForeignKey(
              columns: ['parent_id'],
              reference: ForeignKeyReference(table: 'parent'),
            ),
          },
          csvPath: 'child.csv',
        ),
      ];
      store.initialize(tableConfig);
      expect(db.defined.length, 2);
      final childDef = db.defined[1];
      expect(
          childDef,
          contains(
              'CONSTRAINT "fk1" FOREIGN KEY ("parent_id") REFERENCES "parent" ("id")'));
    });

    test('import calls manip for each table', () {
      final tableConfig = [
        TableConfig(
          name: 't1',
          columns: [TableColumn(name: 'c1')],
          primaryKey: ['c1'],
          uniqueKey: {},
          foreignKey: {},
          csvPath: 't1.csv',
        ),
      ];
      final buffer = DataBuffer({
        't1': (
          columns: ['c1'],
          values: [
            <String>['v1']
          ]
        )
      });
      store.import(tableConfig, buffer);
      expect(db.manipulated.length, 1);
      expect(db.manipulated[0], contains('INSERT INTO "t1"'));
      expect(db.manipulated[0], contains("('v1')"));
    });

    test('import with empty tableConfig does not call manip', () {
      final buffer = DataBuffer({});
      store.import([], buffer);
      expect(db.manipulated, isEmpty);
    });

    test('import with multiple tables', () {
      final tableConfig = [
        TableConfig(
          name: 't1',
          columns: [TableColumn(name: 'c1')],
          primaryKey: ['c1'],
          uniqueKey: {},
          foreignKey: {},
          csvPath: 't1.csv',
        ),
        TableConfig(
          name: 't2',
          columns: [TableColumn(name: 'c2')],
          primaryKey: ['c2'],
          uniqueKey: {},
          foreignKey: {},
          csvPath: 't2.csv',
        ),
      ];
      final buffer = DataBuffer({
        't1': (
          columns: ['c1'],
          values: [
            <String>['v1']
          ]
        ),
        't2': (
          columns: ['c2'],
          values: [
            <String>['v2']
          ]
        )
      });
      store.import(tableConfig, buffer);
      expect(db.manipulated.length, 2);
      expect(db.manipulated[0], contains('INSERT INTO "t1"'));
      expect(db.manipulated[1], contains('INSERT INTO "t2"'));
    });

    test('import with multiple records for a table', () {
      final tableConfig = [
        TableConfig(
          name: 't1',
          columns: [TableColumn(name: 'c1')],
          primaryKey: ['c1'],
          uniqueKey: {},
          foreignKey: {},
          csvPath: 't1.csv',
        ),
      ];
      final buffer = DataBuffer({
        't1': (
          columns: ['c1'],
          values: [
            <String>['v1'],
            <String>['v2']
          ]
        )
      });
      store.import(tableConfig, buffer);
      expect(db.manipulated.length, 1);
      expect(db.manipulated[0], contains("('v1')"));
      expect(db.manipulated[0], contains("('v2')"));
    });

    test('import does not call manip if there are no rows', () {
      final tableConfig = [
        TableConfig(
          name: 't1',
          columns: [TableColumn(name: 'c1')],
          primaryKey: ['c1'],
          uniqueKey: {},
          foreignKey: {},
          csvPath: 't1.csv',
        ),
      ];
      final buffer = DataBuffer({
        't1': (columns: ['c1'], values: <List<String>>[])
      });
      store.import(tableConfig, buffer);
      expect(db.manipulated, isEmpty);
    });

    test('query returns columns and rows from db', () {
      db.queryResults = [
        [
          {'a': '1', 'b': '2'},
          {'a': '3', 'b': '4'},
        ]
      ];
      final result = store.query('SELECT * FROM t', []);
      expect(result.columns, ['a', 'b']);
      expect(result.rows, [
        ['1', '2'],
        ['3', '4'],
      ]);
    });

    test('query returns empty if db returns empty', () {
      db.queryResults = [[]];
      final result = store.query('SELECT * FROM t', []);
      expect(result.columns, isEmpty);
      expect(result.rows, isEmpty);
    });

    test('query passes params to db and returns correct result', () {
      db.queryResults = [
        [
          {'x': 'y'}
        ]
      ];
      final result = store.query('SELECT * FROM t WHERE x=?', ['y']);
      expect(result.columns, ['x']);
      expect(result.rows, [
        ['y'],
      ]);
      expect(db.queryParams.last, ['y']);
    });
  });
}
