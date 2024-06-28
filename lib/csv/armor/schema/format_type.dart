enum FormatType {
  datetime,
  integer,
  decimal,
  text,
  boolean;

  RegExp regex() => switch (this) {
        FormatType.datetime => RegExp(
            r"^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}([.,]\d+)?(Z|[+-]\d{2}:\d{2})$"),
        FormatType.integer =>
          RegExp(r"^[+-]?(\d+|0x[0-9a-fA-F]+|0b[01]+|0o[0-7]+)$"),
        FormatType.decimal => RegExp(r"^[+-]?\d+([.,]\d+)?$"),
        FormatType.text => RegExp(r"^.*$"),
        FormatType.boolean =>
          RegExp(r"^([Tt]rue|[Ff]alse|TRUE|FALSE|[TFtf10])$"),
      };
}
