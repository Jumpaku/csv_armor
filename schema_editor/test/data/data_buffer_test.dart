import 'package:flutter_test/flutter_test.dart';
import 'package:schema_editor/data/data_buffer.dart';
import 'package:schema_editor/schema/schema.dart';
import 'package:schema_editor/csv/csv_reader.dart';

class FakeCsvReader implements CsvReader {
  List<PathRecords> results = [];
  @override
  List<PathRecords> readAll(String csvPathGlob) => results;
}

void main() {
  group('DataBuffer', () {
    late FakeCsvReader reader;
    setUp(() {
      reader = FakeCsvReader();
    });

    test('load with empty tableConfig', () {
      final buffer = DataBuffer.load([], reader);
      expect(buffer.keys, isEmpty);
    });

    test('load with multiple records', () {
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
      reader.results = [(
        path: 't1.csv',
        headers: [['c1']],
        records: [<String>['v1'], <String>['v2']]
      )];
      final buffer = DataBuffer.load(tableConfig, reader);
      expect(buffer['t1']!.values, [
        ['v1'],
        ['v2'],
      ]);
    });

    test('load with path placeholders in csvPath', () {
      final tableConfig = [
        TableConfig(
          name: 't1',
          columns: [TableColumn(name: 'c1'), TableColumn(name: 'c2')],
          primaryKey: ['c1'],
          uniqueKey: {},
          foreignKey: {},
          csvPath: 'data_[c2].csv',
        ),
      ];
      reader.results = [(
        path: 'data_foo.csv',
        headers: [['c1']],
        records: [<String>['v1']]
      )];
      final buffer = DataBuffer.load(tableConfig, reader);
      expect(buffer['t1']!.columns, ['c1', 'c2']);
      expect(buffer['t1']!.values, [
        ['v1', 'foo'],
      ]);
    });

    test('load with multiple path placeholders in csvPath', () {
      final tableConfig = [
        TableConfig(
          name: 't1',
          columns: [TableColumn(name: 'c1'), TableColumn(name: 'c2'), TableColumn(name: 'c3')],
          primaryKey: ['c1'],
          uniqueKey: {},
          foreignKey: {},
          csvPath: 'data_[c2]_[c3].csv',
        ),
      ];
      reader.results = [(
        path: 'data_foo_bar.csv',
        headers: [['c1']],
        records: [<String>['v1']]
      )];
      final buffer = DataBuffer.load(tableConfig, reader);
      expect(buffer['t1']!.columns, ['c1', 'c2', 'c3']);
      expect(buffer['t1']!.values, [
        ['v1', 'foo', 'bar'],
      ]);
    });

    test('load with missing path placeholder value in csvPath', () {
      final tableConfig = [
        TableConfig(
          name: 't1',
          columns: [TableColumn(name: 'c1'), TableColumn(name: 'c2')],
          primaryKey: ['c1'],
          uniqueKey: {},
          foreignKey: {},
          csvPath: 'data_[c2].csv',
        ),
      ];
      reader.results = [(
        path: 'data_.csv', // missing value for c2
        headers: [['c1']],
        records: [<String>['v1']]
      )];
      final buffer = DataBuffer.load(tableConfig, reader);
      expect(buffer['t1']!.values, [
        ['v1', ''],
      ]);
    });

    test('load with extra values in path for placeholders', () {
      final tableConfig = [
        TableConfig(
          name: 't1',
          columns: [TableColumn(name: 'c1'), TableColumn(name: 'c2')],
          primaryKey: ['c1'],
          uniqueKey: {},
          foreignKey: {},
          csvPath: 'data_[c2].csv',
        ),
      ];
      reader.results = [(
        path: 'data_foo_bar.csv', // extra value after expected placeholder
        headers: [['c1']],
        records: [<String>['v1']]
      )];
      final buffer = DataBuffer.load(tableConfig, reader);
      expect(buffer['t1']!.values, [
        ['v1', 'foo_bar'],
      ]);
    });
  });
}
