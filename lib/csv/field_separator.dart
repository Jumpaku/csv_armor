enum FieldSeparator {
  COMMA,
  TAB,
  ;

  String value() => switch (this) {
        FieldSeparator.COMMA => ",",
        FieldSeparator.TAB => "\t",
      };
}
