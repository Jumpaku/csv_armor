class DecoderConfig {
  static const fieldSeparatorComma = ',';
  static const fieldSeparatorTab = '\t';

  const DecoderConfig({
    this.recordSeparator = RecordSeparator.crlf,
    this.fieldSeparator = fieldSeparatorComma,
    this.fieldQuote = const DecoderConfigQuote(),
  });

  final RecordSeparator recordSeparator;
  final String fieldSeparator;
  final DecoderConfigQuote fieldQuote;
}

class DecoderConfigQuote {
  factory DecoderConfigQuote.of({
    String quote = '"',
    String quoteEscape = '""',
  }) {
    return DecoderConfigQuote(
      leftQuote: quote,
      leftQuoteEscape: quoteEscape,
      rightQuote: quote,
      rightQuoteEscape: quoteEscape,
    );
  }

  const DecoderConfigQuote({
    this.leftQuote = '"',
    this.leftQuoteEscape = '""',
    this.rightQuote = '"',
    this.rightQuoteEscape = '""',
  });

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
