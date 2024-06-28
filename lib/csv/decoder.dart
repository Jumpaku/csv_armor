import 'dart:math';

import 'package:characters/characters.dart';
import 'package:csv_armor/csv/field_quote.dart';
import 'package:csv_armor/csv/field_separator.dart';
import 'package:csv_armor/csv/record_separator.dart';

import 'error.dart';

class _ParseState {
  _ParseState(this.input);

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

int _matchesFieldSeparator(_ParseState s, FieldSeparator sep) {
  final chars = switch (sep) {
    FieldSeparator.COMMA => Characters(",").toList(),
    FieldSeparator.TAB => Characters("\t").toList(),
  };
  return s.peek(chars.length) == chars.join() ? chars.length : 0;
}

int _matchesFieldQuote(_ParseState s, FieldQuote quote) {
  final chars = switch (quote) {
    FieldQuote.DQUOTE => Characters('"').toList(),
    FieldQuote.SQUOTE => Characters("'").toList(),
    FieldQuote.NONE => [],
  };
  return s.peek(chars.length) == chars.join() ? chars.length : 0;
}

int _matchesRecordSeparator(_ParseState s, RecordSeparator sep) {
  if (sep == RecordSeparator.ANY) {
    for (final rSep in [
      RecordSeparator.CRLF,
      RecordSeparator.LF,
      RecordSeparator.CR,
    ]) {
      return _matchesRecordSeparator(s, rSep);
    }
  }
  final chars = switch (sep) {
    RecordSeparator.CRLF => Characters("\r\n").toList(),
    RecordSeparator.LF => Characters("\n").toList(),
    RecordSeparator.CR => Characters("\r").toList(),
    RecordSeparator.ANY => throw AssertionError("unreachable"),
  };
  return s.peek(chars.length) == chars.join() ? chars.length : 0;
}

class Decoder {
  Decoder({
    this.recordSeparator = RecordSeparator.CRLF,
    this.fieldSeparator = FieldSeparator.COMMA,
    this.fieldQuote = FieldQuote.DQUOTE,
    String escapedQuote = '""',
  }) : this.escapedQuote = Characters(escapedQuote).toList();

  final RecordSeparator recordSeparator;
  final FieldSeparator fieldSeparator;
  final FieldQuote fieldQuote;
  final List<String> escapedQuote;

  List<List<String>> _parse(_ParseState s) {
    final records = <List<String>>[];
    if (s.done()) {
      return [];
    }
    while (!s.done()) {
      final record = _parseRecord(s);
      records.add(record);

      if (_matchesRecordSeparator(s, recordSeparator) > 0) {
        s.move(_matchesRecordSeparator(s, recordSeparator));
      }
    }
    return records;
  }

  List<String> _parseRecord(_ParseState s) {
    final List<String> fields = [];
    while (!s.done()) {
      if (_matchesRecordSeparator(s, recordSeparator) > 0) {
        break;
      }
      if (_matchesFieldSeparator(s, fieldSeparator) > 0) {
        s.move(_matchesFieldSeparator(s, fieldSeparator));
      }
      final field = _parseField(s);
      fields.add(field);
    }
    return fields;
  }

  String _parseField(_ParseState s) {
    if (s.done()) {
      return "";
    }
    if (_matchesRecordSeparator(s, recordSeparator) > 0) {
      return "";
    }
    if (_matchesFieldSeparator(s, fieldSeparator) > 0) {
      return "";
    }

    final f = (_matchesFieldQuote(s, fieldQuote) > 0)
        ? _parseQuotedField(s)
        : _parseUnquotedField(s);
    if (s.done() ||
        _matchesFieldSeparator(s, fieldSeparator) > 0 ||
        _matchesRecordSeparator(s, recordSeparator) > 0) {
      return f;
    }

    s.fail("fail to read field or record separator after quoted field",
        decodeErrorInvalidCharAfterField);
  }

  String _parseQuotedField(_ParseState s) {
    if (fieldQuote == FieldQuote.NONE) {
      s.fail("field quote not allowed", decodeErrorFieldQuoteNotAllowed);
    }
    if (_matchesFieldQuote(s, fieldQuote) == 0) {
      s.fail("fail to read opening quote", decodeErrorOpeningQuoteNotFound);
    }
    s.move(_matchesFieldQuote(s, fieldQuote));

    String field = "";
    while (!s.done()) {
      if (s.peek(escapedQuote.length) == escapedQuote.join()) {
        field += fieldQuote.value();
        s.move(escapedQuote.length);
        continue;
      }
      if (_matchesFieldQuote(s, fieldQuote) > 0) {
        s.move(_matchesFieldQuote(s, fieldQuote));
        return field;
      }

      field += s.peek(1);
      s.move(1);
    }

    s.fail("fail to read closing quote", decodeErrorClosingQuoteNotFound);
  }

  String _parseUnquotedField(_ParseState s) {
    String field = "";
    while (!s.done()) {
      if (_matchesRecordSeparator(s, recordSeparator) > 0) {
        return field;
      }
      if (_matchesFieldSeparator(s, fieldSeparator) > 0) {
        return field;
      }

      field += s.peek(1);
      s.move(1);
    }
    return field;
  }

  List<List<String>> decode(String input) {
    return _parse(_ParseState(Characters(input).toList()));
  }
}
