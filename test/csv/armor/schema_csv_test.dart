import 'package:csv_armor/csv/armor/csv_reader.dart';
import 'package:csv_armor/csv/armor/csv_writer.dart';
import 'package:csv_armor/csv/armor/schema/schema.dart';
import 'package:csv_armor/csv/armor/schema_csv.dart';
import 'package:csv_armor/csv/armor/schema_reader.dart';
import 'package:csv_armor/csv/armor/schema_writer.dart';
import 'package:csv_armor/csv/decoder.dart';
import 'package:csv_armor/csv/encoder.dart';
import 'package:path/path.dart' as path;
import 'package:test/test.dart';

class TestCSVReader implements CSVReader {
  String? wantCSVPath;
  List<List<String>>? wantCSV;

  @override
  List<List<String>> read(String csvPath, Decoder decoder) {
    return wantCSVPath == csvPath
        ? wantCSV!
        : throw Exception('invalid CSV path');
  }
}

class TestCSVWriter implements CSVWriter {
  String? wantCSVPath;
  List<List<String>>? gotCSV;

  @override
  void write(String csvPath, List<List<String>> records, Encoder encoder) {
    gotCSV =
        wantCSVPath == csvPath ? records : throw Exception('invalid CSV path');
  }
}

class TestSchemaReader implements SchemaReader {
  String? wantSchemaPath;
  Schema? wantSchema;

  @override
  Schema read(String schemaPath) {
    return wantSchemaPath == schemaPath
        ? wantSchema!
        : throw Exception('invalid schema path');
  }
}

class TestSchemaWriter implements SchemaWriter {
  String? wantSchemaPath;
  Schema? gotSchema;

  @override
  void write(String schemaPath, Schema schema) {
    gotSchema = wantSchemaPath == schemaPath
        ? schema
        : throw Exception('invalid schema path');
  }
}

typedef _Testcase_resolvePath = ({
  String message,
  SchemaCSVCache sut,
  String schemaPath,
  SchemaCSV? want,
});

typedef _Testcase_load = ({
  String message,
  String schemaPath,
  SchemaCSV want,
});

typedef _Testcase_save = ({
  String message,
  String schemaPath,
  SchemaCSV want,
});

void main() {
  group('SchemaCSVCache', () {
    final pathCtx = path.Context(current: '/workdir', style: path.Style.posix);
    final schemaBase = Schema('data.tsv', [Column('c')], ['c']);
    final csvBase = [
      ['c'],
      ['1'],
    ];
    group('get and set', () {
      SchemaCSVCache defaultSut() {
        return SchemaCSVCache(
          pathCtx,
          TestSchemaReader(),
          TestSchemaWriter(),
          TestCSVReader(),
          TestCSVWriter(),
        );
      }

      group('resolve path', () {
        final testcases = <_Testcase_resolvePath>[
          (
            message:
                'should resolve path with absolute schema path and absolute csv path',
            sut: defaultSut(),
            schemaPath: '/workdir/schema.yaml',
            want: SchemaCSV(
                schemaBase.copyWith(csvPath: '/workdir/data.tsv'), csvBase),
          ),
          (
            message:
                'should resolve path with relative schema path and absolute csv path',
            sut: defaultSut(),
            schemaPath: 'schema.yaml',
            want: SchemaCSV(
                schemaBase.copyWith(csvPath: '/workdir/data.tsv'), csvBase),
          ),
          (
            message:
                'should resolve path with absolute schema path and relative csv path',
            sut: defaultSut(),
            schemaPath: '/workdir/schema.yaml',
            want: SchemaCSV(schemaBase.copyWith(csvPath: 'data.tsv'), csvBase),
          ),
          (
            message:
                'should resolve path with relative schema path and relative csv path',
            sut: defaultSut(),
            schemaPath: 'schema.yaml',
            want: SchemaCSV(schemaBase.copyWith(csvPath: 'data.tsv'), csvBase),
          ),
        ];
        for (final testcase in testcases) {
          test(testcase.message, () {
            testcase.sut[testcase.schemaPath] = testcase.want!;
            final got = testcase.sut[testcase.schemaPath];

            expect(got?.schema, equals(testcase.want?.schema));
            expect(got?.csv, equals(testcase.want?.csv));
          });
        }
      });

      test('should return null if not found', () {
        final sut = defaultSut();
        final got = sut['/workdir/schema.yaml'];
        expect(got, equals(null));
      });
      test('should update existing SchemaCSV', () {
        final sut = defaultSut();
        sut['/workdir/schema.yaml'] = SchemaCSV(schemaBase, csvBase);
        sut['/workdir/schema.yaml'] =
            SchemaCSV(schemaBase.copyWith(csvPath: 'moved.csv'), []);
        final got = sut['/workdir/schema.yaml'];
        expect(got?.schema, equals(schemaBase.copyWith(csvPath: 'moved.csv')));
        expect(got?.csv, equals([]));
      });
      test('should remove existing SchemaCSV', () {
        final sut = defaultSut();
        sut['/workdir/schema.yaml'] = SchemaCSV(schemaBase, csvBase);
        sut['/workdir/schema.yaml'] = null;
        final got = sut['/workdir/schema.yaml'];
        expect(got, equals(null));
      });
    });

    group('load', () {
      final testcases = <_Testcase_load>[
        (
          message:
              'should load with absolute schema path and absolute csv path',
          schemaPath: '/workdir/schema.yaml',
          want: SchemaCSV(
              schemaBase.copyWith(csvPath: '/workdir/data.tsv'), csvBase),
        ),
        (
          message:
              'should load with relative schema path and absolute csv path',
          schemaPath: 'schema.yaml',
          want: SchemaCSV(
              schemaBase.copyWith(csvPath: '/workdir/data.tsv'), csvBase),
        ),
        (
          message:
              'should load with absolute schema path and relative csv path',
          schemaPath: '/workdir/schema.yaml',
          want: SchemaCSV(schemaBase.copyWith(csvPath: 'data.tsv'), csvBase),
        ),
        (
          message:
              'should load with relative schema path and relative csv path',
          schemaPath: 'schema.yaml',
          want: SchemaCSV(schemaBase.copyWith(csvPath: 'data.tsv'), csvBase),
        ),
      ];
      for (final testcase in testcases) {
        test(testcase.message, () {
          final sut = SchemaCSVCache(
            pathCtx,
            TestSchemaReader()
              ..wantSchemaPath = '/workdir/schema.yaml'
              ..wantSchema = testcase.want.schema,
            TestSchemaWriter(),
            TestCSVReader()
              ..wantCSVPath = '/workdir/data.tsv'
              ..wantCSV = testcase.want.csv,
            TestCSVWriter(),
          );
          sut.load([testcase.schemaPath]);
          final got = sut[testcase.schemaPath];

          expect(got?.schema, equals(testcase.want.schema));
          expect(got?.csv, equals(testcase.want.csv));
        });
      }
    });
    group('save', () {
      final testcases = <_Testcase_save>[
        (
          message:
              'should save with absolute schema path and absolute csv path',
          schemaPath: '/workdir/schema.yaml',
          want: SchemaCSV(
              schemaBase.copyWith(csvPath: '/workdir/data.tsv'), csvBase),
        ),
        (
          message:
              'should save with relative schema path and absolute csv path',
          schemaPath: 'schema.yaml',
          want: SchemaCSV(
              schemaBase.copyWith(csvPath: '/workdir/data.tsv'), csvBase),
        ),
        (
          message:
              'should save with absolute schema path and relative csv path',
          schemaPath: '/workdir/schema.yaml',
          want: SchemaCSV(schemaBase.copyWith(csvPath: 'data.tsv'), csvBase),
        ),
        (
          message:
              'should save with relative schema path and relative csv path',
          schemaPath: 'schema.yaml',
          want: SchemaCSV(schemaBase.copyWith(csvPath: 'data.tsv'), csvBase),
        ),
      ];
      for (final testcase in testcases) {
        test(testcase.message, () {
          final schemaWriter = TestSchemaWriter()
            ..wantSchemaPath = '/workdir/schema.yaml';
          final csvWriter = TestCSVWriter()..wantCSVPath = '/workdir/data.tsv';
          final sut = SchemaCSVCache(
            pathCtx,
            TestSchemaReader(),
            schemaWriter,
            TestCSVReader(),
            csvWriter,
          );
          sut[testcase.schemaPath] = testcase.want;
          sut.save();

          expect(schemaWriter.gotSchema, equals(testcase.want.schema));
          expect(csvWriter.gotCSV, equals(testcase.want.csv));
        });
      }
    });
  });
}
