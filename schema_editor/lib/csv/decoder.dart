import 'dart:math';

import 'package:characters/characters.dart';
import 'package:collection/collection.dart';
import 'package:schema_editor/csv/decode_exception.dart';
import 'package:schema_editor/csv/decoder_config.dart';

class Decoder {
  Decoder(DecoderConfig config)
      : _headerLines = config.headerLines,
        _recordSeparator = config.recordSeparator,
        _fieldSeparator = Characters(config.fieldSeparator).toList(),
        _fieldQuoteLeft = Characters(config.fieldQuote.leftQuote).toList(),
        _fieldQuoteRight = Characters(config.fieldQuote.rightQuote).toList(),
        _fieldQuoteEscapeLeft =
            Characters(config.fieldQuote.leftQuoteEscape).toList(),
        _fieldQuoteEscapeRight =
            Characters(config.fieldQuote.rightQuoteEscape).toList();

  final int _headerLines;

  final RecordSeparator _recordSeparator;
  final List<String> _fieldSeparator;
  final List<String> _fieldQuoteLeft;
  final List<String> _fieldQuoteRight;
  final List<String> _fieldQuoteEscapeLeft;
  final List<String> _fieldQuoteEscapeRight;

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

    final f = (s.matches(_fieldQuoteLeft) > 0)
        ? _parseQuotedField(s)
        : _parseUnquotedField(s);
    if (s.done() ||
        (s.matches(_fieldSeparator) > 0) ||
        _matchesRecordSeparator(s, _recordSeparator) > 0) {
      return f;
    }

    s.fail("fail to read field or record separator after quoted field",
        DecodeException.codeInvalidCharAfterField);
  }

  String _parseQuotedField(_ParseState s) {
    if (s.matches(_fieldQuoteLeft) == 0) {
      s.fail("fail to read opening quote",
          DecodeException.codeOpeningQuoteNotFound);
    }
    s.move(s.matches(_fieldQuoteLeft));

    final field = StringBuffer();
    while (!s.done()) {
      final [escL, escR] = [_fieldQuoteEscapeLeft, _fieldQuoteEscapeRight];
      if (s.peek(escL.length) == escL.join()) {
        field.write(_fieldQuoteLeft.join());
        s.move(escL.length);
        continue;
      }
      if (s.peek(escR.length) == escR.join()) {
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

    s.fail(
        "fail to read closing quote", DecodeException.codeClosingQuoteNotFound);
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

  ({List<List<String>> headers, List<List<String>> records}) decode(
      String input) {
    final csv = _parse(_ParseState(Characters(input).toList()));
    if (csv.length < _headerLines) {
      throw DecodeException(
        "Too few header lines: expected $_headerLines, got ${csv.length}",
        DecodeException.codeTooFewHeaderLines,
        Characters(input).toList(),
        0,
      );
    }
    return (
      headers: csv.sublist(0, _headerLines),
      records: csv.sublist(_headerLines, csv.length),
    );
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
  if (sep == RecordSeparator.any) {
    final m = [RecordSeparator.crlf, RecordSeparator.lf, RecordSeparator.cr]
        .map((sep) => _matchesRecordSeparator(s, sep))
        .firstWhereOrNull((m) => m > 0);
    return m ?? 0;
  }
  final chars = switch (sep) {
    RecordSeparator.crlf => Characters("\r\n").toList(),
    RecordSeparator.lf => Characters("\n").toList(),
    RecordSeparator.cr => Characters("\r").toList(),
    RecordSeparator.any => throw AssertionError("unreachable"),
  };
  return s.matches(chars);
}
