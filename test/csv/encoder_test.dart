import 'package:csv_armor/csv/encoder.dart';
import 'package:csv_armor/csv/field_quote.dart';
import 'package:csv_armor/csv/field_separator.dart';
import 'package:csv_armor/csv/record_separator.dart';
import 'package:test/test.dart';

typedef _Testcase = ({
  List<List<String>> input,
  String expected,
});

void main() {
  group('Encoder', () {
    const testcases = <_Testcase>[
      (
        input: [
          ["aaa", "bbb", "ccc"],
          ["zzz", "yyy", "xxx"]
        ],
        expected: "aaa,bbb,ccc\r\nzzz,yyy,xxx\r\n",
      ),
      (
        input: [
          ["aaa", "b\r\nbb", "ccc"],
          ["zzz", "yyy", "xxx"]
        ],
        expected: "aaa,\"b\r\nbb\",ccc\r\nzzz,yyy,xxx\r\n",
      ),
      (
        input: [
          ["aaa", "b\"bb", "ccc"]
        ],
        expected: "aaa,\"b\"\"bb\",ccc\r\n",
      ),
      (
        input: [
          ["aaa", "b,bb", "ccc"]
        ],
        expected: "aaa,\"b,bb\",ccc\r\n",
      ),
    ];

    final sut = Encoder(
      fieldQuote: FieldQuote.DQUOTE,
      fieldSeparator: FieldSeparator.COMMA,
      recordSeparator: RecordSeparator.CRLF,
      forceQuote: false,
      terminatesWithRecordSeparator: true,
    );

    for (final (i, testcase) in testcases.indexed) {
      test('testcase-$i', () {
        final actual = sut.encode(testcase.input);
        expect(actual, equals(testcase.expected));
      });
    }
  });
}
