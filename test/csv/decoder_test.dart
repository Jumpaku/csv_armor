import 'package:csv_armor/csv/decoder.dart';
import 'package:csv_armor/csv/field_quote.dart';
import 'package:csv_armor/csv/field_separator.dart';
import 'package:csv_armor/csv/record_separator.dart';
import 'package:test/test.dart';

typedef _Testcase = ({String input, List<List<String>> expected});

void main() {
  group('Decoder', () {
    const testcases = <_Testcase>[
      (
        input: "aaa,bbb,ccc\r\nzzz,yyy,xxx\r\n",
        expected: [
          ["aaa", "bbb", "ccc"],
          ["zzz", "yyy", "xxx"]
        ]
      ),
      (
        input: "aaa,bbb,ccc\r\nzzz,yyy,xxx",
        expected: [
          ["aaa", "bbb", "ccc"],
          ["zzz", "yyy", "xxx"]
        ]
      ),
      (
        input: "\"aaa\",\"bbb\",\"ccc\"\r\nzzz,yyy,xxx",
        expected: [
          ["aaa", "bbb", "ccc"],
          ["zzz", "yyy", "xxx"]
        ]
      ),
      (
        input: "\"aaa\",\"b\r\nbb\",\"ccc\"\r\nzzz,yyy,xxx",
        expected: [
          ["aaa", "b\r\nbb", "ccc"],
          ["zzz", "yyy", "xxx"]
        ]
      ),
      (
        input: "\"aaa\",\"b\"\"bb\",\"ccc\"",
        expected: [
          ["aaa", "b\"bb", "ccc"]
        ]
      ),
      (
        input: "\"aaa\",\"b,bb\",\"ccc\"",
        expected: [
          ["aaa", "b,bb", "ccc"]
        ]
      ),
    ];

    final sut = Decoder(
      fieldQuote: FieldQuote.DQUOTE,
      fieldSeparator: FieldSeparator.COMMA,
      recordSeparator: RecordSeparator.CRLF,
      escapedQuote: '""',
    );

    for (var (i, testcase) in testcases.indexed) {
      test('testcase-$i', () {
        final actual = sut.decode(testcase.input);
        expect(actual, equals(testcase.expected));
      });
    }
  });

  group("Decoder disallow quoted field", () {
    const testcases = <_Testcase>[
      (
        input: "aaa,bbb,ccc\r\nzzz,yyy,xxx\r\n",
        expected: [
          ["aaa", "bbb", "ccc"],
          ["zzz", "yyy", "xxx"]
        ]
      ),
      (
        input: "aaa,bbb,ccc\r\nzzz,yyy,xxx",
        expected: [
          ["aaa", "bbb", "ccc"],
          ["zzz", "yyy", "xxx"]
        ]
      ),
      (
        input: "\"aaa\",\"bbb\",\"ccc\"\r\nzzz,yyy,xxx",
        expected: [
          ['"aaa"', '"bbb"', '"ccc"'],
          ["zzz", "yyy", "xxx"]
        ]
      ),
      (
        input: "\"aaa\",\"b\r\nbb\",\"ccc\"\r\nzzz,yyy,xxx",
        expected: [
          ['"aaa"', '"b'],
          ['bb"', '"ccc"'],
          ["zzz", "yyy", "xxx"]
        ]
      ),
      (
        input: "\"aaa\",\"b\"\"bb\",\"ccc\"",
        expected: [
          ['"aaa"', '"b""bb"', '"ccc"']
        ]
      ),
      (
        input: "\"aaa\",\"b,bb\",\"ccc\"",
        expected: [
          ['"aaa"', '"b', 'bb"', '"ccc"']
        ]
      ),
    ];

    final sut = Decoder(
      fieldQuote: FieldQuote.NONE,
      fieldSeparator: FieldSeparator.COMMA,
      recordSeparator: RecordSeparator.CRLF,
    );

    for (var (i, testcase) in testcases.indexed) {
      test('testcase-$i', () {
        final actual = sut.decode(testcase.input);
        expect(actual, equals(testcase.expected));
      });
    }
  });
}
