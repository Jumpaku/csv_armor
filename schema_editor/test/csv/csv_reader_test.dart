import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:schema_editor/csv/decoder/decoder.dart';
import 'package:schema_editor/csv/csv_reader.dart';
import 'package:schema_editor/schema/schema.dart';

class TestDecoder implements Decoder {
  TestDecoder();

  @override
  DecodeResult decode(String content) {
    // Split into lines and fields
    final lines =
        content.split(RegExp(r'[\r\n]+')).where((l) => l.isNotEmpty).toList();
    final inputChars = content.split("");
    int cursor = 0;
    int lineNum = 0;
    final positions = <Position>[];
    for (final ch in inputChars) {
      positions.add(Position(cursor, lineNum, cursor));
      if (ch == '\n') lineNum++;
      cursor++;
    }
    // Build records as List<Record> with Field and Position
    List<Record> makeRecords(List<List<String>> rows) {
      int pos = 0;
      int line = 0;
      return rows.map((fields) {
        final fieldObjs = <Field>[];
        int col = 0;
        for (final value in fields) {
          final start = Position(pos, line, col);
          final end = Position(pos + value.length, line, col + value.length);
          fieldObjs.add(Field(start, end, value));
          pos += value.length + 1; // +1 for separator
          col += value.length + 1;
        }
        final start = fieldObjs.isNotEmpty
            ? fieldObjs.first.start
            : Position(pos, line, 0);
        final end =
            fieldObjs.isNotEmpty ? fieldObjs.last.end : Position(pos, line, 0);
        line++;
        return Record(start, end, fieldObjs);
      }).toList();
    }

    final data = lines.map((l) => l.split(',')).toList();
    return DecodeResult(
      inputChars,
      <Record>[], // no headers for test
      makeRecords(data),
    );
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
      final reader =
          CsvReader(ctx: p.Context(), root: tempDir.path, decoder: TestDecoder());
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
      final reader =
          CsvReader(ctx: p.Context(), root: tempDir.path, decoder: TestDecoder());
      final buffer = reader.readAll(tableConfig);
      expect(buffer['t1']!.records, [
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
      final reader =
          CsvReader(ctx: p.Context(), root: tempDir.path, decoder: TestDecoder());
      final buffer = reader.readAll(tableConfig);
      expect(buffer['t1']!.columns, ['c1', 'c2']);
      expect(buffer['t1']!.records, [
        ['v1', 'foo'],
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
      final reader =
          CsvReader(ctx: p.Context(), root: tempDir.path, decoder: TestDecoder());
      final buffer = reader.readAll(tableConfig);
      expect(buffer['t1']!.columns, ['c1', 'c2', 'c3']);
      expect(buffer['t1']!.records, [
        ['v1', 'foo', 'bar'],
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
      final reader =
          CsvReader(ctx: p.Context(), root: tempDir.path, decoder: TestDecoder());
      final buffer = reader.readAll(tableConfig);
      expect(buffer['t1']!.records, [
        ['v1', ''],
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
      final reader =
          CsvReader(ctx: p.Context(), root: tempDir.path, decoder: TestDecoder());
      final buffer = reader.readAll(tableConfig);
      expect(buffer['t1']!.records, [
        ['v1', 'foo_bar'],
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
      final reader =
          CsvReader(ctx: p.Context(), root: tempDir.path, decoder: TestDecoder());
      final buffer = reader.readAll(tableConfig);
      expect(buffer['a']!.records, [
        ['a1', 'b1'],
        ['a2', 'b2'],
      ]);
      expect(buffer['b']!.records, [
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
      final reader =
          CsvReader(ctx: p.Context(), root: tempDir.path, decoder: TestDecoder());
      final buffer = reader.readAll(tableConfig);
      expect(buffer['notfound']!.records, isEmpty);
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
      final reader =
          CsvReader(ctx: p.Context(), root: tempDir.path, decoder: TestDecoder());
      final buffer = reader.readAll(tableConfig);
      expect(buffer['sub']!.records, [
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
          columns: [
            TableColumn(name: 'c1'),
            TableColumn(name: 'c2'),
            TableColumn(name: 'c3')
          ],
          primaryKey: ['c1'],
          csvPath: txtFile,
        ),
      ];
      final reader =
          CsvReader(ctx: p.Context(), root: tempDir.path, decoder: TestDecoder());
      final buffer = reader.readAll(tableConfig);
      expect(buffer['notcsv']!.records, [
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
      final reader =
          CsvReader(ctx: p.Context(), root: tempDir.path, decoder: TestDecoder());
      final buffer = reader.readAll(tableConfig);
      expect(buffer['empty']!.records, isEmpty);
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
      final reader =
          CsvReader(ctx: p.Context(), root: tempDir.path, decoder: TestDecoder());
      final buffer = reader.readAll(tableConfig);
      expect(buffer['a']!.records, [
        ['a1', 'b1'],
        ['a2', 'b2'],
      ]);
    });
  });
}
