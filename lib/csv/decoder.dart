import 'dart:math';

import 'package:characters/characters.dart';

import 'error.dart';

class ParseState {
  ParseState(this.input);

  final List<String> input;
  int cursor = 0;

  bool done() {
    return input.length <= cursor;
  }

  String peek(int size) {
    return input.sublist(cursor, min(input.length, cursor + size)).join();
  }

  void move(int count) {
    cursor += count;
  }

  Never fail(String message, String code) {
    throw DecodeException(message, code, input, cursor);
  }
}

enum FieldSeparator {
  COMMA,
  TAB,
  ;

  int matches(ParseState s) {
    final sep = switch (this) {
      FieldSeparator.COMMA => Characters(",").toList(),
      FieldSeparator.TAB => Characters("\t").toList(),
    };
    return s.peek(sep.length) == sep.join() ? sep.length : 0;
  }

  value() => switch (this) {
        FieldSeparator.COMMA => ",",
        FieldSeparator.TAB => "\t",
      };
}

enum FieldQuote {
  NONE,
  DQUOTE,
  SQUOTE;

  int matches(ParseState s) {
    final quote = switch (this) {
      FieldQuote.DQUOTE => Characters("\"").toList(),
      FieldQuote.SQUOTE => Characters("'").toList(),
      FieldQuote.NONE => [],
    };
    return s.peek(quote.length) == quote.join() ? quote.length : 0;
  }

  String value() => switch (this) {
        FieldQuote.DQUOTE => "\"",
        FieldQuote.SQUOTE => "'",
        FieldQuote.NONE => "",
      };
}

enum RecordSeparator {
  ANY,
  CRLF,
  LF,
  CR;

  int matches(ParseState s) {
    if (this == RecordSeparator.ANY) {
      for (final rSep in [CRLF, LF, CR]) {
        final m = rSep.matches(s);
        if (m > 0) {
          return m;
        }
        return 0;
      }
    }
    final quote = switch (this) {
      RecordSeparator.CRLF => Characters("\r\n").toList(),
      RecordSeparator.LF => Characters("\n").toList(),
      RecordSeparator.CR => Characters("\r").toList(),
      RecordSeparator.ANY => throw AssertionError("unreachable"),
    };
    return s.peek(quote.length) == quote.join() ? quote.length : 0;
  }

  value() => switch (this) {
        RecordSeparator.CRLF => "\r\n",
        RecordSeparator.LF => "\n",
        RecordSeparator.CR => "\r",
        RecordSeparator.ANY => throw AssertionError("unsupported value"),
      };
}

class Decoder {
  Decoder({
    this.recordSeparator = RecordSeparator.CRLF,
    this.fieldSeparator = FieldSeparator.COMMA,
    this.fieldQuote = FieldQuote.DQUOTE,
    escapedQuote = '""',
  }) : this.escapedQuote = Characters(escapedQuote).toList();

  final RecordSeparator recordSeparator;
  final FieldSeparator fieldSeparator;
  final FieldQuote fieldQuote;
  final List<String> escapedQuote;

  List<List<String>> parse(ParseState s) {
    List<List<String>> records = [];
    if (s.done()) {
      return [];
    }
    while (!s.done()) {
      final record = parseRecord(s);
      records.add(record);

      if (recordSeparator.matches(s) > 0) {
        s.move(recordSeparator.matches(s));
      }
    }
    return records;
  }

  List<String> parseRecord(ParseState s) {
    List<String> fields = [];
    while (!s.done()) {
      if (recordSeparator.matches(s) > 0) {
        break;
      }
      if (fieldSeparator.matches(s) > 0) {
        s.move(fieldSeparator.matches(s));
      }
      final field = parseField(s);
      fields.add(field);
    }
    return fields;
  }

  String parseField(ParseState s) {
    if (s.done()) {
      return "";
    }
    if (recordSeparator.matches(s) > 0) {
      return "";
    }
    if (fieldSeparator.matches(s) > 0) {
      return "";
    }

    final f = (fieldQuote.matches(s) > 0)
        ? parseQuotedField(s)
        : parseUnquotedField(s);
    if (s.done() ||
        fieldSeparator.matches(s) > 0 ||
        recordSeparator.matches(s) > 0) {
      return f;
    }

    s.fail("fail to read field or record separator after quoted field",
        decodeErrorInvalidCharAfterField);
  }

  String parseQuotedField(ParseState s) {
    if (fieldQuote == FieldQuote.NONE) {
      s.fail("field quote not allowed", decodeErrorFieldQuoteNotAllowed);
    }
    if (fieldQuote.matches(s) == 0) {
      s.fail("fail to read opening quote", decodeErrorOpeningQuoteNotFound);
    }
    s.move(fieldQuote.matches(s));

    String field = "";
    while (!s.done()) {
      if (s.peek(escapedQuote.length) == escapedQuote.join()) {
        field += fieldQuote.value();
        s.move(escapedQuote.length);
        continue;
      }
      if (fieldQuote.matches(s) > 0) {
        s.move(fieldQuote.matches(s));
        return field;
      }

      field += s.peek(1);
      s.move(1);
    }

    s.fail("fail to read closing quote", decodeErrorClosingQuoteNotFound);
  }

  String parseUnquotedField(ParseState s) {
    String field = "";
    while (!s.done()) {
      if (recordSeparator.matches(s) > 0) {
        return field;
      }
      if (fieldSeparator.matches(s) > 0) {
        return field;
      }

      field += s.peek(1);
      s.move(1);
    }
    return field;
  }

  List<List<String>> decode(String input) {
    return parse(ParseState(Characters(input).toList()));
  }
}
