import 'package:characters/characters.dart';
import 'package:csv_armor/csv/encoder_config.dart';
import 'package:csv_armor/csv/error.dart';
import 'package:csv_armor/csv/record_separator.dart';

class Encoder {
  Encoder(EncoderConfig config) {
    _recordSeparator = config.recordSeparator;
    _terminatesWithRecordSeparator = config.terminatesWithRecordSeparator;
    _fieldSeparator = Characters(config.fieldSeparator).toList();
    final fieldQuoteLeft =
        config.fieldQuote?.leftQuote ?? config.fieldQuote?.quote;
    final fieldQuoteRight =
        config.fieldQuote?.rightQuote ?? config.fieldQuote?.quote;
    _fieldQuoteLeft =
        fieldQuoteLeft == null ? null : Characters(fieldQuoteLeft).toList();
    _fieldQuoteRight =
        fieldQuoteRight == null ? null : Characters(fieldQuoteRight).toList();
    final fieldQuoteEscapeLeft =
        config.fieldQuote?.leftQuoteEscape ?? config.fieldQuote?.quoteEscape;
    final fieldQuoteEscapeRight =
        config.fieldQuote?.rightQuoteEscape ?? config.fieldQuote?.quoteEscape;
    _fieldQuoteEscapeLeft = fieldQuoteEscapeLeft == null
        ? null
        : Characters(fieldQuoteEscapeLeft).toList();
    _fieldQuoteEscapeRight = fieldQuoteEscapeRight == null
        ? null
        : Characters(fieldQuoteEscapeRight).toList();
    _quoteAlways = config.fieldQuote?.always ?? false;
  }

  late final RecordSeparator _recordSeparator;
  late final bool _terminatesWithRecordSeparator;
  late final List<String> _fieldSeparator;
  late final List<String>? _fieldQuoteLeft;
  late final List<String>? _fieldQuoteRight;
  late final List<String>? _fieldQuoteEscapeLeft;
  late final List<String>? _fieldQuoteEscapeRight;
  late final bool _quoteAlways;

  String encode(List<List<String>> records) {
    return records.indexed.map((r) {
          final (row, record) = r;
          final escapedRecord = record.indexed.map((f) {
            final (column, field) = f;
            final quote = _quoteAlways ||
                (field.contains(_fieldSeparator.join())) ||
                (_fieldQuoteLeft != null &&
                    field.contains(_fieldQuoteLeft.join())) ||
                (_fieldQuoteRight != null &&
                    field.contains(_fieldQuoteRight.join())) ||
                (field.contains(_fieldSeparator.join())) ||
                field.contains(_recordSeparator.value());
            if (!quote) {
              return field;
            }

            if (_fieldQuoteLeft == null || _fieldQuoteRight == null) {
              throw EncodeException(
                "field quote is required but not configured",
                encodeErrorFieldQuoteRequired,
                row,
                column,
                field,
              );
            }
            final quoteL = _fieldQuoteLeft.join();
            final quoteR = _fieldQuoteRight.join();
            if ((field.contains(quoteL) && _fieldQuoteEscapeLeft == null) ||
                (field.contains(quoteR) && _fieldQuoteEscapeRight == null)) {
              throw EncodeException(
                "field quote escape is required but not configured",
                encodeErrorFieldQuoteEscapeRequired,
                row,
                column,
                field,
              );
            }
            final escaped = quoteL == quoteR
                ? field.replaceAll(quoteL, _fieldQuoteEscapeLeft!.join())
                : field
                    .replaceAll(quoteL, _fieldQuoteEscapeLeft!.join())
                    .replaceAll(quoteR, _fieldQuoteEscapeRight!.join());
            return "$quoteL$escaped$quoteR";
          });
          return escapedRecord.join(_fieldSeparator.join());
        }).join(_recordSeparator.value()) +
        (_terminatesWithRecordSeparator ? _recordSeparator.value() : "");
  }
}
