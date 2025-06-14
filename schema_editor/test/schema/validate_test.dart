import 'package:flutter_test/flutter_test.dart';
import 'package:schema_editor/schema/schema.dart';
import 'package:schema_editor/schema/validate.dart';
import 'package:schema_editor/schema/validation_result.dart';

void main() {

  group('validateSchema', () {
    test('returns no error for valid schema', () {
      final schema = Schema(
        tableConfig: [
          TableConfig(
            name: 'table',
            columns: [TableColumn(name: 'col', type: 'type1')],
            primaryKey: ['col'],
            uniqueKey: {'uk': ['col']},
            foreignKey: {},
            csvPath: 'data.csv',
          ),
        ],
        columnType: {'type1': r'^.*$'},
        validation: [],
      );
      final result = validateSchema(schema);
      expect(result.errors, isEmpty);
    });
    test('returns errors for multiple invalid tables and column types', () {
      final schema = Schema(
        tableConfig: [
          TableConfig(
            name: '',
            columns: [TableColumn(name: 'col', type: 'unknown')],
            primaryKey: [],
            uniqueKey: {'uk': []},
            foreignKey: {},
            csvPath: '',
          ),
          TableConfig(
            name: '',
            columns: [],
            primaryKey: [],
            uniqueKey: {},
            foreignKey: {},
            csvPath: 'invalid*path.csv',
          ),
        ],
        columnType: {'type1': r'[', 'type2': r'['},
        validation: [],
      );
      final result = validateSchema(schema);
      final codes = result.errors.map((e) => e.code).toSet();
      expect(codes, contains(ValidationError.codeEmptyTableName));
      expect(codes, contains(ValidationError.codeEmptyCsvPath));
      expect(codes, contains(ValidationError.codeInvalidCsvPath));
      expect(codes, contains(ValidationError.codeUndefinedColumnType));
      expect(codes, contains(ValidationError.codeEmptyPrimaryKey));
      expect(codes, contains(ValidationError.codeEmptyUniqueKeyColumns));
      expect(codes, contains(ValidationError.codeInvalidColumnTypeRegexp));
    });
  });

  group('validateColumnType', () {
    test('returns error for invalid regexp', () {
      final result = validateColumnType(['column_type', 'bad'], 'bad', r'[');
      expect(result.errors, isNotEmpty);
      for(final error in result.errors) {
        expect(error.code, isIn([
          ValidationError.codeInvalidColumnTypeRegexp,
        ]));
      }
    });
    test('returns no error for valid regexp', () {
      final result = validateColumnType(['column_type', 'good'], 'good', r'^[a-z]+');
      expect(result.errors, isEmpty);
    });
  });

  group('validateColumn', () {
    test('returns error for undefined column type', () {
      final column = TableColumn(name: 'col', type: 'unknown');
      final result = validateColumn(['columns', '0'], {'known'}, column);
      expect(result.errors, isNotEmpty);
      for(final error in result.errors) {
        expect(error.code, isIn([
          ValidationError.codeUndefinedColumnType,
        ]));
      }
    });
    test('returns error for invalid regexp', () {
      final column = TableColumn(name: 'col', regexp: r'[');
      final result = validateColumn(['columns', '0'], {}, column);
      expect(result.errors, isNotEmpty);
      for(final error in result.errors) {
        expect(error.code, isIn([
          ValidationError.codeInvalidColumnRegexp,
        ]));
      }
    });
    test('returns no error for valid type and regexp', () {
      final column = TableColumn(name: 'col', type: 'known', regexp: r'^a$');
      final result = validateColumn(['columns', '0'], {'known'}, column);
      expect(result.errors, isEmpty);
    });
  });

  group('validatePrimaryKey', () {
    test('returns error for empty primary key', () {
      final result = validatePrimaryKey(['table', 'primary_key'], {'col'}, 'table', []);
      expect(result.errors, isNotEmpty);
      for(final error in result.errors) {
        expect(error.code, isIn([
          ValidationError.codeEmptyPrimaryKey,
        ]));
      }
    });
    test('returns error for undefined primary key column', () {
      final result = validatePrimaryKey(['table', 'primary_key'], {'col'}, 'table', ['unknown']);
      expect(result.errors, isNotEmpty);
      for(final error in result.errors) {
        expect(error.code, isIn([
          ValidationError.codeUndefinedPrimaryKeyColumn,
        ]));
      }
    });
    test('returns no error for valid primary key', () {
      final result = validatePrimaryKey(['table', 'primary_key'], {'col'}, 'table', ['col']);
      expect(result.errors, isEmpty);
    });
  });

  group('validateUniqueKey', () {
    test('returns error for empty unique key', () {
      final result = validateUniqueKey(['table', 'unique_keys'], 'table', {'col'}, 'uk', []);
      expect(result.errors, isNotEmpty);
      for(final error in result.errors) {
        expect(error.code, isIn([
          ValidationError.codeEmptyUniqueKeyColumns,
        ]));
      }
    });
    test('returns error for undefined unique key column', () {
      final result = validateUniqueKey(['table', 'unique_keys'], 'table', {'col'}, 'uk', ['unknown']);
      expect(result.errors, isNotEmpty);
      for(final error in result.errors) {
        expect(error.code, isIn([
          ValidationError.codeUndefinedUniqueKeyColumn,
        ]));
      }
    });
    test('returns error for empty unique key name', () {
      final result = validateUniqueKey(['table', 'unique_keys'], 'table', {'col'}, '', ['col']);
      expect(result.errors, isNotEmpty);
      for(final error in result.errors) {
        expect(error.code, isIn([
          ValidationError.codeEmptyUniqueKeyName,
        ]));
      }
    });
    test('returns no error for valid unique key', () {
      final result = validateUniqueKey(['table', 'unique_keys'], 'table', {'col'}, 'uk', ['col']);
      expect(result.errors, isEmpty);
    });
  });

  group('validateForeignKey', () {
    final tableMap = {
      'ref': TableConfig(
        name: 'ref',
        columns: [TableColumn(name: 'id')],
        uniqueKey: {'uk': ['id']},
      ),
    };
    test('returns error for empty foreign key columns', () {
      final fk = ForeignKey(columns: [], reference: ForeignKeyReference(table: 'ref'));
      final result = validateForeignKey(['table', 'foreign_keys'], tableMap, 'table', {'col'}, 'fk', fk);
      expect(result.errors, isNotEmpty);
      for(final error in result.errors) {
        expect(error.code, isIn([
          ValidationError.codeEmptyForeignKeyColumns,
        ]));
      }
    });
    test('returns error for undefined foreign key column', () {
      final fk = ForeignKey(columns: ['unknown'], reference: ForeignKeyReference(table: 'ref'));
      final result = validateForeignKey(['table', 'foreign_keys'], tableMap, 'table', {'col'}, 'fk', fk);
      expect(result.errors, isNotEmpty);
      for(final error in result.errors) {
        expect(error.code, isIn([
          ValidationError.codeUndefinedForeignKeyColumn,
        ]));
      }
    });
    test('returns error for undefined reference table', () {
      final fk = ForeignKey(columns: ['col'], reference: ForeignKeyReference(table: 'not_exist'));
      final result = validateForeignKey(['table', 'foreign_keys'], tableMap, 'table', {'col'}, 'fk', fk);
      expect(result.errors, isNotEmpty);
      for(final error in result.errors) {
        expect(error.code, isIn([
          ValidationError.codeUndefinedForeignKeyReferenceTable,
        ]));
      }
    });
    test('returns error for undefined reference unique key', () {
      final fk = ForeignKey(
        columns: ['col'],
        reference: ForeignKeyReference(table: 'ref', uniqueKey: 'not_exist'),
      );
      final result = validateForeignKey(['table', 'foreign_keys'], tableMap, 'table', {'col'}, 'fk', fk);
      expect(result.errors, isNotEmpty);
      for(final error in result.errors) {
        expect(error.code, isIn([
          ValidationError.codeUndefinedForeignKeyReferenceUniqueKey,
        ]));
      }
    });
    test('returns error for empty foreign key name', () {
      final fk = ForeignKey(columns: ['col'], reference: ForeignKeyReference(table: 'ref'));
      final result = validateForeignKey(['table', 'foreign_keys'], tableMap, 'table', {'col'}, '', fk);
      expect(result.errors, isNotEmpty);
      for(final error in result.errors) {
        expect(error.code, isIn([
          ValidationError.codeEmptyForeignKeyName,
        ]));
      }
    });
    test('returns no error for valid foreign key', () {
      final fk = ForeignKey(
        columns: ['col'],
        reference: ForeignKeyReference(table: 'ref', uniqueKey: 'uk'),
      );
      final result = validateForeignKey(['table', 'foreign_keys'], tableMap, 'table', {'col'}, 'fk', fk);
      expect(result.errors, isEmpty);
    });
  });

  group('validateTableConfig', () {
    final typeSet = {'type1'};
    final tableMap = {
      'table': TableConfig(
        name: 'table',
        columns: [TableColumn(name: 'col', type: 'type1')],
        primaryKey: ['col'],
        uniqueKey: {'uk': ['col']},
        foreignKey: {},
        csvPath: 'data.csv',
      ),
    };
    test('returns no error for valid table config', () {
      final config = tableMap['table']!;
      final result = validateTableConfig(['table_config', '0'], typeSet, tableMap, config);
      expect(result.errors, isEmpty);
    });
    test('returns error for empty table name', () {
      final config = TableConfig(
        name: '',
        columns: [TableColumn(name: 'col', type: 'type1')],
        primaryKey: ['col'],
        uniqueKey: {'uk': ['col']},
        foreignKey: {},
        csvPath: 'data.csv',
      );
      final result = validateTableConfig(['table_config', '0'], typeSet, tableMap, config);
      expect(result.errors, isNotEmpty);
      for(final error in result.errors) {
        expect(error.code, isIn([
          ValidationError.codeEmptyTableName,
        ]));
      }
    });
    test('returns error for empty csvPath', () {
      final config = TableConfig(
        name: 'table',
        columns: [TableColumn(name: 'col', type: 'type1')],
        primaryKey: ['col'],
        uniqueKey: {'uk': ['col']},
        foreignKey: {},
        csvPath: '',
      );
      final result = validateTableConfig(['table_config', '0'], typeSet, tableMap, config);
      expect(result.errors, isNotEmpty);
      for(final error in result.errors) {
        expect(error.code, isIn([
          ValidationError.codeEmptyCsvPath,
        ]));
      }
    });
    test('returns error for invalid csvPath', () {
      final config = TableConfig(
        name: 'table',
        columns: [TableColumn(name: 'col', type: 'type1')],
        primaryKey: ['col'],
        uniqueKey: {'uk': ['col']},
        foreignKey: {},
        csvPath: 'invalid*path.csv',
      );
      final result = validateTableConfig(['table_config', '0'], typeSet, tableMap, config);
      expect(result.errors, isNotEmpty);
      for(final error in result.errors) {
        expect(error.code, isIn([
          ValidationError.codeInvalidCsvPath,
        ]));
      }
    });
    test('returns multiple errors for empty name and csvPath', () {
      final config = TableConfig(
        name: '',
        columns: [],
        primaryKey: [],
        uniqueKey: {},
        foreignKey: {},
        csvPath: '',
      );
      final result = validateTableConfig(['table_config', '0'], typeSet, tableMap, config);
      expect(result.errors, isNotEmpty);
      final codes = result.errors.map((e) => e.code).toSet();
      expect(codes, contains(ValidationError.codeEmptyTableName));
      expect(codes, contains(ValidationError.codeEmptyCsvPath));
    });
    test('returns error for undefined csv path placeholder', () {
      final config = TableConfig(
        name: 'table',
        columns: [TableColumn(name: 'col1', type: 'type1')],
        primaryKey: ['col1'],
        uniqueKey: {'uk': ['col1']},
        foreignKey: {},
        csvPath: 'data_[col2].csv', // col2 does not exist
      );
      final typeSet = {'type1'};
      final tableMap = {'table': config};
      final result = validateTableConfig(['table_config', '0'], typeSet, tableMap, config);
      expect(result.errors, isNotEmpty);
      for(final error in result.errors) {
        expect(error.code, isIn([
          ValidationError.codeUndefinedCsvPathPlaceholder,
        ]));
      }
    });
  });

  group('validateDecodeConfig', () {
    test('returns error for negative headerLines', () {
      final decode = DecodeConfig(headerLines: -1);
      final result = validateDecodeConfig(['decode'], decode);
      expect(result.errors, isNotEmpty);
      expect(result.errors.first.code, ValidationError.codeNegativeHeaderLines);
    });
    test('returns error for only left quote', () {
      final decode = DecodeConfig(fieldQuote: FieldQuote(left: '"'));
      final result = validateDecodeConfig(['decode'], decode);
      expect(result.errors, isNotEmpty);
      expect(result.errors.first.code, ValidationError.codeInvalidQuoteCombination);
    });
    test('returns error for only right quote', () {
      final decode = DecodeConfig(fieldQuote: FieldQuote(right: '"'));
      final result = validateDecodeConfig(['decode'], decode);
      expect(result.errors, isNotEmpty);
      expect(result.errors.first.code, ValidationError.codeInvalidQuoteCombination);
    });
    test('returns error for leftEscape when quotes are empty', () {
      final decode = DecodeConfig(fieldQuote: FieldQuote(leftEscape: '\\'));
      final result = validateDecodeConfig(['decode'], decode);
      expect(result.errors, isNotEmpty);
      expect(result.errors.first.code, ValidationError.codeInvalidQuoteCombination);
    });
    test('returns error for rightEscape when quotes are empty', () {
      final decode = DecodeConfig(fieldQuote: FieldQuote(rightEscape: '\\'));
      final result = validateDecodeConfig(['decode'], decode);
      expect(result.errors, isNotEmpty);
      expect(result.errors.first.code, ValidationError.codeInvalidQuoteCombination);
    });
    test('returns no error for valid quotes', () {
      final decode = DecodeConfig(fieldQuote: FieldQuote(left: '"', right: '"'));
      final result = validateDecodeConfig(['decode'], decode);
      expect(result.errors, isEmpty);
    });
    test('returns no error for empty quotes and escapes', () {
      final decode = DecodeConfig(fieldQuote: FieldQuote());
      final result = validateDecodeConfig(['decode'], decode);
      expect(result.errors, isEmpty);
    });
    test('returns no error for valid headerLines', () {
      final decode = DecodeConfig(headerLines: 0);
      final result = validateDecodeConfig(['decode'], decode);
      expect(result.errors, isEmpty);
    });
  });
}
