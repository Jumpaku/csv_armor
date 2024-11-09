import 'package:csv_armor/csv/decoder.dart';
import 'package:csv_armor/csv/decoder_config.dart';
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

    final sut = Decoder(const DecoderConfig(
      fieldSeparator: ",",
      recordSeparator: RecordSeparator.CRLF,
      fieldQuote: const DecoderConfigQuote(
        quote: '"',
        quoteEscape: '""',
      ),
    ));

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

    final sut = Decoder(const DecoderConfig(
      fieldSeparator: ",",
      recordSeparator: RecordSeparator.CRLF,
      fieldQuote: null,
    ));

    for (var (i, testcase) in testcases.indexed) {
      test('testcase-$i', () {
        final actual = sut.decode(testcase.input);
        expect(actual, equals(testcase.expected));
      });
    }
  });

  group('Custom Decoder', () {
    const testcases = <_Testcase>[
      (
        input: "aaa<sep/>bbb<sep/>ccc\r\nzzz<sep/>yyy<sep/>xxx\r\n",
        expected: [
          ["aaa", "bbb", "ccc"],
          ["zzz", "yyy", "xxx"]
        ]
      ),
      (
        input: "aaa<sep/>bbb<sep/>ccc\r\nzzz<sep/>yyy<sep/>xxx",
        expected: [
          ["aaa", "bbb", "ccc"],
          ["zzz", "yyy", "xxx"]
        ]
      ),
      (
        input:
            "<field>aaa</field><sep/><field>bbb</field><sep/><field>ccc</field>\r\nzzz<sep/>yyy<sep/>xxx",
        expected: [
          ["aaa", "bbb", "ccc"],
          ["zzz", "yyy", "xxx"]
        ]
      ),
      (
        input:
            "<field>aaa</field><sep/><field>b\r\nbb</field><sep/><field>ccc</field>\r\nzzz<sep/>yyy<sep/>xxx",
        expected: [
          ["aaa", "b\r\nbb", "ccc"],
          ["zzz", "yyy", "xxx"]
        ]
      ),
      (
        input:
            "<field>aaa</field><sep/><field>b&lt;field&gt;bb</field><sep/><field>ccc</field>",
        expected: [
          ["aaa", "b<field>bb", "ccc"]
        ]
      ),
      (
      input:
      "<field>aaa</field><sep/><field>b&lt;/field&gt;bb</field><sep/><field>ccc</field>",
      expected: [
        ["aaa", "b</field>bb", "ccc"]
      ]
      ),
      (
        input:
            "<field>aaa</field><sep/><field>b<sep/>bb</field><sep/><field>ccc</field>",
        expected: [
          ["aaa", "b<sep/>bb", "ccc"]
        ]
      ),
    ];

    final sut = Decoder(const DecoderConfig(
      fieldSeparator: "<sep/>",
      recordSeparator: RecordSeparator.ANY,
      fieldQuote: const DecoderConfigQuote(
        leftQuote: '<field>',
        rightQuote: '</field>',
        leftQuoteEscape: '&lt;field&gt;',
        rightQuoteEscape: '&lt;/field&gt;',
      ),
    ));

    for (var (i, testcase) in testcases.indexed) {
      test('testcase-$i', () {
        final actual = sut.decode(testcase.input);
        expect(actual, equals(testcase.expected));
      });
    }
  });
}
