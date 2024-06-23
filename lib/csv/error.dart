import 'package:csv_armor/errors/base_exception.dart';

const decodeErrorFieldQuoteNotAllowed = "decodeErrorFieldQuoteNotAllowed";
const decodeErrorOpeningQuoteNotFound = "decodeErrorOpeningQuoteNotFound";
const decodeErrorClosingQuoteNotFound = "decodeErrorClosingQuoteNotFound";
const decodeErrorInvalidCharAfterField = "decodeErrorInvalidCharAfterField";

class DecodeException extends BaseException {
  DecodeException(String message, String code, this.input, this.cursor,
      {Object? cause})
      : super(message, cause == null ? [] : [cause]);

  final int cursor;
  final List<String> input;
}

const encodeErrorFieldQuoteRequired = "encodeErrorFieldQuoteRequired";

class EncodeException extends BaseException {
  EncodeException(
      String message, String code, this.row, this.column, this.value,
      {Object? cause})
      : super(message, cause == null ? [] : [cause]);

  final int row;
  final int column;
  final String value;
}
