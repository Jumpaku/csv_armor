class DecodeException implements Exception {
  static const codeInvalidCharAfterField = "invalid_char_after_field";
  static const codeOpeningQuoteNotFound = "opening_quote_not_found";
  static const codeClosingQuoteNotFound = "closing_quote_not_found";

  DecodeException(this.message, this.code, this.input, this.cursor,
      {this.cause});

  final String message;
  final String code;
  final int cursor;
  final List<String> input;
  final Object? cause;
}
