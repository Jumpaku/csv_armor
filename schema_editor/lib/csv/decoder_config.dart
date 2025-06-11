class DecoderConfig {
  static const fieldSeparatorComma = ',';
  static const fieldSeparatorTab = '\t';
  static const fieldQuoteDouble = '"';
  static const fieldQuoteEscapeDouble = '""';
  static const fieldQuoteEmpty = '';
  static const fieldQuoteEscapeEmpty = '';

  DecoderConfig({
    required this.headerLines,
    this.recordSeparator = RecordSeparator.crlf,
    this.fieldSeparator = fieldSeparatorComma,
    DecoderConfigQuote? fieldQuote,
  }) {
    this.fieldQuote = fieldQuote ?? DecoderConfigQuote.double();
  }

  final int headerLines;
  final RecordSeparator recordSeparator;
  final String fieldSeparator;
  late final DecoderConfigQuote fieldQuote;
}

class DecoderConfigQuote {
  factory DecoderConfigQuote.double() {
    return DecoderConfigQuote.of(
      quote: DecoderConfig.fieldQuoteDouble,
      quoteEscape: DecoderConfig.fieldQuoteEscapeDouble,
    );
  }

  factory DecoderConfigQuote.none() {
    return DecoderConfigQuote.of(
      quote: DecoderConfig.fieldQuoteEmpty,
      quoteEscape: DecoderConfig.fieldQuoteEscapeEmpty,
    );
  }

  factory DecoderConfigQuote.of(
      {required String quote, required String quoteEscape}) {
    return DecoderConfigQuote(
      leftQuote: quote,
      leftQuoteEscape: quoteEscape,
      rightQuote: quote,
      rightQuoteEscape: quoteEscape,
    );
  }

  DecoderConfigQuote({
    required this.leftQuote,
    required this.leftQuoteEscape,
    required this.rightQuote,
    required this.rightQuoteEscape,
  }) {
    if (leftQuote.isEmpty != rightQuote.isEmpty) {
      throw ArgumentError(
          "leftQuote and rightQuote must be both empty or non-empty");
    }
    if (leftQuote.isEmpty && rightQuote.isEmpty) {
      if (leftQuoteEscape.isNotEmpty || rightQuoteEscape.isNotEmpty) {
        throw ArgumentError(
            "leftQuoteEscape and rightQuoteEscape must be empty if leftQuote and rightQuote are empty");
      }
    }
  }

  final String leftQuote;
  final String leftQuoteEscape;
  final String rightQuote;
  final String rightQuoteEscape;
}

enum RecordSeparator {
  any,
  crlf,
  lf,
  cr;

  String value() => switch (this) {
        RecordSeparator.crlf => "\r\n",
        RecordSeparator.lf => "\n",
        RecordSeparator.cr => "\r",
        RecordSeparator.any => throw AssertionError("unsupported value"),
      };
}
