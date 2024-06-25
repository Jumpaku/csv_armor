import 'package:csv_armor/csv/store/store.dart';
import 'package:test/test.dart';

typedef _TestcaseCtor = ({
  String message,
  List<String> inColumns,
  List<int> inPrimaryKeyIndex,
  List<List<String>> inData,
});

typedef _Testcase_listRecord = ({
  String message,
  Store sut,
  List<List<String>> want,
});

typedef _Testcase_findRecord = ({
  String message,
  Store sut,
  PrimaryKey inPrimaryKey,
  List<String>? want,
});

typedef _Testcase_upsertRecord = ({
  String message,
  Store sut,
  List<String> inRecord,
  List<List<String>> want,
});

typedef _Testcase_deleteRecord = ({
  String message,
  Store sut,
  PrimaryKey inPrimaryKey,
  List<List<String>> want,
});

typedef _Testcase_reorderColumns = ({
  String message,
  Store sut,
  List<String> inReorderedColumns,
  List<List<String>> wantRecords,
  List<String> wantColumns,
  PrimaryKey wantPrimaryKey,
});

typedef _Testcase_updateColumn = ({
  String message,
  Store sut,
  String inNameBefore,
  String inNameAfter,
  List<List<String>> wantRecords,
  List<String> wantColumns,
  PrimaryKey wantPrimaryKey,
});

typedef _Testcase_insertColumn = ({
  String message,
  Store sut,
  String inName,
  List<List<String>> wantRecords,
  List<String> wantColumns,
  PrimaryKey wantPrimaryKey,
});

typedef _Testcase_deleteColumn = ({
  String message,
  Store sut,
  String inName,
  List<List<String>> wantRecords,
  List<String> wantColumns,
  PrimaryKey wantPrimaryKey,
});

void main() {
  group('Store', () {
    group('Store constructor', () {
      final testcases = <_TestcaseCtor>[
        (
          message: "should error with a duplicated column names",
          inColumns: ["a", "b", "a", "d"],
          inPrimaryKeyIndex: [2, 0],
          inData: [
            ["1", "2", "3", "4"],
            ["5", "6", "7", "8"],
          ],
        ),
        (
          message: "should error with a empty column names",
          inColumns: [],
          inPrimaryKeyIndex: [],
          inData: [],
        ),
        (
          message: "should error with a empty primary key index",
          inColumns: ["a", "b", "c", "d"],
          inPrimaryKeyIndex: [],
          inData: [],
        ),
        (
          message: "should error with a primary key index out of range",
          inColumns: ["a", "b", "c", "d"],
          inPrimaryKeyIndex: [2, 4],
          inData: [
            ["1", "2", "3", "4"],
            ["5", "6", "7", "8"],
          ],
        ),
        (
          message: "should error with a duplicated primary key index",
          inColumns: ["a", "b", "c", "d"],
          inPrimaryKeyIndex: [2, 2],
          inData: [
            ["1", "2", "3", "4"],
            ["5", "6", "7", "8"],
          ],
        ),
        (
          message:
              "should error with a data row length not equal to columns length",
          inColumns: ["a", "b", "c", "d"],
          inPrimaryKeyIndex: [2, 0],
          inData: [
            ["1", "2", "3", "4"],
            ["5", "6", "7"],
          ],
        ),
        (
          message:
              "should error with a data row length not equal to columns length",
          inColumns: ["a", "b", "c", "d"],
          inPrimaryKeyIndex: [2, 0],
          inData: [
            ["1", "2", "3", "4"],
            ["5", "6", "7", "8", "9"],
          ],
        ),
        (
          message: "should error with a duplicated primary key",
          inColumns: ["a", "b", "c", "d"],
          inPrimaryKeyIndex: [2, 0],
          inData: [
            ["1", "2", "3", "4"],
            ["1", "6", "3", "8"],
          ],
        ),
      ];

      for (final testcase in testcases) {
        test(testcase.message, () {
          expect(
              () => Store(
                    testcase.inColumns,
                    testcase.inPrimaryKeyIndex,
                    data: testcase.inData,
                  ),
              throwsArgumentError);
        });
      }
    });
  });

  group('Store listRecords', () {
    final testcases = <_Testcase_listRecord>[
      (
        message: "should return all records",
        sut: Store(
          ["a", "b", "c", "d"],
          [2, 0],
          data: [
            ["e", "f", "g", "h"],
            ["a", "b", "c", "d"],
            ["m", "n", "o", "p"],
            ["i", "j", "k", "l"],
          ],
        ),
        want: [
          ["a", "b", "c", "d"],
          ["e", "f", "g", "h"],
          ["i", "j", "k", "l"],
          ["m", "n", "o", "p"],
        ],
      ),
    ];

    for (final testcase in testcases) {
      test(testcase.message, () {
        expect(testcase.sut.listRecords(), equals(testcase.want));
      });
    }
  });

  group('Store properties', () {
    final sut = Store(
      ["c", "a", "b", "d"],
      [2, 0],
      data: [
        ["e", "f", "g", "h"],
        ["a", "b", "c", "d"],
        ["m", "n", "o", "p"],
        ["i", "j", "k", "l"],
      ],
    );
    test('columns', () {
      expect(sut.columns, equals(["c", "a", "b", "d"]));
    });
    test('primaryKey', () {
      expect(sut.primaryKey, equals(PrimaryKey(["b", "c"])));
    });
  });

  group('Store findRecord', () {
    final testcases = <_Testcase_findRecord>[
      (
        message: "should return a specified record",
        sut: Store(
          ["a", "b", "c", "d"],
          [2, 0],
          data: [
            ["e", "f", "g", "h"],
            ["a", "b", "c", "d"],
            ["m", "n", "o", "p"],
          ],
        ),
        inPrimaryKey: PrimaryKey(["c", "a"]),
        want: ["a", "b", "c", "d"],
      ),
      (
        message: "should return null if not found",
        sut: Store(
          ["a", "b", "c", "d"],
          [2, 0],
          data: [
            ["e", "f", "g", "h"],
            ["a", "b", "c", "d"],
            ["m", "n", "o", "p"],
          ],
        ),
        inPrimaryKey: PrimaryKey(["z", "x"]),
        want: null,
      ),
    ];

    for (final testcase in testcases) {
      test(testcase.message, () {
        expect(testcase.sut.findRecord(testcase.inPrimaryKey),
            equals(testcase.want));
      });
    }
  });

  group('Store upsertRecord', () {
    final testcases = <_Testcase_upsertRecord>[
      (
        message: "should insert a new record",
        sut: Store(
          ["a", "b", "c", "d"],
          [2, 0],
          data: [
            ["e", "f", "g", "h"],
            ["a", "b", "c", "d"],
            ["m", "n", "o", "p"],
          ],
        ),
        inRecord: ["x", "y", "z", "w"],
        want: [
          ["a", "b", "c", "d"],
          ["e", "f", "g", "h"],
          ["m", "n", "o", "p"],
          ["x", "y", "z", "w"],
        ],
      ),
      (
        message: "should update an existing record",
        sut: Store(
          ["a", "b", "c", "d"],
          [2, 0],
          data: [
            ["e", "f", "g", "h"],
            ["a", "b", "c", "d"],
            ["m", "n", "o", "p"],
          ],
        ),
        inRecord: ["a", "y", "c", "w"],
        want: [
          ["a", "y", "c", "w"],
          ["e", "f", "g", "h"],
          ["m", "n", "o", "p"],
        ],
      ),
    ];

    for (final testcase in testcases) {
      test(testcase.message, () {
        testcase.sut.upsertRecord(testcase.inRecord);
        expect(testcase.sut.listRecords(), equals(testcase.want));
      });
    }
  });

  group('Store deleteRecord', () {
    final testcases = <_Testcase_deleteRecord>[
      (
        message: "should delete a specified record",
        sut: Store(
          ["a", "b", "c", "d"],
          [2, 0],
          data: [
            ["e", "f", "g", "h"],
            ["a", "b", "c", "d"],
            ["m", "n", "o", "p"],
          ],
        ),
        inPrimaryKey: PrimaryKey(["c", "a"]),
        want: [
          ["e", "f", "g", "h"],
          ["m", "n", "o", "p"],
        ],
      ),
      (
        message: "should delete no existing record if not found",
        sut: Store(
          ["a", "b", "c", "d"],
          [2, 0],
          data: [
            ["e", "f", "g", "h"],
            ["a", "b", "c", "d"],
            ["m", "n", "o", "p"],
          ],
        ),
        inPrimaryKey: PrimaryKey(["z", "x"]),
        want: [
          ["a", "b", "c", "d"],
          ["e", "f", "g", "h"],
          ["m", "n", "o", "p"],
        ],
      ),
    ];

    for (final testcase in testcases) {
      test(testcase.message, () {
        testcase.sut.deleteRecord(testcase.inPrimaryKey);
        expect(testcase.sut.listRecords(), equals(testcase.want));
      });
    }
  });

  group('Store reorderColumns', () {
    final testcases = <_Testcase_reorderColumns>[
      (
        message: "should reorder columns",
        sut: Store(
          ["a", "b", "c", "d"],
          [2, 0],
          data: [
            ["e", "f", "g", "h"],
            ["a", "b", "c", "d"],
            ["m", "n", "o", "p"],
          ],
        ),
        inReorderedColumns: ["d", "c", "b", "a"],
        wantRecords: [
          ["d", "c", "b", "a"],
          ["h", "g", "f", "e"],
          ["p", "o", "n", "m"],
        ],
        wantColumns: ["d", "c", "b", "a"],
        wantPrimaryKey: PrimaryKey(["c", "a"]),
      ),
    ];

    for (final testcase in testcases) {
      test(testcase.message, () {
        testcase.sut.reorderColumns(testcase.inReorderedColumns);
        expect(testcase.sut.listRecords(), equals(testcase.wantRecords));
        expect(testcase.sut.columns, equals(testcase.wantColumns));
        expect(testcase.sut.primaryKey, equals(testcase.wantPrimaryKey));
      });
    }
  });

  group('Store updateColumn', () {
    final testcases = <_Testcase_updateColumn>[
      (
        message: "should update a primary key column",
        sut: Store(
          ["a", "b", "c", "d"],
          [2, 0],
          data: [
            ["e", "f", "g", "h"],
            ["a", "b", "c", "d"],
            ["m", "n", "o", "p"],
          ],
        ),
        inNameBefore: "a",
        inNameAfter: "x",
        wantRecords: [
          ["a", "b", "c", "d"],
          ["e", "f", "g", "h"],
          ["m", "n", "o", "p"],
        ],
        wantColumns: ["x", "b", "c", "d"],
        wantPrimaryKey: PrimaryKey(["c", "x"]),
      ),
      (
        message: "should update a non primary key column",
        sut: Store(
          ["a", "b", "c", "d"],
          [2, 0],
          data: [
            ["e", "f", "g", "h"],
            ["a", "b", "c", "d"],
            ["m", "n", "o", "p"],
          ],
        ),
        inNameBefore: "b",
        inNameAfter: "x",
        wantRecords: [
          ["a", "b", "c", "d"],
          ["e", "f", "g", "h"],
          ["m", "n", "o", "p"],
        ],
        wantColumns: ["a", "x", "c", "d"],
        wantPrimaryKey: PrimaryKey(["c", "a"]),
      ),
      (
        message: "should update a primary key column as is",
        sut: Store(
          ["a", "b", "c", "d"],
          [2, 0],
          data: [
            ["e", "f", "g", "h"],
            ["a", "b", "c", "d"],
            ["m", "n", "o", "p"],
          ],
        ),
        inNameBefore: "a",
        inNameAfter: "a",
        wantRecords: [
          ["a", "b", "c", "d"],
          ["e", "f", "g", "h"],
          ["m", "n", "o", "p"],
        ],
        wantColumns: ["a", "b", "c", "d"],
        wantPrimaryKey: PrimaryKey(["c", "a"]),
      ),
      (
        message: "should update a non primary key column as is",
        sut: Store(
          ["a", "b", "c", "d"],
          [2, 0],
          data: [
            ["e", "f", "g", "h"],
            ["a", "b", "c", "d"],
            ["m", "n", "o", "p"],
          ],
        ),
        inNameBefore: "b",
        inNameAfter: "b",
        wantRecords: [
          ["a", "b", "c", "d"],
          ["e", "f", "g", "h"],
          ["m", "n", "o", "p"],
        ],
        wantColumns: ["a", "b", "c", "d"],
        wantPrimaryKey: PrimaryKey(["c", "a"]),
      ),
    ];

    for (final testcase in testcases) {
      test(testcase.message, () {
        testcase.sut.updateColumn(testcase.inNameBefore, testcase.inNameAfter);
        expect(testcase.sut.listRecords(), equals(testcase.wantRecords));
        expect(testcase.sut.columns, equals(testcase.wantColumns));
        expect(testcase.sut.primaryKey, equals(testcase.wantPrimaryKey));
      });
    }
  });

  group('Store insertColumn', () {
    final testcases = <_Testcase_insertColumn>[
      (
        message: "should insert a new column",
        sut: Store(
          ["a", "b", "c", "d"],
          [2, 0],
          data: [
            ["e", "f", "g", "h"],
            ["a", "b", "c", "d"],
            ["m", "n", "o", "p"],
          ],
        ),
        inName: "x",
        wantRecords: [
          ["a", "b", "c", "d", ""],
          ["e", "f", "g", "h", ""],
          ["m", "n", "o", "p", ""],
        ],
        wantColumns: ["a", "b", "c", "d", "x"],
        wantPrimaryKey: PrimaryKey(["c", "a"]),
      ),
    ];

    for (final testcase in testcases) {
      test(testcase.message, () {
        testcase.sut.insertColumn(testcase.inName);
        expect(testcase.sut.listRecords(), equals(testcase.wantRecords));
        expect(testcase.sut.columns, equals(testcase.wantColumns));
        expect(testcase.sut.primaryKey, equals(testcase.wantPrimaryKey));
      });
    }
  });

  group('Store deleteColumn', () {
    final testcases = <_Testcase_deleteColumn>[
      (
        message: "should delete an existing column",
        sut: Store(
          ["a", "b", "c", "d"],
          [2, 0],
          data: [
            ["e", "f", "g", "h"],
            ["a", "b", "c", "d"],
            ["m", "n", "o", "p"],
          ],
        ),
        inName: "b",
        wantRecords: [
          ["a", "c", "d"],
          ["e", "g", "h"],
          ["m", "o", "p"],
        ],
        wantColumns: ["a", "c", "d"],
        wantPrimaryKey: PrimaryKey(["c", "a"]),
      ),
    ];

    for (final testcase in testcases) {
      test(testcase.message, () {
        testcase.sut.deleteColumn(testcase.inName);
        expect(testcase.sut.listRecords(), equals(testcase.wantRecords));
        expect(testcase.sut.columns, equals(testcase.wantColumns));
        expect(testcase.sut.primaryKey, equals(testcase.wantPrimaryKey));
      });
    }
  });
}
