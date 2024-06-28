enum FieldQuote {
  NONE,
  DQUOTE,
  SQUOTE;

  String value() => switch (this) {
        FieldQuote.DQUOTE => '"',
        FieldQuote.SQUOTE => "'",
        FieldQuote.NONE => "",
      };
}
