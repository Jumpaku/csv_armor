import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:schema_editor/csv/decoder.dart';
import 'package:schema_editor/data/csv_reader.dart';
import 'package:schema_editor/schema/schema.dart';

class TestDecoder implements Decoder {
  @override
  ({List<List<String>> headers, List<List<String>> records}) decode(
      String content) {
    final data = content
        .split('\n')
        .where((l) => l.isNotEmpty)
        .map((l) => l.split(','))
        .toList();
    return (headers: [], records: data);
  }
}

void main() {
  group('CsvReader', () {
    late Directory tempDir;
    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('csv_reader_test');
    });
    tearDown(() async {
      await tempDir.delete(recursive: true);
    });
    test('readAll returns empty buffer for empty tableConfig', () {
      final reader = CsvReader(ctx: p.Context(), decoder: TestDecoder());
      final buffer = reader.readAll([]);
      expect(buffer.keys, isEmpty);
    });
    test('readAll loads multiple records', () async {
      final file = p.join(tempDir.path, 't1.csv');
      await File(file).writeAsString('v1\nv2\n');
      final tableConfig = [
        TableConfig(
          name: 't1',
          columns: [TableColumn(name: 'c1')],
          primaryKey: ['c1'],
          csvPath: file,
        ),
      ];
      final reader = CsvReader(ctx: p.Context(), decoder: TestDecoder());
      final buffer = reader.readAll(tableConfig);
      expect(buffer['t1']!.values, [
        ['v1'],
        ['v2'],
      ]);
    });
    test('readAll loads with path placeholders in csvPath', () async {
      final file = p.join(tempDir.path, 'data_foo.csv');
      await File(file).writeAsString('v1\n');
      final tableConfig = [
        TableConfig(
          name: 't1',
          columns: [TableColumn(name: 'c1'), TableColumn(name: 'c2')],
          primaryKey: ['c1'],
          csvPath: p.join(tempDir.path, 'data_[c2].csv'),
        ),
      ];
      final reader = CsvReader(ctx: p.Context(), decoder: TestDecoder());
      final buffer = reader.readAll(tableConfig);
      expect(buffer['t1']!.columns, ['c2', 'c1']);
      expect(buffer['t1']!.values, [
        ['foo', 'v1'],
      ]);
    });
    test('readAll loads with multiple path placeholders in csvPath', () async {
      final file = p.join(tempDir.path, 'data_foo_bar.csv');
      await File(file).writeAsString('v1\n');
      final tableConfig = [
        TableConfig(
          name: 't1',
          columns: [
            TableColumn(name: 'c1'),
            TableColumn(name: 'c2'),
            TableColumn(name: 'c3')
          ],
          primaryKey: ['c1'],
          csvPath: p.join(tempDir.path, 'data_[c2]_[c3].csv'),
        ),
      ];
      final reader = CsvReader(ctx: p.Context(), decoder: TestDecoder());
      final buffer = reader.readAll(tableConfig);
      expect(buffer['t1']!.columns, ['c2', 'c3', 'c1']);
      expect(buffer['t1']!.values, [
        ['foo', 'bar', 'v1'],
      ]);
    });
    test('readAll loads with missing path placeholder value in csvPath',
        () async {
      final file = p.join(tempDir.path, 'data_.csv');
      await File(file).writeAsString('v1\n');
      final tableConfig = [
        TableConfig(
          name: 't1',
          columns: [TableColumn(name: 'c1'), TableColumn(name: 'c2')],
          primaryKey: ['c1'],
          csvPath: p.join(tempDir.path, 'data_[c2].csv'),
        ),
      ];
      final reader = CsvReader(ctx: p.Context(), decoder: TestDecoder());
      final buffer = reader.readAll(tableConfig);
      expect(buffer['t1']!.values, [
        ['', 'v1'],
      ]);
    });
    test('readAll loads with extra values in path for placeholders', () async {
      final file = p.join(tempDir.path, 'data_foo_bar.csv');
      await File(file).writeAsString('v1\n');
      final tableConfig = [
        TableConfig(
          name: 't1',
          columns: [TableColumn(name: 'c1'), TableColumn(name: 'c2')],
          primaryKey: ['c1'],
          csvPath: p.join(tempDir.path, 'data_[c2].csv'),
        ),
      ];
      final reader = CsvReader(ctx: p.Context(), decoder: TestDecoder());
      final buffer = reader.readAll(tableConfig);
      expect(buffer['t1']!.values, [
        ['foo_bar', 'v1'],
      ]);
    });
    test('reads all CSV files without glob', () async {
      final filePaths = [
        p.join(tempDir.path, 'a.csv'),
        p.join(tempDir.path, 'b.csv'),
      ];
      await File(filePaths[0]).writeAsString('a1,b1\na2,b2\n');
      await File(filePaths[1]).writeAsString('c1,d1\nc2,d2\n');
      final tableConfig = [
        TableConfig(
          name: 'a',
          columns: [TableColumn(name: 'c1'), TableColumn(name: 'c2')],
          primaryKey: ['c1'],
          csvPath: filePaths[0],
        ),
        TableConfig(
          name: 'b',
          columns: [TableColumn(name: 'c1'), TableColumn(name: 'c2')],
          primaryKey: ['c1'],
          csvPath: filePaths[1],
        ),
      ];
      final reader = CsvReader(ctx: p.Context(), decoder: TestDecoder());
      final buffer = reader.readAll(tableConfig);
      expect(buffer['a']!.values, [
        ['a1', 'b1'],
        ['a2', 'b2'],
      ]);
      expect(buffer['b']!.values, [
        ['c1', 'd1'],
        ['c2', 'd2'],
      ]);
    });
    test('returns empty if no files match', () async {
      final tableConfig = [
        TableConfig(
          name: 'notfound',
          columns: [TableColumn(name: 'c1')],
          primaryKey: ['c1'],
          csvPath: p.join(tempDir.path, 'notfound.csv'),
        ),
      ];
      final reader = CsvReader(ctx: p.Context(), decoder: TestDecoder());
      final buffer = reader.readAll(tableConfig);
      expect(buffer['notfound']!.values, isEmpty);
    });
    test('does not match files in subdirectories unless glob includes them',
        () async {
      final subDir = await Directory(p.join(tempDir.path, 'sub')).create();
      final subFile = p.join(subDir.path, 'sub.csv');
      await File(subFile).writeAsString('x1,y1\nx2,y2\n');
      final tableConfig = [
        TableConfig(
          name: 'sub',
          columns: [TableColumn(name: 'c1'), TableColumn(name: 'c2')],
          primaryKey: ['c1'],
          csvPath: subFile,
        ),
      ];
      final reader = CsvReader(ctx: p.Context(), decoder: TestDecoder());
      final buffer = reader.readAll(tableConfig);
      expect(buffer['sub']!.values, [
        ['x1', 'y1'],
        ['x2', 'y2'],
      ]);
    });
    test('accept files with different extensions', () async {
      final txtFile = p.join(tempDir.path, 'notcsv.txt');
      await File(txtFile).writeAsString('should,not,read\n');
      final tableConfig = [
        TableConfig(
          name: 'notcsv',
          columns: [TableColumn(name: 'c1'), TableColumn(name: 'c2')],
          primaryKey: ['c1'],
          csvPath: txtFile,
        ),
      ];
      final reader = CsvReader(ctx: p.Context(), decoder: TestDecoder());
      final buffer = reader.readAll(tableConfig);
      expect(buffer['notcsv']!.values, [
        ['should', 'not', 'read'],
      ]);
    });
    test('handles empty CSV files gracefully', () async {
      final emptyFile = p.join(tempDir.path, 'empty.csv');
      await File(emptyFile).writeAsString('');
      final tableConfig = [
        TableConfig(
          name: 'empty',
          columns: [TableColumn(name: 'c1')],
          primaryKey: ['c1'],
          csvPath: emptyFile,
        ),
      ];
      final reader = CsvReader(ctx: p.Context(), decoder: TestDecoder());
      final buffer = reader.readAll(tableConfig);
      expect(buffer['empty']!.values, isEmpty);
    });
    test('reads a single file correctly', () async {
      final filePaths = [
        p.join(tempDir.path, 'a.csv'),
        p.join(tempDir.path, 'b.csv'),
      ];
      await File(filePaths[0]).writeAsString('a1,b1\na2,b2\n');
      final tableConfig = [
        TableConfig(
          name: 'a',
          columns: [TableColumn(name: 'c1'), TableColumn(name: 'c2')],
          primaryKey: ['c1'],
          uniqueKey: {},
          foreignKey: {},
          csvPath: filePaths[0],
        ),
      ];
      final reader = CsvReader(ctx: p.Context(), decoder: TestDecoder());
      final buffer = reader.readAll(tableConfig);
      expect(buffer['a']!.values, [
        ['a1', 'b1'],
        ['a2', 'b2'],
      ]);
    });
  });
}
