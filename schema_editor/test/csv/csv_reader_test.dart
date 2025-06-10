import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:schema_editor/csv/csv_reader.dart';
import 'package:schema_editor/csv/decoder.dart';

class TestDecoder implements Decoder {
  @override
  List<List<String>> decode(String content) {
    return content.split('\n').where((l) => l.isNotEmpty).map((l) => l.split(',')).toList();
  }
}

void main() {
  group('GlobCSVReader', () {
    late Directory tempDir;
    late String file1Path;
    late String file2Path;
    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('glob_csv_reader_test');
      file1Path = p.join(tempDir.path, 'a.csv');
      file2Path = p.join(tempDir.path, 'b.csv');
      await File(file1Path).writeAsString('a1,b1\na2,b2\n');
      await File(file2Path).writeAsString('c1,d1\nc2,d2\n');
    });
    tearDown(() async {
      await tempDir.delete(recursive: true);
    });
    test('reads all CSV files matching glob', () {
      final reader = GlobCSVReader(ctx: p.Context(), decoder: TestDecoder());
      final results = reader.readAll(p.join(tempDir.path, '*.csv'));
      expect(results.length, 2);
      final paths = results.map((r) => p.basename(r.path)).toSet();
      expect(paths, containsAll({'a.csv', 'b.csv'}));
      final a = results.firstWhere((r) => p.basename(r.path) == 'a.csv');
      expect(a.records, [
        ['a1', 'b1'],
        ['a2', 'b2'],
      ]);
      final b = results.firstWhere((r) => p.basename(r.path) == 'b.csv');
      expect(b.records, [
        ['c1', 'd1'],
        ['c2', 'd2'],
      ]);
    });
    test('returns empty if no files match', () {
      final reader = GlobCSVReader(ctx: p.Context(), decoder: TestDecoder());
      final results = reader.readAll(p.join(tempDir.path, '*.notfound'));
      expect(results, isEmpty);
    });
    test('does not match files in subdirectories unless glob includes them', () async {
      final subDir = await Directory(p.join(tempDir.path, 'sub')).create();
      final subFile = p.join(subDir.path, 'sub.csv');
      await File(subFile).writeAsString('x1,y1\nx2,y2\n');
      final reader = GlobCSVReader(ctx: p.Context(), decoder: TestDecoder());
      // Should not match subdirectory files
      final results = reader.readAll(p.join(tempDir.path, '*.csv'));
      final paths = results.map((r) => p.basename(r.path)).toSet();
      expect(paths, isNot(contains('sub.csv')));
      // Should match subdirectory files if glob includes them
      final resultsRecursive = reader.readAll(p.join(tempDir.path, '**', '*.csv'));
      final allPaths = resultsRecursive.map((r) => p.basename(r.path)).toSet();
      expect(allPaths, contains('sub.csv'));
    });
    test('ignores files with different extensions', () async {
      final txtFile = p.join(tempDir.path, 'notcsv.txt');
      await File(txtFile).writeAsString('should,not,read\n');
      final reader = GlobCSVReader(ctx: p.Context(), decoder: TestDecoder());
      final results = reader.readAll(p.join(tempDir.path, '*.csv'));
      final paths = results.map((r) => p.basename(r.path)).toSet();
      expect(paths, isNot(contains('notcsv.txt')));
    });
    test('handles empty CSV files gracefully', () async {
      final emptyFile = p.join(tempDir.path, 'empty.csv');
      await File(emptyFile).writeAsString('');
      final reader = GlobCSVReader(ctx: p.Context(), decoder: TestDecoder());
      final results = reader.readAll(p.join(tempDir.path, '*.csv'));
      final empty = results.firstWhere((r) => p.basename(r.path) == 'empty.csv');
      expect(empty.records, isEmpty);
    });
    test('reads a single file correctly', () async {
      final reader = GlobCSVReader(ctx: p.Context(), decoder: TestDecoder());
      final results = reader.readAll(file1Path);
      expect(results.length, 1);
      expect(p.basename(results.first.path), 'a.csv');
      expect(results.first.records, [
        ['a1', 'b1'],
        ['a2', 'b2'],
      ]);
    });
    test('handles a large number of files', () async {
      final many = <String>[];
      for (var i = 0; i < 50; i++) {
        final f = p.join(tempDir.path, 'file_$i.csv');
        await File(f).writeAsString('v$i,${i * 2}\n');
        many.add(f);
      }
      final reader = GlobCSVReader(ctx: p.Context(), decoder: TestDecoder());
      final results = reader.readAll(p.join(tempDir.path, 'file_*.csv'));
      expect(results.length, 50);
      for (var i = 0; i < 50; i++) {
        final rec = results.firstWhere((r) => p.basename(r.path) == 'file_$i.csv');
        expect(rec.records, [
          ['v$i', '${i * 2}']
        ]);
      }
    });
  });
}
