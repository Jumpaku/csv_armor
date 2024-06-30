import 'package:csv_armor/csv/armor/schema/error.dart';
import 'package:csv_armor/csv/armor/schema/schema.dart';
import 'package:test/test.dart';

typedef _TestcaseCtor = ({
  String message,
  Schema Function() ctor,
  String wantCode
});
typedef _TestcaseLoad = ({String message, String input, String wantCode});

void main() {
  group('Schema constructor', () {
    final testcases = <_TestcaseCtor>[
      (
        message: "Should throw with an empty columns",
        ctor: () => Schema("table.csv", [], ["id"]),
        wantCode: schemaErrorEmptyColumns,
      ),
      (
        message: "Should throw with an empty columns",
        ctor: () => Schema("table.csv", [Column("")], ["id"]),
        wantCode: schemaErrorEmptyColumnName,
      ),
      (
        message: "Should throw with an empty primary key columns",
        ctor: () => Schema("table.csv", [Column("id")], []),
        wantCode: schemaErrorEmptyPrimaryKeyColumn,
      ),
      (
        message: "Should throw with an primary key not in columns",
        ctor: () => Schema("table.csv", [Column("id")], ["invalid"]),
        wantCode: schemaErrorPrimaryKeyNotInColumns,
      ),
      (
        message: "Should throw with an empty unique key columns",
        ctor: () => Schema("table.csv", [Column("id")], ["id"],
            uniqueKey: {"unique": []}),
        wantCode: schemaErrorEmptyUniqueKeyColumn,
      ),
      (
        message: "Should throw with an unique key not in columns",
        ctor: () => Schema(
              "table.csv",
              [Column("id")],
              ["id"],
              uniqueKey: {
                "unique": ["invalid"],
              },
            ),
        wantCode: schemaErrorUniqueKeyNotInColumns,
      ),
      (
        message: "Should throw with an empty foreign key referencing columns",
        ctor: () => Schema(
              "table.csv",
              [Column("id")],
              ["id"],
              foreignKey: {
                "foreign": ForeignKey([], ForeignKeyReference("table", ["id"]))
              },
            ),
        wantCode: schemaErrorEmptyForeignKeyBaseColumn,
      ),
      (
        message:
            "Should throw with an foreign key referencing columns not in columns",
        ctor: () => Schema(
              "table.csv",
              [Column("id")],
              ["id"],
              foreignKey: {
                "foreign": ForeignKey(
                    ["invalid"], ForeignKeyReference("table", ["id"])),
              },
            ),
        wantCode: schemaErrorForeignKeyReferenceColumnNotInColumns,
      ),
      (
        message: "Should throw with an empty foreign key referenced columns",
        ctor: () => Schema(
              "table.csv",
              [Column("id")],
              ["id"],
              foreignKey: {
                "foreign": ForeignKey(["id"], ForeignKeyReference("table", []))
              },
            ),
        wantCode: schemaErrorForeignKeyColumnCountMismatch,
      ),
    ];

    for (var (i, testcase) in testcases.indexed) {
      test('testcase-$i: ${testcase.message}', () {
        expect(
          () => testcase.ctor(),
          allOf(
            throwsA(TypeMatcher<SchemaException>()),
            throwsA(predicate(
                (e) => (e as SchemaException).code == testcase.wantCode)),
          ),
          reason: testcase.message,
        );
      });
    }
  });

  group('Schema load', () {
    final testcases = <_TestcaseLoad>[
      (
        message: "Should throw with invalid yaml",
        input: r""":""",
        wantCode: schemaErrorYamlEncodeFailure,
      ),
      (
        message: "Should throw with invalid yaml",
        input: r"""][""",
        wantCode: schemaErrorYamlEncodeFailure,
      ),
      (
        message: "Should throw with invalid yaml",
        input: r"""'a""",
        wantCode: schemaErrorYamlEncodeFailure,
      ),
      (
        message: "Should throw with invalid yaml",
        input: r"""}""",
        wantCode: schemaErrorYamlEncodeFailure,
      ),
      (
        message: "Should throw without csv_path",
        input: '''
columns: [{name: id}]
primary_key: [id]''',
        wantCode: schemaErrorSchemaValidationFailure,
      ),
      (
        message: "Should throw without columns",
        input: '''
csv_path: table.csv
primary_key: [id]''',
        wantCode: schemaErrorSchemaValidationFailure,
      ),
      (
        message: "Should throw without primary_key",
        input: '''
csv_path: table.csv
columns: [{name: id}]''',
        wantCode: schemaErrorSchemaValidationFailure,
      ),
      (
        message: "Should throw without column name",
        input: '''
csv_path: table.csv
columns: [{}]
primary_key: [id]''',
        wantCode: schemaErrorSchemaValidationFailure,
      ),
      (
        message: "Should throw without foreign_key columns",
        input: '''
csv_path: table.csv
columns: [{name: id}]
primary_key: [id]
foreign_key: {foreign: {reference: {schema_path: schema.yaml, columns: [id]}}}''',
        wantCode: schemaErrorSchemaValidationFailure,
      ),
      (
        message: "Should throw without foreign_key reference",
        input: '''
csv_path: table.csv
columns: [{name: id}]
primary_key: [id]
foreign_key: {foreign: {columns: [id]}}''',
        wantCode: schemaErrorSchemaValidationFailure,
      ),
      (
        message: "Should throw without foreign_key reference schema_path",
        input: '''
csv_path: table.csv
columns: [{name: id}]
primary_key: [id]
foreign_key: {foreign: {columns: [id], reference: {columns: [id]}}}''',
        wantCode: schemaErrorSchemaValidationFailure,
      ),
      (
        message: "Should throw without foreign_key reference columns",
        input: '''
csv_path: table.csv
columns: [{name: id}]
primary_key: [id]
foreign_key: {foreign: {columns: [id], reference: {schema_path: schema.yaml}}}''',
        wantCode: schemaErrorSchemaValidationFailure,
      ),
      (
        message: "Should throw with invalid regex",
        input: '''
csv_path: table.csv
columns: [{name: id, regex: "("}]
primary_key: [id]''',
        wantCode: schemaErrorInvalidColumnFormatRegex,
      ),
    ];

    for (var (i, testcase) in testcases.indexed) {
      test('testcase-$i: ${testcase.message}', () {
        expect(
          () => Schema.load(testcase.input),
          allOf(
            throwsA(TypeMatcher<SchemaException>()),
            throwsA(predicate(
                (e) => (e as SchemaException).code == testcase.wantCode)),
          ),
          reason: testcase.message,
        );
      });
    }
  });
}
