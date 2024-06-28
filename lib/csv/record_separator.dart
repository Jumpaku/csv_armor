enum RecordSeparator {
  ANY,
  CRLF,
  LF,
  CR;

  String value() => switch (this) {
        RecordSeparator.CRLF => "\r\n",
        RecordSeparator.LF => "\n",
        RecordSeparator.CR => "\r",
        RecordSeparator.ANY => throw AssertionError("unsupported value"),
      };
}
