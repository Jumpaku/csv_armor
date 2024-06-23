import 'package:csv_armor/csv/error.dart';

class Encoder {
  Encoder(
      {this.recordSeparator = "\r\n",
      this.fieldSeparator = ",",
      this.fieldQuote = '"',
      this.escapedQuote = '""',
      this.forceQuote = false,
      this.forceUnquote = false,
      this.terminatesWithRecordSeparator = true}) {
    if (forceQuote && forceUnquote) {
      throw ArgumentError("forceQuote and forceUnquote cannot be both true");
    }
  }

  final String recordSeparator;
  final String fieldSeparator;
  final String fieldQuote;
  final String escapedQuote;
  final bool forceQuote;
  final bool forceUnquote;
  final bool terminatesWithRecordSeparator;

  String encode(List<List<String>> records) {
    return records.indexed.map((r) {
          final (row, record) = r;
          final escapedRecord = record.indexed.map((f) {
            final (column, field) = f;
            final quote = forceQuote ||
                field.contains(fieldQuote) ||
                field.contains(fieldSeparator) ||
                field.contains(recordSeparator);
            if (quote && forceUnquote) {
              throw EncodeException(
                  "field quote required but forceUnquote is true",
                  encodeErrorFieldQuoteRequired,
                  row,
                  column,
                  field);
            }
            return quote
                ? "$fieldQuote${field.replaceAll(fieldQuote, escapedQuote)}$fieldQuote"
                : field;
          });
          return escapedRecord.join(fieldSeparator);
        }).join(recordSeparator) +
        (terminatesWithRecordSeparator ? recordSeparator : "");
  }
}
