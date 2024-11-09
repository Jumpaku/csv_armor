import 'package:csv_armor/csv/encoder.dart';
import 'package:csv_armor/csv/encoder_config.dart';
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
        expected: "aaa,bbb,ccc\r\nzzz,yyy,xxx",
      ),
      (
        input: [
          ["aaa", "b\r\nbb", "ccc"],
          ["zzz", "yyy", "xxx"]
        ],
        expected: "aaa,\"b\r\nbb\",ccc\r\nzzz,yyy,xxx",
      ),
      (
        input: [
          ["aaa", "b\"bb", "ccc"]
        ],
        expected: "aaa,\"b\"\"bb\",ccc",
      ),
      (
        input: [
          ["aaa", "b,bb", "ccc"]
        ],
        expected: "aaa,\"b,bb\",ccc",
      ),
    ];

    final sut = Encoder(EncoderConfig(
        fieldSeparator: ",",
        recordSeparator: RecordSeparator.CRLF,
        terminatesWithRecordSeparator: false,
        fieldQuote: EncoderConfigQuote(
          quote: '"',
          quoteEscape: '""',
          always: false,
        )));

    for (final (i, testcase) in testcases.indexed) {
      test('testcase-$i', () {
        final actual = sut.encode(testcase.input);
        expect(actual, equals(testcase.expected));
      });
    }
  });

  group('Custom Encoder', () {
    const testcases = <_Testcase>[
      (
        input: [
          ["aaa", "bbb", "ccc"],
          ["zzz", "yyy", "xxx"]
        ],
        expected:
            "<field>aaa</field><sep/><field>bbb</field><sep/><field>ccc</field>\r\n<field>zzz</field><sep/><field>yyy</field><sep/><field>xxx</field>\r\n",
      ),
      (
        input: [
          ["aaa", "b\r\nbb", "ccc"],
          ["zzz", "yyy", "xxx"]
        ],
        expected:
            "<field>aaa</field><sep/><field>b\r\nbb</field><sep/><field>ccc</field>\r\n<field>zzz</field><sep/><field>yyy</field><sep/><field>xxx</field>\r\n",
      ),
      (
        input: [
          ["aaa", "b<field>bb", "ccc"]
        ],
        expected:
            "<field>aaa</field><sep/><field>b&lt;field&gt;bb</field><sep/><field>ccc</field>\r\n",
      ),
      (
        input: [
          ["aaa", "b</field>bb", "ccc"]
        ],
        expected:
            "<field>aaa</field><sep/><field>b&lt;/field&gt;bb</field><sep/><field>ccc</field>\r\n",
      ),
      (
        input: [
          ["aaa", "b<sep/>bb", "ccc"]
        ],
        expected:
            "<field>aaa</field><sep/><field>b<sep/>bb</field><sep/><field>ccc</field>\r\n",
      ),
    ];

    final sut = Encoder(EncoderConfig(
      fieldSeparator: "<sep/>",
      recordSeparator: RecordSeparator.CRLF,
      terminatesWithRecordSeparator: true,
      fieldQuote: const EncoderConfigQuote(
        leftQuote: '<field>',
        rightQuote: '</field>',
        leftQuoteEscape: '&lt;field&gt;',
        rightQuoteEscape: '&lt;/field&gt;',
        always: true,
      ),
    ));

    for (final (i, testcase) in testcases.indexed) {
      test('testcase-$i', () {
        final actual = sut.encode(testcase.input);
        expect(actual, equals(testcase.expected));
      });
    }
  });
}
