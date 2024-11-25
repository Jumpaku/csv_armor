import 'package:csv_armor/csv/armor/schema/error.dart';
import 'package:csv_armor/csv/armor/schema/table_schema.dart';
import 'package:test/test.dart';

typedef _TestcaseCtor = ({
  String message,
  TableSchema Function() ctor,
  String wantCode
});
// typedef _TestcaseLoad = ({String message, String input, String wantCode});

void main() {
  group('Schema constructor', () {
    final testcases = <_TestcaseCtor>[
      (
        message: "Should throw with an empty columns",
        ctor: () => TableSchema(columns: [], primaryKey: ["id"]),
        wantCode: schemaErrorEmptyColumn,
      ),
      (
        message: "Should throw with an empty primary key columns",
        ctor: () => TableSchema(columns: [Column("id")], primaryKey: []),
        wantCode: schemaErrorEmptyPrimaryKey,
      ),
      (
        message: "Should throw with an primary key not in columns",
        ctor: () =>
            TableSchema(columns: [Column("id")], primaryKey: ["invalid"]),
        wantCode: schemaErrorPrimaryKeyNotInColumns,
      ),
      (
        message: "Should throw with an empty unique key columns",
        ctor: () => TableSchema(
            columns: [Column("id")],
            primaryKey: ["id"],
            uniqueKey: {"unique": []}),
        wantCode: schemaErrorEmptyUniqueKey,
      ),
      (
        message: "Should throw with an unique key not in columns",
        ctor: () => TableSchema(
              columns: [Column("id")],
              primaryKey: ["id"],
              uniqueKey: {
                "unique": ["invalid"],
              },
            ),
        wantCode: schemaErrorUniqueKeyNotInColumns,
      ),
      (
        message: "Should throw with an empty foreign key referencing columns",
        ctor: () => TableSchema(
              columns: [Column("id")],
              primaryKey: ["id"],
              foreignKey: {
                "foreign": ForeignKey([], ForeignKeyReference("table")),
              },
            ),
        wantCode: schemaErrorEmptyForeignKey,
      ),
      (
        message:
            "Should throw with an foreign key referencing columns not in columns",
        ctor: () => TableSchema(
              columns: [Column("id")],
              primaryKey: ["id"],
              foreignKey: {
                "foreign":
                    ForeignKey(["invalid"], ForeignKeyReference("table")),
              },
            ),
        wantCode: schemaErrorForeignKeyNotInColumns,
      ),
    ];

    for (final (i, testcase) in testcases.indexed) {
      test('testcase-$i: ${testcase.message}', () {
        expect(
          () => testcase.ctor(),
          allOf(
            throwsA(const TypeMatcher<SchemaException>()),
            throwsA(predicate(
                (e) => (e! as SchemaException).code == testcase.wantCode)),
          ),
          reason: testcase.message,
        );
      });
    }
  });
}
