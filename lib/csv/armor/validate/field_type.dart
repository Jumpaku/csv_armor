enum FieldType {
  text,
  integer,
  boolean,
  datetime,
  decimal,
  ;

  RegExp regex() => switch (this) {
        FieldType.text => RegExp(r"^.*$"),
        FieldType.integer => RegExp(
            r"^[+-]?(\d+([_']\d+)*|0x[0-9a-fA-F]+([_'][0-9a-fA-F]+)*|0b[01]+([_'][01]+)*|0o[0-7]+([_'][0-7]+)*)$"),
        FieldType.boolean =>
          RegExp(r"^([Tt]rue|[Ff]alse|TRUE|FALSE|[TFtf10])$"),
        FieldType.datetime => RegExp(
            r"^-?(\d{4,}-\d{2}-\d{2}|\d{4,}-\d{3}|\d{4,}-W\d{2}-[1-7])T\d{2}:\d{2}:\d{2}([.,]\d+)?(Z|[+-]\d{2}:\d{2})$"),
        FieldType.decimal =>
          RegExp(r"^[+-]?\d+([_']\d+)*([.,]\d+([_']\d+)*)?$"),
      };
}
