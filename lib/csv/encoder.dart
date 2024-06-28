import 'package:csv_armor/csv/error.dart';
import 'package:csv_armor/csv/field_quote.dart';
import 'package:csv_armor/csv/field_separator.dart';
import 'package:csv_armor/csv/record_separator.dart';
import 'package:csv_armor/src/require.dart';

class Encoder {
  Encoder(
      {this.recordSeparator = RecordSeparator.CRLF,
      this.fieldSeparator = FieldSeparator.COMMA,
      this.fieldQuote = FieldQuote.DQUOTE,
      this.forceQuote = false,
      this.forceUnquote = false,
      this.terminatesWithRecordSeparator = true}) {
    require(!forceQuote || !forceUnquote, ["forceQuote", "forceUnquote"],
        "forceQuote and forceUnquote cannot be both true");
  }

  final RecordSeparator recordSeparator;
  final FieldSeparator fieldSeparator;
  final FieldQuote fieldQuote;
  final bool forceQuote;
  final bool forceUnquote;
  final bool terminatesWithRecordSeparator;

  String encode(List<List<String>> records) {
    return records.indexed.map((r) {
          final (row, record) = r;
          final escapedRecord = record.indexed.map((f) {
            final (column, field) = f;
            final quote = forceQuote ||
                field.contains(fieldQuote.value()) ||
                field.contains(fieldSeparator.value()) ||
                field.contains(recordSeparator.value());
            if (quote && forceUnquote) {
              throw EncodeException(
                  "field quote required but forceUnquote is true",
                  encodeErrorFieldQuoteRequired,
                  row,
                  column,
                  field);
            }
            final escapedQuote = fieldQuote.value() + fieldQuote.value();
            return quote
                ? "${fieldQuote.value()}${field.replaceAll(fieldQuote.value(), escapedQuote)}${fieldQuote.value()}"
                : field;
          });
          return escapedRecord.join(fieldSeparator.value());
        }).join(recordSeparator.value()) +
        (terminatesWithRecordSeparator ? recordSeparator.value() : "");
  }
}
