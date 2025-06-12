class DecodeException implements Exception {
  static const codeInvalidCharAfterField = "invalid_char_after_field";
  static const codeOpeningQuoteNotFound = "opening_quote_not_found";
  static const codeClosingQuoteNotFound = "closing_quote_not_found";
  static const codeTooFewHeaderLines = "too_few_header_lines";

  DecodeException(this.message, this.code, this.input, this.cursor,
      {this.cause});

  final String message;
  final String code;
  final int cursor;
  final List<String> input;
  final Object? cause;

  @override
  String toString() {
    List<List<String>> lines = [[]];
    int line = 0;
    int column = 1;
    for (final (index, char) in input.indexed) {
      lines.last.add(char);
      if (index == cursor) {
        line = lines.length - 1;
        column = lines.last.length - 1;
        break;
      }
      if (char == "\n" || char == "\r" || char == "\r\n") {
        lines.add([]);
      }
    }

    return '$message: line=$line column=$column ${cause == null ? "" : ": caused by $cause"}';
  }
}
