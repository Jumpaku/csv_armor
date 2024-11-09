import 'dart:math';

import 'package:characters/characters.dart';
import 'package:collection/collection.dart';
import 'package:csv_armor/csv/decoder_config.dart';
import 'package:csv_armor/csv/record_separator.dart';

import 'error.dart';

class Decoder {
  Decoder(DecoderConfig config)
      : _recordSeparator = config.recordSeparator,
        _fieldSeparator = Characters(config.fieldSeparator).toList() {
    final fieldQuoteLeft =
        config.fieldQuote?.leftQuote ?? config.fieldQuote?.quote;
    final fieldQuoteRight =
        config.fieldQuote?.rightQuote ?? config.fieldQuote?.quote;
    _fieldQuoteLeft =
        fieldQuoteLeft == null ? null : Characters(fieldQuoteLeft).toList();
    _fieldQuoteRight =
        fieldQuoteRight == null ? null : Characters(fieldQuoteRight).toList();

    final fieldQuoteEscapeLeft =
        config.fieldQuote?.leftQuoteEscape ?? config.fieldQuote?.quoteEscape;
    final fieldQuoteEscapeRight =
        config.fieldQuote?.rightQuoteEscape ?? config.fieldQuote?.quoteEscape;
    _fieldQuoteEscapeLeft = fieldQuoteEscapeLeft == null
        ? null
        : Characters(fieldQuoteEscapeLeft).toList();
    _fieldQuoteEscapeRight = fieldQuoteEscapeRight == null
        ? null
        : Characters(fieldQuoteEscapeRight).toList();
  }

  final RecordSeparator _recordSeparator;
  late final List<String> _fieldSeparator;
  late final List<String>? _fieldQuoteLeft;
  late final List<String>? _fieldQuoteRight;
  late final List<String>? _fieldQuoteEscapeLeft;
  late final List<String>? _fieldQuoteEscapeRight;

  List<List<String>> _parse(_ParseState s) {
    final records = <List<String>>[];
    if (s.done()) {
      return [];
    }
    while (!s.done()) {
      final record = _parseRecord(s);
      records.add(record);

      if (_matchesRecordSeparator(s, _recordSeparator) > 0) {
        s.move(_matchesRecordSeparator(s, _recordSeparator));
      }
    }
    return records;
  }

  List<String> _parseRecord(_ParseState s) {
    final List<String> fields = [];
    while (!s.done()) {
      if (_matchesRecordSeparator(s, _recordSeparator) > 0) {
        break;
      }
      if (s.matches(_fieldSeparator) > 0) {
        s.move(s.matches(_fieldSeparator));
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
    if (_matchesRecordSeparator(s, _recordSeparator) > 0) {
      return "";
    }
    if (s.matches(_fieldSeparator) > 0) {
      return "";
    }

    final f = (_fieldQuoteLeft != null && s.matches(_fieldQuoteLeft) > 0)
        ? _parseQuotedField(s)
        : _parseUnquotedField(s);
    if (s.done() ||
        (s.matches(_fieldSeparator) > 0) ||
        _matchesRecordSeparator(s, _recordSeparator) > 0) {
      return f;
    }

    s.fail("fail to read field or record separator after quoted field",
        decodeErrorInvalidCharAfterField);
  }

  String _parseQuotedField(_ParseState s) {
    if (_fieldQuoteLeft == null || s.matches(_fieldQuoteLeft) == 0) {
      s.fail("fail to read opening quote", decodeErrorOpeningQuoteNotFound);
    }
    if (_fieldQuoteRight == null) {
      s.fail("fail to read closing quote", decodeErrorClosingQuoteNotFound);
    }
    s.move(s.matches(_fieldQuoteLeft));

    final field = StringBuffer();
    while (!s.done()) {
      final [escL, escR] = [_fieldQuoteEscapeLeft, _fieldQuoteEscapeRight];
      if (escL != null && s.peek(escL.length) == escL.join()) {
        field.write(_fieldQuoteLeft.join());
        s.move(escL.length);
        continue;
      }
      if (escR != null && s.peek(escR.length) == escR.join()) {
        field.write(_fieldQuoteRight.join());
        s.move(escR.length);
        continue;
      }
      if (s.matches(_fieldQuoteRight) > 0) {
        s.move(s.matches(_fieldQuoteRight));
        return field.toString();
      }

      field.write(s.peek(1));
      s.move(1);
    }

    s.fail("fail to read closing quote", decodeErrorClosingQuoteNotFound);
  }

  String _parseUnquotedField(_ParseState s) {
    final field = StringBuffer();
    while (!s.done()) {
      if (_matchesRecordSeparator(s, _recordSeparator) > 0) {
        return field.toString();
      }
      if (s.matches(_fieldSeparator) > 0) {
        return field.toString();
      }

      field.write(s.peek(1));
      s.move(1);
    }
    return field.toString();
  }

  List<List<String>> decode(String input) {
    return _parse(_ParseState(Characters(input).toList()));
  }
}

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

  int matches(List<String> chars) {
    return peek(chars.length) == chars.join() ? chars.length : 0;
  }

  void move(int count) {
    cursor += count;
  }

  Never fail(String message, String code) {
    throw DecodeException(message, code, input, cursor);
  }
}

int _matchesRecordSeparator(_ParseState s, RecordSeparator sep) {
  if (sep == RecordSeparator.ANY) {
    final m = [RecordSeparator.CRLF, RecordSeparator.LF, RecordSeparator.CR]
        .map((sep) => _matchesRecordSeparator(s, sep))
        .firstWhereOrNull((m) => m > 0);
    return m ?? 0;
  }
  final chars = switch (sep) {
    RecordSeparator.CRLF => Characters("\r\n").toList(),
    RecordSeparator.LF => Characters("\n").toList(),
    RecordSeparator.CR => Characters("\r").toList(),
    RecordSeparator.ANY => throw AssertionError("unreachable"),
  };
  return s.matches(chars);
}
