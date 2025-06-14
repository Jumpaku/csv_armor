import 'package:schema_editor/csv/decoder.dart';

class DecodeException implements Exception {
  static const codeInvalidCharAfterField = "invalid_char_after_field";
  static const codeOpeningQuoteNotFound = "opening_quote_not_found";
  static const codeClosingQuoteNotFound = "closing_quote_not_found";
  static const codeTooFewHeaderLines = "too_few_header_lines";

  DecodeException(this.message, this.code, this.input, this.position,
      {this.cause});

  final String message;
  final String code;
  final Position position;
  final List<String> input;
  final Object? cause;

  @override
  String toString() {
    return '$message: line=${position.line} column=${position.column}${cause == null ? "" : ": caused by $cause"}';
  }
}
