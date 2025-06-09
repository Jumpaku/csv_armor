import 'package:flutter_test/flutter_test.dart';
import 'package:schema_editor/schema/schema.dart';
import 'package:schema_editor/schema/validate.dart';

void main() {
  group('validateColumnType', () {
    test('returns error for invalid regexp', () {
      final result = validateColumnType(['column_type', 'bad'], 'bad', r'[');
      for(final error in result.errors) {
        expect(error.code, isIn([
          SchemaValidationError.codeInvalidColumnTypeRegexp,
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
      for(final error in result.errors) {
        expect(error.code, isIn([
          SchemaValidationError.codeUndefinedColumnType,
        ]));
      }
    });
    test('returns error for invalid regexp', () {
      final column = TableColumn(name: 'col', regexp: r'[');
      final result = validateColumn(['columns', '0'], {}, column);
      for(final error in result.errors) {
        expect(error.code, isIn([
          SchemaValidationError.codeInvalidColumnRegexp,
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
      for(final error in result.errors) {
        expect(error.code, isIn([
          SchemaValidationError.codeEmptyPrimaryKey,
        ]));
      }
    });
    test('returns error for undefined primary key column', () {
      final result = validatePrimaryKey(['table', 'primary_key'], {'col'}, 'table', ['unknown']);
      for(final error in result.errors) {
        expect(error.code, isIn([
          SchemaValidationError.codeUndefinedPrimaryKeyColumn,
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
      for(final error in result.errors) {
        expect(error.code, isIn([
          SchemaValidationError.codeEmptyUniqueKey,
        ]));
      }
    });
    test('returns error for undefined unique key column', () {
      final result = validateUniqueKey(['table', 'unique_keys'], 'table', {'col'}, 'uk', ['unknown']);
      for(final error in result.errors) {
        expect(error.code, isIn([
          SchemaValidationError.codeUndefinedUniqueKeyColumn,
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
      for(final error in result.errors) {
        expect(error.code, isIn([
          SchemaValidationError.codeEmptyForeignKeyColumns,
        ]));
      }
    });
    test('returns error for undefined foreign key column', () {
      final fk = ForeignKey(columns: ['unknown'], reference: ForeignKeyReference(table: 'ref'));
      final result = validateForeignKey(['table', 'foreign_keys'], tableMap, 'table', {'col'}, 'fk', fk);
      for(final error in result.errors) {
        expect(error.code, isIn([
          SchemaValidationError.codeUndefinedForeignKeyColumn,
        ]));
      }
    });
    test('returns error for undefined reference table', () {
      final fk = ForeignKey(columns: ['col'], reference: ForeignKeyReference(table: 'not_exist'));
      final result = validateForeignKey(['table', 'foreign_keys'], tableMap, 'table', {'col'}, 'fk', fk);
      for(final error in result.errors) {
        expect(error.code, isIn([
          SchemaValidationError.codeUndefinedForeignKeyReferenceTable,
        ]));
      }
    });
    test('returns error for undefined reference unique key', () {
      final fk = ForeignKey(
        columns: ['col'],
        reference: ForeignKeyReference(table: 'ref', uniqueKey: 'not_exist'),
      );
      final result = validateForeignKey(['table', 'foreign_keys'], tableMap, 'table', {'col'}, 'fk', fk);
      for(final error in result.errors) {
        expect(error.code, isIn([
          SchemaValidationError.codeUndefinedForeignKeyReferenceUniqueKey,
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
      ),
    };
    test('returns no error for valid table config', () {
      final config = tableMap['table']!;
      final result = validateTableConfig(['table_config', '0'], typeSet, tableMap, config);
      expect(result.errors, isEmpty);
    });
  });

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
          ),
        ],
        columnType: {'type1': r'^.*$'},
        validation: [],
      );
      final result = validateSchema(schema);
      expect(result.errors, isEmpty);
    });
    test('returns error for invalid schema', () {
      final schema = Schema(
        tableConfig: [
          TableConfig(
            name: 'table',
            columns: [TableColumn(name: 'col', type: 'unknown')],
            primaryKey: [],
            uniqueKey: {'uk': []},
            foreignKey: {},
          ),
        ],
        columnType: {'type1': r'^.*$'},
        validation: [],
      );
      final result = validateSchema(schema);
      for(final error in result.errors) {
        expect(error.code, isIn([
          SchemaValidationError.codeUndefinedColumnType,
          SchemaValidationError.codeEmptyPrimaryKey,
          SchemaValidationError.codeEmptyUniqueKey,
        ]));
      }
    });
  });
}
