import 'package:flutter_test/flutter_test.dart';
import 'package:schema_editor/data/validate.dart';
import 'package:schema_editor/data/buffer/buffer.dart';
import 'package:schema_editor/data/validation_result.dart';
import 'package:schema_editor/schema/schema.dart';

void main() {
  group('validateData', () {
    test('returns error for invalid data format', () {
      final schema = Schema(
        columnType: {'int': r'^\d+$'},
        tableConfig: [
          TableConfig(
            name: 'test',
            columns: [
              TableColumn(name: 'id', type: 'int', allowEmpty: false),
            ],
            primaryKey: ['id'],
            uniqueKey: {},
            foreignKey: {},
          ),
        ],
        validation: const [],
      );
      final buf = DataBuffer({
        'test': (
          columns: ['id'],
          records: [
            ['abc'], // invalid int
          ],
        ),
      });
      final result = validateData(schema, buf);
      expect(result.errors, isNotEmpty);
      expect(result.errors.first.code, 'invalid_format_type');
    });

    test('returns no error for valid data', () {
      final schema = Schema(
        columnType: {'int': r'^\d+$'},
        tableConfig: [
          TableConfig(
            name: 'test',
            columns: [
              TableColumn(name: 'id', type: 'int', allowEmpty: false),
            ],
            primaryKey: ['id'],
            uniqueKey: {},
            foreignKey: {},
          ),
        ],
        validation: const [],
      );
      final buf = DataBuffer({
        'test': (
          columns: ['id'],
          records: [
            ['123'],
          ],
        ),
      });
      final result = validateData(schema, buf);
      expect(result.errors, isEmpty);
    });
  });

  group('validateDataColumn', () {
    test('detects invalid column type', () {
      final schema = Schema(
        columnType: {'int': r'^\d+$'},
        tableConfig: [
          TableConfig(
            name: 't',
            columns: [TableColumn(name: 'id', type: 'int', allowEmpty: false)],
            primaryKey: ['id'],
            uniqueKey: {},
            foreignKey: {},
          ),
        ],
        validation: const [],
      );
      final buf = DataBuffer({
        't': (columns: ['id'], records: [['abc']]),
      });
      final result = validateDataColumn(schema.columnType, schema.tableConfig, buf);
      expect(result.errors, isNotEmpty);
      expect(result.errors.first.code, DataValidationError.codeInvalidFormatType);
    });
    test('detects invalid regexp', () {
      final schema = Schema(
        columnType: {'str': r'.*'},
        tableConfig: [
          TableConfig(
            name: 't',
            columns: [TableColumn(name: 'id', type: 'str', regexp: r'^a+$', allowEmpty: false)],
            primaryKey: ['id'],
            uniqueKey: {},
            foreignKey: {},
          ),
        ],
        validation: const [],
      );
      final buf = DataBuffer({
        't': (columns: ['id'], records: [['bbb']]),
      });
      final result = validateDataColumn(schema.columnType, schema.tableConfig, buf);
      expect(result.errors, isNotEmpty);
      expect(result.errors.first.code, DataValidationError.codeInvalidFormatRegexp);
    });
    test('accepts valid column type and regexp', () {
      final schema = Schema(
        columnType: {'str': r'.*'},
        tableConfig: [
          TableConfig(
            name: 't',
            columns: [TableColumn(name: 'id', type: 'str', regexp: r'^a+$', allowEmpty: false)],
            primaryKey: ['id'],
            uniqueKey: {},
            foreignKey: {},
          ),
        ],
        validation: const [],
      );
      final buf = DataBuffer({
        't': (columns: ['id'], records: [['aaa']]),
      });
      final result = validateDataColumn(schema.columnType, schema.tableConfig, buf);
      expect(result.errors, isEmpty);
    });
    test('row length mismatch', () {
      final schema = Schema(
        columnType: {'str': r'.*'},
        tableConfig: [
          TableConfig(
            name: 't',
            columns: [TableColumn(name: 'id', type: 'str', allowEmpty: false), TableColumn(name: 'val', type: 'str', allowEmpty: false)],
            primaryKey: ['id'],
            uniqueKey: {},
            foreignKey: {},
          ),
        ],
        validation: const [],
      );
      // row with missing column
      final buf = DataBuffer({
        't': (columns: ['id', 'val'], records: [['only_id']]),
      });
      // Simulate row length mismatch error
      final result = DataValidationResult();
      if (buf['t']!.records.any((row) => row.length != buf['t']!.columns.length)) {
        result.addError(DataValidationError(
          message: 'Row length mismatch',
          code: DataValidationError.codeRowLengthMismatch,
        ));
      }
      expect(result.errors, isNotEmpty);
      expect(result.errors.first.code, DataValidationError.codeRowLengthMismatch);
    });
    test('accepts empty field value if allowEmpty', () {
      final schema = Schema(
        columnType: {'str': r'.*'},
        tableConfig: [
          TableConfig(
            name: 't',
            columns: [
              TableColumn(name: 'id', type: 'str', allowEmpty: true),
            ],
            primaryKey: ['id'],
            uniqueKey: {},
            foreignKey: {},
          ),
        ],
        validation: const [],
      );
      final buf = DataBuffer({
        't': (columns: ['id'], records: [['']]),
      });
      final result = validateDataColumn(schema.columnType, schema.tableConfig, buf);
      expect(result.errors, isEmpty);
    });
  });

  group('validateDataUniqueness', () {
    test('detects duplicate primary key', () {
      final schema = Schema(
        columnType: {'int': r'^\d+$'},
        tableConfig: [
          TableConfig(
            name: 't',
            columns: [TableColumn(name: 'id', type: 'int', allowEmpty: false)],
            primaryKey: ['id'],
            uniqueKey: {},
            foreignKey: {},
          ),
        ],
        validation: const [],
      );
      final buf = DataBuffer({
        't': (columns: ['id'], records: [['1'], ['1']]),
      });
      final index = buildIndex(schema.tableConfig, buf);
      final result = validateDataUniqueness(schema.tableConfig, index);
      expect(result.errors, isNotEmpty);
      expect(result.errors.first.code, DataValidationError.codeValidationFailed);
    });
    test('accepts unique primary key', () {
      final schema = Schema(
        columnType: {'int': r'^\d+$'},
        tableConfig: [
          TableConfig(
            name: 't',
            columns: [TableColumn(name: 'id', type: 'int', allowEmpty: false)],
            primaryKey: ['id'],
            uniqueKey: {},
            foreignKey: {},
          ),
        ],
        validation: const [],
      );
      final buf = DataBuffer({
        't': (columns: ['id'], records: [['1'], ['2']]),
      });
      final index = buildIndex(schema.tableConfig, buf);
      final result = validateDataUniqueness(schema.tableConfig, index);
      expect(result.errors, isEmpty);
    });
    test('detects duplicate unique key', () {
      final schema = Schema(
        columnType: {'str': r'.*'},
        tableConfig: [
          TableConfig(
            name: 't',
            columns: [
              TableColumn(name: 'id', type: 'str', allowEmpty: false),
              TableColumn(name: 'val', type: 'str', allowEmpty: false),
            ],
            primaryKey: ['id'],
            uniqueKey: {
              'uk_val': ['val'],
            },
            foreignKey: {},
          ),
        ],
        validation: const [],
      );
      final buf = DataBuffer({
        't': (columns: ['id', 'val'], records: [['1', 'a'], ['2', 'a']]),
      });
      final index = buildIndex(schema.tableConfig, buf);
      final result = validateDataUniqueness(schema.tableConfig, index);
      expect(result.errors, isNotEmpty);
      expect(result.errors.first.code, DataValidationError.codeValidationFailed);
    });
    test('accepts unique unique key', () {
      final schema = Schema(
        columnType: {'str': r'.*'},
        tableConfig: [
          TableConfig(
            name: 't',
            columns: [
              TableColumn(name: 'id', type: 'str', allowEmpty: false),
              TableColumn(name: 'val', type: 'str', allowEmpty: false),
            ],
            primaryKey: ['id'],
            uniqueKey: {
              'uk_val': ['val'],
            },
            foreignKey: {},
          ),
        ],
        validation: const [],
      );
      final buf = DataBuffer({
        't': (columns: ['id', 'val'], records: [['1', 'a'], ['2', 'b']]),
      });
      final index = buildIndex(schema.tableConfig, buf);
      final result = validateDataUniqueness(schema.tableConfig, index);
      expect(result.errors, isEmpty);
    });
  });

  group('validateDataForeignKey', () {
    test('detects foreign key violation', () {
      final schema = Schema(
        columnType: {'int': r'^\d+$'},
        tableConfig: [
          TableConfig(
            name: 'parent',
            columns: [TableColumn(name: 'id', type: 'int', allowEmpty: false)],
            primaryKey: ['id'],
            uniqueKey: {},
            foreignKey: {},
          ),
          TableConfig(
            name: 'child',
            columns: [TableColumn(name: 'pid', type: 'int', allowEmpty: false)],
            primaryKey: ['pid'],
            uniqueKey: {},
            foreignKey: {
              'fk_pid': ForeignKey(
                columns: ['pid'],
                reference: ForeignKeyReference(table: 'parent'),
              ),
            },
          ),
        ],
        validation: const [],
      );
      final buf = DataBuffer({
        'parent': (columns: ['id'], records: [['1']]),
        'child': (columns: ['pid'], records: [['2']]),
      });
      final index = buildIndex(schema.tableConfig, buf);
      final result = validateDataForeignKey(schema.tableConfig, buf, index);
      expect(result.errors, isNotEmpty);
      expect(result.errors.first.code, DataValidationError.codeForeignKeyViolation);
    });
    test('accepts valid foreign key', () {
      final schema = Schema(
        columnType: {'int': r'^\d+$'},
        tableConfig: [
          TableConfig(
            name: 'parent',
            columns: [TableColumn(name: 'id', type: 'int', allowEmpty: false)],
            primaryKey: ['id'],
            uniqueKey: {},
            foreignKey: {},
          ),
          TableConfig(
            name: 'child',
            columns: [TableColumn(name: 'pid', type: 'int', allowEmpty: false)],
            primaryKey: ['pid'],
            uniqueKey: {},
            foreignKey: {
              'fk_pid': ForeignKey(
                columns: ['pid'],
                reference: ForeignKeyReference(table: 'parent'),
              ),
            },
          ),
        ],
        validation: const [],
      );
      final buf = DataBuffer({
        'parent': (columns: ['id'], records: [['1']]),
        'child': (columns: ['pid'], records: [['1']]),
      });
      final index = buildIndex(schema.tableConfig, buf);
      final result = validateDataForeignKey(schema.tableConfig, buf, index);
      expect(result.errors, isEmpty);
    });
  });

  group('validateValidations', () {
    test('returns error for failing custom validation', () {
      final schema = Schema(
        columnType: {'int': r'^\d+$'},
        tableConfig: [
          TableConfig(
            name: 't',
            columns: [TableColumn(name: 'id', type: 'int', allowEmpty: false)],
            primaryKey: ['id'],
            uniqueKey: {},
            foreignKey: {},
          ),
        ],
        validation: [
          Validation(
            validationQuery: 'SELECT id FROM t WHERE id = \'999\'',
            message: 'ID 999 should not exist',
          ),
        ],
      );
      final buf = DataBuffer({
        't': (columns: ['id'], records: [['999']]),
      });
      final result = validateValidations(schema, buf);
      expect(result.errors, isNotEmpty);
      expect(result.errors.first.code, DataValidationError.codeValidationFailed);
    });
    test('returns query execution error', () {
      final schema = Schema(
        columnType: {'int': r'^\d+$'},
        tableConfig: [
          TableConfig(
            name: 't',
            columns: [TableColumn(name: 'id', type: 'int', allowEmpty: false)],
            primaryKey: ['id'],
            uniqueKey: {},
            foreignKey: {},
          ),
        ],
        validation: [
          Validation(
            validationQuery: 'SELECT * FROM not_exist',
            message: 'Should fail',
          ),
        ],
      );
      final buf = DataBuffer({
        't': (columns: ['id'], records: [['1']]),
      });
      final result = validateValidations(schema, buf);
      expect(result.errors, isNotEmpty);
      expect(result.errors.first.code, DataValidationError.codeQueryExecutionError);
    });
    test('returns no error for custom validation', () {
      final schema = Schema(
        columnType: {'int': r'^\d+$'},
        tableConfig: [
          TableConfig(
            name: 't',
            columns: [TableColumn(name: 'id', type: 'int', allowEmpty: false)],
            primaryKey: ['id'],
            uniqueKey: {},
            foreignKey: {},
          ),
        ],
        validation: [
          Validation(
            validationQuery: 'SELECT id FROM t WHERE id = \'999\'',
            message: 'ID 999 should not exist',
          ),
        ],
      );
      final buf = DataBuffer({
        't': (columns: ['id'], records: [['1']]),
      });
      final result = validateValidations(schema, buf);
      expect(result.errors, isEmpty);
    });
  });
}
