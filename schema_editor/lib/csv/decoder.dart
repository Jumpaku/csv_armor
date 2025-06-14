import 'dart:math';

import 'package:characters/characters.dart';
import 'package:collection/collection.dart';
import 'package:schema_editor/csv/decode_exception.dart';
import 'package:schema_editor/csv/decoder_config.dart';

class Position {
  Position(this.cursor, this.line, this.column);

  final int cursor;
  final int line;
  final int column;
}

class Record {
  Record(this.start, this.end, this.fields);

  final Position start;
  final Position end;
  final List<Field> fields;
}

class Field {
  Field(this.start, this.end, this.value);

  final Position start;
  final Position end;
  final String value;
}

class DecodeResult {
  DecodeResult(this.input, this.headers, this.records);

  final List<String> input;
  final List<Record> headers;
  final List<Record> records;
}

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

  DecodeResult decode(String input) {
    final inputChars = Characters(input).toList();
    final positions = <Position>[];
    int line = 0;
    int column = 0;
    for (final (cursor, char) in inputChars.indexed) {
      positions.add(Position(cursor, line, column));
      column++;
      if (char == "\r\n" || char == "\n" || char == "\r") {
        line++;
        column = 0;
      }
    }
    positions.add(Position(inputChars.length, line, column));

    final csv = _parse(_ParseState(inputChars, positions));
    if (csv.length < _headerLines) {
      throw DecodeException(
        "Too few header lines: expected $_headerLines, got ${csv.length}",
        DecodeException.codeTooFewHeaderLines,
        Characters(input).toList(),
        positions.last,
      );
    }

    return DecodeResult(
      inputChars,
      csv.sublist(0, _headerLines),
      csv.sublist(_headerLines, csv.length),
    );
  }

  List<Record> _parse(_ParseState s) {
    final records = <Record>[];
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

  Record _parseRecord(_ParseState s) {
    final start = s.positions[s.cursor];

    final List<Field> fields = [];
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
    final end = s.positions[s.cursor];
    return Record(start, end, fields);
  }

  Field _parseField(_ParseState s) {
    final start = s.positions[s.cursor];
    if (s.done()) {
      return Field(start, start, "");
    }
    if (_matchesRecordSeparator(s, _recordSeparator) > 0) {
      return Field(start, start, "");
    }
    if (s.matches(_fieldSeparator) > 0) {
      return Field(start, start, "");
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

  Field _parseQuotedField(_ParseState s) {
    if (s.matches(_fieldQuoteLeft) == 0) {
      s.fail("fail to read opening quote",
          DecodeException.codeOpeningQuoteNotFound);
    }
    s.move(s.matches(_fieldQuoteLeft));

    final start = s.positions[s.cursor];

    final fieldValue = StringBuffer();
    while (!s.done()) {
      final [escL, escR] = [_fieldQuoteEscapeLeft, _fieldQuoteEscapeRight];
      if (s.peek(escL.length) == escL.join()) {
        fieldValue.write(_fieldQuoteLeft.join());
        s.move(escL.length);
        continue;
      }
      if (s.peek(escR.length) == escR.join()) {
        fieldValue.write(_fieldQuoteRight.join());
        s.move(escR.length);
        continue;
      }
      if (s.matches(_fieldQuoteRight) > 0) {
        final end = s.positions[s.cursor];

        s.move(s.matches(_fieldQuoteRight));
        return Field(start, end, fieldValue.toString());
      }

      fieldValue.write(s.peek(1));
      s.move(1);
    }

    s.fail(
        "fail to read closing quote", DecodeException.codeClosingQuoteNotFound);
  }

  Field _parseUnquotedField(_ParseState s) {
    final start = s.positions[s.cursor];
    final fieldValue = StringBuffer();
    while (!s.done()) {
      if (_matchesRecordSeparator(s, _recordSeparator) > 0) {
        final end = s.positions[s.cursor];
        return Field(start, end, fieldValue.toString());
      }
      if (s.matches(_fieldSeparator) > 0) {
        final end = s.positions[s.cursor];
        return Field(start, end, fieldValue.toString());
      }

      fieldValue.write(s.peek(1));
      s.move(1);
    }
    final end = s.positions[s.cursor];
    return Field(start, end, fieldValue.toString());
  }
}

class _ParseState {
  _ParseState(this.input, this.positions);

  final List<String> input;
  final List<Position> positions;
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
    throw DecodeException(message, code, input, positions[cursor]);
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
