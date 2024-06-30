import 'package:csv_armor/csv/armor/schema/field_type.dart';
import 'package:csv_armor/csv/armor/schema/schema.dart';
import 'package:csv_armor/csv/armor/validate/result.dart';
import 'package:csv_armor/csv/armor/validate/validator.dart';
import 'package:test/test.dart';

typedef _Testcase_validateShape = ({
  String message,
  Schema inSchema,
  List<List<String>> inCSV,
  List<ValidationError> want,
});

typedef _Testcase_validatePrimaryKey = ({
  String message,
  Schema inSchema,
  List<List<String>> inCSV,
  List<ValidationError> want,
});

typedef _Testcase_validateUniqueKey = ({
  String message,
  Schema inSchema,
  List<List<String>> inCSV,
  List<ValidationError> want,
});

typedef _Testcase_validateFieldFormat = ({
  String message,
  Schema inSchema,
  List<List<String>> inCSV,
  List<ValidationError> want,
});

typedef _Testcase_validateForeignKeySchema = ({
  String message,
  Schema inBaseSchema,
  Schema inForeignSchema,
  List<ValidationError> want,
});

typedef _Testcase_validateForeignKey = ({
  String message,
  String fkName,
  Schema inBaseSchema,
  List<List<String>> inBaseCSV,
  Schema inForeignSchema,
  List<List<String>> inForeignCSV,
  List<ValidationError> want,
});

void main() {
  group("validateShape", () {
    final testcases = <_Testcase_validateShape>[
      (
        message: 'should detects no error',
        inSchema: Schema("data.csv", [Column("c1"), Column("c2")], ["c1"],
            headers: 1),
        inCSV: [
          ["f1", "f2"],
          ["f1", "f2"],
          ["f1", "f2"],
        ],
        want: [],
      ),
      (
        message: 'should detects too few headers error',
        inSchema: Schema("data.csv", [Column("id")], ["id"], headers: 3),
        inCSV: [
          ["header1"],
          ["header2"],
        ],
        want: [TooFewHeaders(2)],
      ),
      (
        message: 'should detects too column count mismatch',
        inSchema: Schema("data.csv", [Column("c1"), Column("c2")], ["c1"],
            headers: 1),
        inCSV: [
          ["f1", "f3"],
          ["f1"],
          ["f1", "f2", "f3"],
          ["f1", "f2"],
        ],
        want: [ColumnCountMismatch(1, 1), ColumnCountMismatch(2, 3)],
      ),
    ];
    for (final testcase in testcases) {
      test(testcase.message, () {
        final got = validateShape(testcase.inSchema, testcase.inCSV);
        expect(got, equals(testcase.want));
      });
    }
  });

  group("validatePrimaryKey", () {
    final testcases = <_Testcase_validatePrimaryKey>[
      (
        message: 'should detects no error',
        inSchema: Schema("data.csv", [Column("c1"), Column("c2")], ["c2", "c1"],
            headers: 1),
        inCSV: [
          ["c1", "c2"],
          ["a", "b"],
          ["a", "a"],
          ["b", "a"],
          ["b", "b"],
        ],
        want: [],
      ),
      (
        message: 'should detects primary key duplication',
        inSchema: Schema("data.csv", [Column("c1"), Column("c2")], ["c2", "c1"],
            headers: 1),
        inCSV: [
          ["c1", "c2"],
          ["a", "a"],
          ["a", "b"],
          ["b", "a"],
          ["b", "b"],
          ["a", "a"],
          ["a", "b"],
          ["b", "a"],
          ["b", "b"],
        ],
        want: [
          DuplicatedPrimaryKey(["a", "a"], [1, 5]),
          DuplicatedPrimaryKey(["b", "a"], [2, 6]),
          DuplicatedPrimaryKey(["a", "b"], [3, 7]),
          DuplicatedPrimaryKey(["b", "b"], [4, 8]),
        ],
      ),
    ];
    for (final testcase in testcases) {
      test(testcase.message, () {
        final got = validatePrimaryKey(testcase.inSchema, testcase.inCSV);
        expect(got, equals(testcase.want));
      });
    }
  });

  group("validateUniqueKey", () {
    final testcases = <_Testcase_validateUniqueKey>[
      (
        message: 'should detects no error',
        inSchema: Schema(
          "data.csv",
          [Column("c1"), Column("c2")],
          ["c2", "c1"],
          headers: 1,
          uniqueKey: {
            "uk1": ["c1"],
            "uk2": ["c2"],
          },
        ),
        inCSV: [
          ["c1", "c2"],
          ["a", "b"],
          ["b", "a"],
        ],
        want: [],
      ),
      (
        message: 'should detects unique key duplication',
        inSchema: Schema(
          "data.csv",
          [Column("c1"), Column("c2")],
          ["c2", "c1"],
          headers: 1,
          uniqueKey: {
            "uk1": ["c1"],
            "uk2": ["c2"],
          },
        ),
        inCSV: [
          ["c1", "c2"],
          ["a", "a"],
          ["a", "b"],
          ["b", "a"],
          ["b", "b"],
        ],
        want: [
          DuplicatedUniqueKey("uk1", ["a"], [1, 2]),
          DuplicatedUniqueKey("uk1", ["b"], [3, 4]),
          DuplicatedUniqueKey("uk2", ["a"], [1, 3]),
          DuplicatedUniqueKey("uk2", ["b"], [2, 4]),
        ],
      ),
    ];
    for (final testcase in testcases) {
      test(testcase.message, () {
        final got = validateUniqueKey(testcase.inSchema, testcase.inCSV);
        expect(got, equals(testcase.want));
      });
    }
  });

  group("validateFieldFormat", () {
    final defaultSchema = Schema(
      "data.csv",
      [Column("id")],
      ["id"],
      headers: 1,
    );
    final csvData = (String field) => [
          ['header'],
          [field]
        ];
    group("disallow empty", () {
      final testcases = <_Testcase_validateFieldFormat>[
        (
          message: 'should detects no error with "" for (no regex, text)',
          inSchema: defaultSchema.copyWith.columns([
            Column(
              "id",
              allowEmpty: false,
              regex: null,
              type: FieldType.text,
            ),
          ]),
          inCSV: csvData(""),
          want: [],
        ),
        (
          message: 'should detects no error with "abc" for (no regex, text)',
          inSchema: defaultSchema.copyWith.columns([
            Column(
              "id",
              allowEmpty: false,
              regex: null,
              type: FieldType.text,
            ),
          ]),
          inCSV: csvData("abc"),
          want: [],
        ),
        (
          message: 'should detects error with "" for (^xyz\$, text)',
          inSchema: defaultSchema.copyWith.columns([
            Column(
              "id",
              allowEmpty: false,
              regex: r'^xyz$',
              type: FieldType.text,
            ),
          ]),
          inCSV: csvData(""),
          want: [
            EmptyFieldNotAllowed(1, 0),
            FieldHasNoRegexMatch(1, 0, r'^xyz$'),
          ],
        ),
        (
          message: 'should detects error with "abc" for (^xyz\$, text)',
          inSchema: defaultSchema.copyWith.columns([
            Column(
              "id",
              allowEmpty: false,
              regex: r'^xyz$',
              type: FieldType.text,
            ),
          ]),
          inCSV: csvData("abc"),
          want: [FieldHasNoRegexMatch(1, 0, r'^xyz$')],
        ),
        (
          message: 'should detects no error with "xyz" for (^xyz\$, text)',
          inSchema: defaultSchema.copyWith.columns([
            Column(
              "id",
              allowEmpty: false,
              regex: r'^xyz$',
              type: FieldType.text,
            ),
          ]),
          inCSV: csvData("xyz"),
          want: [],
        ),
        (
          message: 'should detects error with "" for (no regex, integer)',
          inSchema: defaultSchema.copyWith.columns([
            Column(
              "id",
              allowEmpty: false,
              regex: null,
              type: FieldType.integer,
            ),
          ]),
          inCSV: csvData(""),
          want: [
            EmptyFieldNotAllowed(1, 0),
            FieldHasNoTypeMatch(1, 0, "integer"),
          ],
        ),
        (
          message: 'should detects no error with "abc" for (no regex, integer)',
          inSchema: defaultSchema.copyWith.columns([
            Column(
              "id",
              allowEmpty: false,
              regex: null,
              type: FieldType.integer,
            ),
          ]),
          inCSV: csvData("abc"),
          want: [
            FieldHasNoTypeMatch(1, 0, "integer"),
          ],
        ),
        (
          message: 'should detects error with "" for (^xyz\$, integer)',
          inSchema: defaultSchema.copyWith.columns([
            Column(
              "id",
              allowEmpty: false,
              regex: r'^xyz$',
              type: FieldType.integer,
            ),
          ]),
          inCSV: csvData(""),
          want: [
            EmptyFieldNotAllowed(1, 0),
            FieldHasNoTypeMatch(1, 0, "integer"),
            FieldHasNoRegexMatch(1, 0, r'^xyz$'),
          ],
        ),
        (
          message: 'should detects error with "abc" for (^xyz\$, integer)',
          inSchema: defaultSchema.copyWith.columns([
            Column(
              "id",
              allowEmpty: false,
              regex: r'^xyz$',
              type: FieldType.integer,
            ),
          ]),
          inCSV: csvData("abc"),
          want: [
            FieldHasNoTypeMatch(1, 0, "integer"),
            FieldHasNoRegexMatch(1, 0, r'^xyz$'),
          ],
        ),
        (
          message: 'should detects no error with "xyz" for (^xyz\$, integer)',
          inSchema: defaultSchema.copyWith.columns([
            Column(
              "id",
              allowEmpty: false,
              regex: r'^xyz$',
              type: FieldType.integer,
            ),
          ]),
          inCSV: csvData("xyz"),
          want: [
            FieldHasNoTypeMatch(1, 0, "integer"),
          ],
        ),
        (
          message: 'should detects no error with "123" for (^xyz\$, integer)',
          inSchema: defaultSchema.copyWith.columns([
            Column(
              "id",
              allowEmpty: false,
              regex: r'^xyz$',
              type: FieldType.integer,
            ),
          ]),
          inCSV: csvData("123"),
          want: [
            FieldHasNoRegexMatch(1, 0, r'^xyz$'),
          ],
        ),
        (
          message: 'should detects error with "" for (^123\$, integer)',
          inSchema: defaultSchema.copyWith.columns([
            Column(
              "id",
              allowEmpty: false,
              regex: r'^123$',
              type: FieldType.integer,
            ),
          ]),
          inCSV: csvData(""),
          want: [
            EmptyFieldNotAllowed(1, 0),
            FieldHasNoTypeMatch(1, 0, "integer"),
            FieldHasNoRegexMatch(1, 0, r'^123$'),
          ],
        ),
        (
          message: 'should detects error with "abc" for (^123\$, integer)',
          inSchema: defaultSchema.copyWith.columns([
            Column(
              "id",
              allowEmpty: false,
              regex: r'^123$',
              type: FieldType.integer,
            ),
          ]),
          inCSV: csvData("abc"),
          want: [
            FieldHasNoTypeMatch(1, 0, "integer"),
            FieldHasNoRegexMatch(1, 0, r'^123$'),
          ],
        ),
        (
          message: 'should detects no error with "123" for (^123\$, integer)',
          inSchema: defaultSchema.copyWith.columns([
            Column(
              "id",
              allowEmpty: false,
              regex: r'^123$',
              type: FieldType.integer,
            ),
          ]),
          inCSV: csvData("123"),
          want: [],
        ),
      ];
      for (final testcase in testcases) {
        test(testcase.message, () {
          final got = validateFieldFormat(testcase.inSchema, testcase.inCSV);
          expect(got, equals(testcase.want));
        });
      }
    });

    group("allow empty", () {
      final testcases = <_Testcase_validateFieldFormat>[
        (
          message: 'should detects no error with "" for (no regex, text)',
          inSchema: defaultSchema.copyWith.columns([
            Column(
              "id",
              allowEmpty: true,
              regex: null,
              type: FieldType.text,
            ),
          ]),
          inCSV: csvData(""),
          want: [],
        ),
        (
          message: 'should detects no error with "abc" for (no regex, text)',
          inSchema: defaultSchema.copyWith.columns([
            Column(
              "id",
              allowEmpty: true,
              regex: null,
              type: FieldType.text,
            ),
          ]),
          inCSV: csvData("abc"),
          want: [],
        ),
        (
          message: 'should detects no error with "" for (^xyz\$, text)',
          inSchema: defaultSchema.copyWith.columns([
            Column(
              "id",
              allowEmpty: true,
              regex: r'^xyz$',
              type: FieldType.text,
            ),
          ]),
          inCSV: csvData(""),
          want: [],
        ),
        (
          message: 'should detects error with "abc" for (^xyz\$, text)',
          inSchema: defaultSchema.copyWith.columns([
            Column(
              "id",
              allowEmpty: true,
              regex: r'^xyz$',
              type: FieldType.text,
            ),
          ]),
          inCSV: csvData("abc"),
          want: [FieldHasNoRegexMatch(1, 0, r'^xyz$')],
        ),
        (
          message: 'should detects no error with "xyz" for (^xyz\$, text)',
          inSchema: defaultSchema.copyWith.columns([
            Column(
              "id",
              allowEmpty: true,
              regex: r'^xyz$',
              type: FieldType.text,
            ),
          ]),
          inCSV: csvData("xyz"),
          want: [],
        ),
        (
          message: 'should detects error with "" for (no regex, integer)',
          inSchema: defaultSchema.copyWith.columns([
            Column(
              "id",
              allowEmpty: true,
              regex: null,
              type: FieldType.integer,
            ),
          ]),
          inCSV: csvData(""),
          want: [],
        ),
        (
          message: 'should detects no error with "abc" for (no regex, integer)',
          inSchema: defaultSchema.copyWith.columns([
            Column(
              "id",
              allowEmpty: true,
              regex: null,
              type: FieldType.integer,
            ),
          ]),
          inCSV: csvData("abc"),
          want: [
            FieldHasNoTypeMatch(1, 0, "integer"),
          ],
        ),
        (
          message: 'should detects error with "" for (^xyz\$, integer)',
          inSchema: defaultSchema.copyWith.columns([
            Column(
              "id",
              allowEmpty: true,
              regex: r'^xyz$',
              type: FieldType.integer,
            ),
          ]),
          inCSV: csvData(""),
          want: [],
        ),
        (
          message: 'should detects error with "abc" for (^xyz\$, integer)',
          inSchema: defaultSchema.copyWith.columns([
            Column(
              "id",
              allowEmpty: true,
              regex: r'^xyz$',
              type: FieldType.integer,
            ),
          ]),
          inCSV: csvData("abc"),
          want: [
            FieldHasNoTypeMatch(1, 0, "integer"),
            FieldHasNoRegexMatch(1, 0, r'^xyz$'),
          ],
        ),
        (
          message: 'should detects no error with "xyz" for (^xyz\$, integer)',
          inSchema: defaultSchema.copyWith.columns([
            Column(
              "id",
              allowEmpty: true,
              regex: r'^xyz$',
              type: FieldType.integer,
            ),
          ]),
          inCSV: csvData("xyz"),
          want: [
            FieldHasNoTypeMatch(1, 0, "integer"),
          ],
        ),
        (
          message: 'should detects no error with "123" for (^xyz\$, integer)',
          inSchema: defaultSchema.copyWith.columns([
            Column(
              "id",
              allowEmpty: true,
              regex: r'^xyz$',
              type: FieldType.integer,
            ),
          ]),
          inCSV: csvData("123"),
          want: [
            FieldHasNoRegexMatch(1, 0, r'^xyz$'),
          ],
        ),
        (
          message: 'should detects error with "" for (^123\$, integer)',
          inSchema: defaultSchema.copyWith.columns([
            Column(
              "id",
              allowEmpty: true,
              regex: r'^123$',
              type: FieldType.integer,
            ),
          ]),
          inCSV: csvData(""),
          want: [],
        ),
        (
          message: 'should detects error with "abc" for (^123\$, integer)',
          inSchema: defaultSchema.copyWith.columns([
            Column(
              "id",
              allowEmpty: true,
              regex: r'^123$',
              type: FieldType.integer,
            ),
          ]),
          inCSV: csvData("abc"),
          want: [
            FieldHasNoTypeMatch(1, 0, "integer"),
            FieldHasNoRegexMatch(1, 0, r'^123$'),
          ],
        ),
        (
          message: 'should detects no error with "123" for (^123\$, integer)',
          inSchema: defaultSchema.copyWith.columns([
            Column(
              "id",
              allowEmpty: true,
              regex: r'^123$',
              type: FieldType.integer,
            ),
          ]),
          inCSV: csvData("123"),
          want: [],
        ),
      ];
      for (final testcase in testcases) {
        test(testcase.message, () {
          final got = validateFieldFormat(testcase.inSchema, testcase.inCSV);
          expect(got, equals(testcase.want));
        });
      }
    });

    group("text type", () {
      final testcases = <_Testcase_validateFieldFormat>[
        (
          message: 'should detects no error with ""',
          inSchema: defaultSchema.copyWith.columns([
            Column(
              "id",
              allowEmpty: false,
              regex: null,
              type: FieldType.text,
            ),
          ]),
          inCSV: csvData(""),
          want: [],
        ),
        (
          message: 'should detects no error with "abc"',
          inSchema: defaultSchema.copyWith.columns([
            Column(
              "id",
              allowEmpty: false,
              regex: null,
              type: FieldType.text,
            ),
          ]),
          inCSV: csvData("abc"),
          want: [],
        ),
      ];
      for (final testcase in testcases) {
        test(testcase.message, () {
          final got = validateFieldFormat(testcase.inSchema, testcase.inCSV);
          expect(got, equals(testcase.want));
        });
      }
    });

    group("integer type", () {
      final testcases = <_Testcase_validateFieldFormat>[
        (
          message: 'should detects error with ""',
          inSchema: defaultSchema.copyWith.columns([
            Column(
              "id",
              allowEmpty: false,
              regex: null,
              type: FieldType.integer,
            ),
          ]),
          inCSV: csvData(""),
          want: [
            EmptyFieldNotAllowed(1, 0),
            FieldHasNoTypeMatch(1, 0, "integer"),
          ],
        ),
        (
          message: 'should detects error with "abc"',
          inSchema: defaultSchema.copyWith.columns([
            Column(
              "id",
              allowEmpty: false,
              regex: null,
              type: FieldType.integer,
            ),
          ]),
          inCSV: csvData("abc"),
          want: [
            FieldHasNoTypeMatch(1, 0, "integer"),
          ],
        ),
        (
          message: 'should detects no error with "0"',
          inSchema: defaultSchema.copyWith.columns([
            Column(
              "id",
              allowEmpty: false,
              regex: null,
              type: FieldType.integer,
            ),
          ]),
          inCSV: csvData("0"),
          want: [],
        ),
        (
          message: 'should detects no error with "0x1Ab"',
          inSchema: defaultSchema.copyWith.columns([
            Column(
              "id",
              allowEmpty: false,
              regex: null,
              type: FieldType.integer,
            ),
          ]),
          inCSV: csvData("0x1Ab"),
          want: [],
        ),
        (
          message: 'should detects no error with "0o765"',
          inSchema: defaultSchema.copyWith.columns([
            Column(
              "id",
              allowEmpty: false,
              regex: null,
              type: FieldType.integer,
            ),
          ]),
          inCSV: csvData("0o765"),
          want: [],
        ),
        (
          message: 'should detects no error with "0b1010"',
          inSchema: defaultSchema.copyWith.columns([
            Column(
              "id",
              allowEmpty: false,
              regex: null,
              type: FieldType.integer,
            ),
          ]),
          inCSV: csvData("0b1010"),
          want: [],
        ),
        (
          message: 'should detects no error with "-123"',
          inSchema: defaultSchema.copyWith.columns([
            Column(
              "id",
              allowEmpty: false,
              regex: null,
              type: FieldType.integer,
            ),
          ]),
          inCSV: csvData("-123"),
          want: [],
        ),
        (
          message: 'should detects no error with "+123"',
          inSchema: defaultSchema.copyWith.columns([
            Column(
              "id",
              allowEmpty: false,
              regex: null,
              type: FieldType.integer,
            ),
          ]),
          inCSV: csvData("+123"),
          want: [],
        ),
        (
          message: 'should detects no error with "1\'2_3"',
          inSchema: defaultSchema.copyWith.columns([
            Column(
              "id",
              allowEmpty: false,
              regex: null,
              type: FieldType.integer,
            ),
          ]),
          inCSV: csvData("1'2_3"),
          want: [],
        ),
        (
          message: 'should detects no error with "0x1\'A_b"',
          inSchema: defaultSchema.copyWith.columns([
            Column(
              "id",
              allowEmpty: false,
              regex: null,
              type: FieldType.integer,
            ),
          ]),
          inCSV: csvData("0x1'A_b"),
          want: [],
        ),
        (
          message: 'should detects no error with "0o7\'6_5"',
          inSchema: defaultSchema.copyWith.columns([
            Column(
              "id",
              allowEmpty: false,
              regex: null,
              type: FieldType.integer,
            ),
          ]),
          inCSV: csvData("0o7'6_5"),
          want: [],
        ),
        (
          message: 'should detects no error with "0b1\'0_1"',
          inSchema: defaultSchema.copyWith.columns([
            Column(
              "id",
              allowEmpty: false,
              regex: null,
              type: FieldType.integer,
            ),
          ]),
          inCSV: csvData("0b1'0_1"),
          want: [],
        ),
      ];
      for (final testcase in testcases) {
        test(testcase.message, () {
          final got = validateFieldFormat(testcase.inSchema, testcase.inCSV);
          expect(got, equals(testcase.want));
        });
      }
    });

    group("decimal type", () {
      final testcases = <_Testcase_validateFieldFormat>[
        (
          message: 'should detects error with ""',
          inSchema: defaultSchema.copyWith.columns([
            Column(
              "id",
              allowEmpty: false,
              regex: null,
              type: FieldType.decimal,
            ),
          ]),
          inCSV: csvData(""),
          want: [
            EmptyFieldNotAllowed(1, 0),
            FieldHasNoTypeMatch(1, 0, "decimal"),
          ],
        ),
        (
          message: 'should detects error with "abc"',
          inSchema: defaultSchema.copyWith.columns([
            Column(
              "id",
              allowEmpty: false,
              regex: null,
              type: FieldType.decimal,
            ),
          ]),
          inCSV: csvData("abc"),
          want: [
            FieldHasNoTypeMatch(1, 0, "decimal"),
          ],
        ),
        (
          message: 'should detects no error with "0"',
          inSchema: defaultSchema.copyWith.columns([
            Column(
              "id",
              allowEmpty: false,
              regex: null,
              type: FieldType.decimal,
            ),
          ]),
          inCSV: csvData("0"),
          want: [],
        ),
        (
          message: 'should detects no error with "-123"',
          inSchema: defaultSchema.copyWith.columns([
            Column(
              "id",
              allowEmpty: false,
              regex: null,
              type: FieldType.decimal,
            ),
          ]),
          inCSV: csvData("-123"),
          want: [],
        ),
        (
          message: 'should detects no error with "+123"',
          inSchema: defaultSchema.copyWith.columns([
            Column(
              "id",
              allowEmpty: false,
              regex: null,
              type: FieldType.decimal,
            ),
          ]),
          inCSV: csvData("+123"),
          want: [],
        ),
        (
          message: 'should detects no error with "+123.456"',
          inSchema: defaultSchema.copyWith.columns([
            Column(
              "id",
              allowEmpty: false,
              regex: null,
              type: FieldType.decimal,
            ),
          ]),
          inCSV: csvData("+123.456"),
          want: [],
        ),
        (
          message: 'should detects no error with "-000.000"',
          inSchema: defaultSchema.copyWith.columns([
            Column(
              "id",
              allowEmpty: false,
              regex: null,
              type: FieldType.decimal,
            ),
          ]),
          inCSV: csvData("-000.000"),
          want: [],
        ),
        (
          message: 'should detects no error with "+123,456"',
          inSchema: defaultSchema.copyWith.columns([
            Column(
              "id",
              allowEmpty: false,
              regex: null,
              type: FieldType.decimal,
            ),
          ]),
          inCSV: csvData("+123,456"),
          want: [],
        ),
        (
          message: 'should detects no error with "-000,000"',
          inSchema: defaultSchema.copyWith.columns([
            Column(
              "id",
              allowEmpty: false,
              regex: null,
              type: FieldType.decimal,
            ),
          ]),
          inCSV: csvData("-000,000"),
          want: [],
        ),
        (
          message: 'should detects no error with "-1\'2_3,4_5\'6"',
          inSchema: defaultSchema.copyWith.columns([
            Column(
              "id",
              allowEmpty: false,
              regex: null,
              type: FieldType.decimal,
            ),
          ]),
          inCSV: csvData("-1'2_3,4_5'6"),
          want: [],
        ),
        (
          message: 'should detects no error with "1\'2_3.4_5\'6"',
          inSchema: defaultSchema.copyWith.columns([
            Column(
              "id",
              allowEmpty: false,
              regex: null,
              type: FieldType.decimal,
            ),
          ]),
          inCSV: csvData("1'2_3.4_5'6"),
          want: [],
        ),
      ];
      for (final testcase in testcases) {
        test(testcase.message, () {
          final got = validateFieldFormat(testcase.inSchema, testcase.inCSV);
          expect(got, equals(testcase.want));
        });
      }
    });

    group("boolean type", () {
      final testcases = <_Testcase_validateFieldFormat>[
        (
          message: 'should detects error with ""',
          inSchema: defaultSchema.copyWith.columns([
            Column(
              "id",
              allowEmpty: false,
              regex: null,
              type: FieldType.boolean,
            ),
          ]),
          inCSV: csvData(""),
          want: [
            EmptyFieldNotAllowed(1, 0),
            FieldHasNoTypeMatch(1, 0, "boolean"),
          ],
        ),
        (
          message: 'should detects error with "abc"',
          inSchema: defaultSchema.copyWith.columns([
            Column(
              "id",
              allowEmpty: false,
              regex: null,
              type: FieldType.boolean,
            ),
          ]),
          inCSV: csvData("abc"),
          want: [
            FieldHasNoTypeMatch(1, 0, "boolean"),
          ],
        ),
        (
          message: 'should detects error with "2"',
          inSchema: defaultSchema.copyWith.columns([
            Column(
              "id",
              allowEmpty: false,
              regex: null,
              type: FieldType.boolean,
            ),
          ]),
          inCSV: csvData("2"),
          want: [
            FieldHasNoTypeMatch(1, 0, "boolean"),
          ],
        ),
        (
          message: 'should detects no error with "true"',
          inSchema: defaultSchema.copyWith.columns([
            Column(
              "id",
              allowEmpty: false,
              regex: null,
              type: FieldType.boolean,
            ),
          ]),
          inCSV: csvData("true"),
          want: [],
        ),
        (
          message: 'should detects no error with "false"',
          inSchema: defaultSchema.copyWith.columns([
            Column(
              "id",
              allowEmpty: false,
              regex: null,
              type: FieldType.boolean,
            ),
          ]),
          inCSV: csvData("false"),
          want: [],
        ),
        (
          message: 'should detects no error with "True"',
          inSchema: defaultSchema.copyWith.columns([
            Column(
              "id",
              allowEmpty: false,
              regex: null,
              type: FieldType.boolean,
            ),
          ]),
          inCSV: csvData("True"),
          want: [],
        ),
        (
          message: 'should detects no error with "True"',
          inSchema: defaultSchema.copyWith.columns([
            Column(
              "id",
              allowEmpty: false,
              regex: null,
              type: FieldType.boolean,
            ),
          ]),
          inCSV: csvData("False"),
          want: [],
        ),
        (
          message: 'should detects no error with "TRUE"',
          inSchema: defaultSchema.copyWith.columns([
            Column(
              "id",
              allowEmpty: false,
              regex: null,
              type: FieldType.boolean,
            ),
          ]),
          inCSV: csvData("TRUE"),
          want: [],
        ),
        (
          message: 'should detects no error with "FALSE"',
          inSchema: defaultSchema.copyWith.columns([
            Column(
              "id",
              allowEmpty: false,
              regex: null,
              type: FieldType.boolean,
            ),
          ]),
          inCSV: csvData("FALSE"),
          want: [],
        ),
        (
          message: 'should detects no error with "T"',
          inSchema: defaultSchema.copyWith.columns([
            Column(
              "id",
              allowEmpty: false,
              regex: null,
              type: FieldType.boolean,
            ),
          ]),
          inCSV: csvData("T"),
          want: [],
        ),
        (
          message: 'should detects no error with "F"',
          inSchema: defaultSchema.copyWith.columns([
            Column(
              "id",
              allowEmpty: false,
              regex: null,
              type: FieldType.boolean,
            ),
          ]),
          inCSV: csvData("F"),
          want: [],
        ),
        (
          message: 'should detects no error with "t"',
          inSchema: defaultSchema.copyWith.columns([
            Column(
              "id",
              allowEmpty: false,
              regex: null,
              type: FieldType.boolean,
            ),
          ]),
          inCSV: csvData("t"),
          want: [],
        ),
        (
          message: 'should detects no error with "f"',
          inSchema: defaultSchema.copyWith.columns([
            Column(
              "id",
              allowEmpty: false,
              regex: null,
              type: FieldType.boolean,
            ),
          ]),
          inCSV: csvData("f"),
          want: [],
        ),
        (
          message: 'should detects no error with "1"',
          inSchema: defaultSchema.copyWith.columns([
            Column(
              "id",
              allowEmpty: false,
              regex: null,
              type: FieldType.boolean,
            ),
          ]),
          inCSV: csvData("1"),
          want: [],
        ),
        (
          message: 'should detects no error with "0"',
          inSchema: defaultSchema.copyWith.columns([
            Column(
              "id",
              allowEmpty: false,
              regex: null,
              type: FieldType.boolean,
            ),
          ]),
          inCSV: csvData("0"),
          want: [],
        ),
      ];
      for (final testcase in testcases) {
        test(testcase.message, () {
          final got = validateFieldFormat(testcase.inSchema, testcase.inCSV);
          expect(got, equals(testcase.want));
        });
      }
    });

    group("datetime type", () {
      final testcases = <_Testcase_validateFieldFormat>[
        (
          message: 'should detects error with ""',
          inSchema: defaultSchema.copyWith.columns([
            Column(
              "id",
              allowEmpty: false,
              regex: null,
              type: FieldType.datetime,
            ),
          ]),
          inCSV: csvData(""),
          want: [
            EmptyFieldNotAllowed(1, 0),
            FieldHasNoTypeMatch(1, 0, "datetime"),
          ],
        ),
        (
          message: 'should detects error with "abc"',
          inSchema: defaultSchema.copyWith.columns([
            Column(
              "id",
              allowEmpty: false,
              regex: null,
              type: FieldType.datetime,
            ),
          ]),
          inCSV: csvData("abc"),
          want: [
            FieldHasNoTypeMatch(1, 0, "datetime"),
          ],
        ),
        (
          message:
              'should detects no error with "2024-06-30T12:34:56.123456789Z"',
          inSchema: defaultSchema.copyWith.columns([
            Column(
              "id",
              allowEmpty: false,
              regex: null,
              type: FieldType.datetime,
            ),
          ]),
          inCSV: csvData("2024-06-30T12:34:56.123456789+09:00"),
          want: [],
        ),
        (
          message:
              'should detects no error with "-99999999-01-01T00:00:00.000-14:00"',
          inSchema: defaultSchema.copyWith.columns([
            Column(
              "id",
              allowEmpty: false,
              regex: null,
              type: FieldType.datetime,
            ),
          ]),
          inCSV: csvData("-99999999-01-01T00:00:00.000-14:00"),
          want: [],
        ),
        (
          message:
              'should detects no error with "-99999999-01-01T00:00:00.999-14:00"',
          inSchema: defaultSchema.copyWith.columns([
            Column(
              "id",
              allowEmpty: false,
              regex: null,
              type: FieldType.datetime,
            ),
          ]),
          inCSV: csvData("99999999-12-31T24:00:00.999+14:00"),
          want: [],
        ),
        (
          message: 'should detects no error with "0000-01-01T00:00:00.000Z"',
          inSchema: defaultSchema.copyWith.columns([
            Column(
              "id",
              allowEmpty: false,
              regex: null,
              type: FieldType.datetime,
            ),
          ]),
          inCSV: csvData("0000-01-01T00:00:00.000Z"),
          want: [],
        ),
        (
          message:
              'should detects no error with "-99999999-W01-1T00:00:00.000-14:00"',
          inSchema: defaultSchema.copyWith.columns([
            Column(
              "id",
              allowEmpty: false,
              regex: null,
              type: FieldType.datetime,
            ),
          ]),
          inCSV: csvData("-99999999-W01-1T00:00:00.000-14:00"),
          want: [],
        ),
        (
          message:
              'should detects no error with "99999999-W53-7T24:00:00.999+14:00"',
          inSchema: defaultSchema.copyWith.columns([
            Column(
              "id",
              allowEmpty: false,
              regex: null,
              type: FieldType.datetime,
            ),
          ]),
          inCSV: csvData("99999999-W53-7T24:00:00.999+14:00"),
          want: [],
        ),
        (
          message: 'should detects no error with "0000-W01-1T00:00:00.000Z"',
          inSchema: defaultSchema.copyWith.columns([
            Column(
              "id",
              allowEmpty: false,
              regex: null,
              type: FieldType.datetime,
            ),
          ]),
          inCSV: csvData("0000-W01-1T00:00:00.000Z"),
          want: [],
        ),
        (
          message:
              'should detects no error with "-99999999-001T00:00:00.000-14:00"',
          inSchema: defaultSchema.copyWith.columns([
            Column(
              "id",
              allowEmpty: false,
              regex: null,
              type: FieldType.datetime,
            ),
          ]),
          inCSV: csvData("-99999999-001T00:00:00.000-14:00"),
          want: [],
        ),
        (
          message:
              'should detects no error with "99999999-366T24:00:00.999+14:00"',
          inSchema: defaultSchema.copyWith.columns([
            Column(
              "id",
              allowEmpty: false,
              regex: null,
              type: FieldType.datetime,
            ),
          ]),
          inCSV: csvData("99999999-366T24:00:00.999+14:00"),
          want: [],
        ),
        (
          message: 'should detects no error with "0000-001T00:00:00.000Z"',
          inSchema: defaultSchema.copyWith.columns([
            Column(
              "id",
              allowEmpty: false,
              regex: null,
              type: FieldType.datetime,
            ),
          ]),
          inCSV: csvData("0000-001T00:00:00.000Z"),
          want: [],
        ),
      ];
      for (final testcase in testcases) {
        test(testcase.message, () {
          final got = validateFieldFormat(testcase.inSchema, testcase.inCSV);
          expect(got, equals(testcase.want));
        });
      }
    });

    group("regex", () {
      final testcases = <_Testcase_validateFieldFormat>[
        (
          message:
              'should detects no error with "" for regex "${r'^\d{3,4}-(abc|def)_[0-9]?$'}"',
          inSchema: defaultSchema.copyWith.columns([
            Column(
              "id",
              allowEmpty: false,
              regex: r'^\d{3,4}-(abc|def)_[0-9]?$',
              type: FieldType.text,
            ),
          ]),
          inCSV: csvData(''),
          want: [
            EmptyFieldNotAllowed(1, 0),
            FieldHasNoRegexMatch(1, 0, r'^\d{3,4}-(abc|def)_[0-9]?$'),
          ],
        ),
        (
          message:
              'should detects no error with "xyz" for regex "${r'^\d{3,4}-(abc|def)_[0-9]?$'}"',
          inSchema: defaultSchema.copyWith.columns([
            Column(
              "id",
              allowEmpty: false,
              regex: r'^\d{3,4}-(abc|def)_[0-9]?$',
              type: FieldType.text,
            ),
          ]),
          inCSV: csvData('xyz'),
          want: [
            FieldHasNoRegexMatch(1, 0, r'^\d{3,4}-(abc|def)_[0-9]?$'),
          ],
        ),
        (
          message:
              'should detects no error with "123-def_" for regex "${r'^\d{3,4}-(abc|def)_[0-9]?$'}"',
          inSchema: defaultSchema.copyWith.columns([
            Column(
              "id",
              allowEmpty: false,
              regex: r'^\d{3,4}-(abc|def)_[0-9]?$',
              type: FieldType.text,
            ),
          ]),
          inCSV: csvData('123-def_'),
          want: [],
        ),
      ];
      for (final testcase in testcases) {
        test(testcase.message, () {
          final got = validateFieldFormat(testcase.inSchema, testcase.inCSV);
          expect(got, equals(testcase.want));
        });
      }
    });
  });

  group("validateForeignKeySchema", () {
    final defaultBaseSchema = Schema(
      "data.csv",
      [Column("c1"), Column("c2"), Column("c3")],
      ["c1"],
      headers: 1,
    );
    final defaultForeignSchema = Schema(
      "data.csv",
      [Column("f1"), Column("f2"), Column("f3")],
      ["f1"],
      headers: 2,
    );

    final testcases = <_Testcase_validateForeignKeySchema>[
      (
        message:
            'should detects error with foreign key reference not in foreign columns',
        inBaseSchema: defaultBaseSchema.copyWith(
          foreignKey: {
            "fk1": ForeignKey(
              ["c2", "c1"],
              ForeignKeyReference("data.csv", ["x1", "x2"]),
            ),
          },
        ),
        inForeignSchema: defaultForeignSchema.copyWith(),
        want: [
          ForeignKeyReferenceColumnNotInForeignColumns("fk1", "x1"),
          ForeignKeyReferenceColumnNotInForeignColumns("fk1", "x2"),
        ],
      ),
      (
        message:
            'should detects error with foreign key reference not unique in foreign columns',
        inBaseSchema: defaultBaseSchema.copyWith(
          foreignKey: {
            "fk1": ForeignKey(
              ["c2", "c1"],
              ForeignKeyReference("data.csv", ["f1", "f2"]),
            ),
          },
        ),
        inForeignSchema: defaultForeignSchema.copyWith(),
        want: [ForeignKeyReferenceNotUniqueInForeignColumns("fk1")],
      ),
      (
        message:
            'should detects no error if foreign key reference is foreign primary key',
        inBaseSchema: defaultBaseSchema.copyWith(
          foreignKey: {
            "fk1": ForeignKey(
              ["c1"],
              ForeignKeyReference("data.csv", ["f1"]),
            ),
          },
        ),
        inForeignSchema: defaultForeignSchema.copyWith(),
        want: [],
      ),
      (
        message:
            'should detects no error if foreign key reference is foreign unique key',
        inBaseSchema: defaultBaseSchema.copyWith(
          foreignKey: {
            "fk1": ForeignKey(
              ["c1"],
              ForeignKeyReference("data.csv", ["f1"]),
            ),
          },
        ),
        inForeignSchema: defaultForeignSchema.copyWith(),
        want: [],
      ),
      (
        message:
            'should detects error if foreign key reference order mismatch foreign primary key order',
        inBaseSchema: defaultBaseSchema.copyWith(
          foreignKey: {
            "fk1": ForeignKey(
              ["c1", "c2"],
              ForeignKeyReference("data.csv", ["f2", "f1"]),
            ),
          },
        ),
        inForeignSchema: defaultForeignSchema.copyWith(
          primaryKey: ["f1", "f2"],
        ),
        want: [ForeignKeyReferenceNotUniqueInForeignColumns("fk1")],
      ),
      (
        message:
            'should detects error if foreign key reference order mismatch foreign unique key order',
        inBaseSchema: defaultBaseSchema.copyWith(
          foreignKey: {
            "fk1": ForeignKey(
              ["c1", "c2"],
              ForeignKeyReference("data.csv", ["f2", "f1"]),
            ),
          },
        ),
        inForeignSchema: defaultForeignSchema.copyWith(
          uniqueKey: {
            "uk1": ["f1", "f2"],
          },
        ),
        want: [ForeignKeyReferenceNotUniqueInForeignColumns("fk1")],
      ),
    ];
    for (final testcase in testcases) {
      test(testcase.message, () {
        final got = validateForeignKeySchema(
          testcase.inBaseSchema,
          testcase.inForeignSchema,
        );
        expect(got, equals(testcase.want));
      });
    }
  });

  group("validateForeignKey", () {
    final defaultBaseSchema = Schema(
      "data.csv",
      [Column("c1"), Column("c2"), Column("c3")],
      ["c1"],
      headers: 1,
    );
    List<List<String>> baseCsvData(List<String> values) => [
          ["c1", "c2", "c3"],
          values,
        ];
    final defaultForeignSchema = Schema(
      "data.csv",
      [Column("f1"), Column("f2"), Column("f3")],
      ["f1"],
      headers: 2,
    );
    List<List<String>> foreignCsvData(List<String> values) => [
          ["c1", "c2", "c3"],
          ["c1", "c2", "c3"],
          values,
        ];

    final testcases = <_Testcase_validateForeignKey>[
      (
        message:
            'should detects no error if base key exists in foreign records',
        fkName: "fk1",
        inBaseSchema: defaultBaseSchema.copyWith(
          foreignKey: {
            "fk1": ForeignKey(
              ["c1", "c2"],
              ForeignKeyReference("data.csv", ["f2", "f1"]),
            ),
          },
        ),
        inBaseCSV: baseCsvData(["a", "b", "c"]),
        inForeignSchema: defaultForeignSchema.copyWith(
          uniqueKey: {
            "uk1": ["f2", "f1"],
          },
        ),
        inForeignCSV: foreignCsvData(["b", "a", "c"]),
        want: [],
      ),
      (
        message:
            'should detects no error if base key does not exist in foreign records',
        fkName: "fk1",
        inBaseSchema: defaultBaseSchema.copyWith(
          foreignKey: {
            "fk1": ForeignKey(
              ["c1", "c2"],
              ForeignKeyReference("data.csv", ["f2", "f1"]),
            ),
          },
        ),
        inBaseCSV: baseCsvData(["a", "b", "c"]),
        inForeignSchema: defaultForeignSchema.copyWith(
          uniqueKey: {
            "uk1": ["f2", "f1"],
          },
        ),
        inForeignCSV: foreignCsvData(["x", "y", "z"]),
        want: [
          ForeignKeyNotFound("fk1", 1, ["a", "b"])
        ],
      ),
    ];
    for (final testcase in testcases) {
      test(testcase.message, () {
        final got = validateForeignKey(
          testcase.fkName,
          testcase.inBaseSchema,
          testcase.inBaseCSV,
          testcase.inForeignSchema,
          testcase.inForeignCSV,
        );
        expect(got, equals(testcase.want));
      });
    }
  });
}
