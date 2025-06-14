class CsvReaderException implements Exception {
  static const String codeFileReadFailed = 'file_read_failed';
  static const String codeFieldCountMismatch = 'field_count_mismatch';
  static const String codeCsvDecodeFailed = 'csv_decode_failed';

  CsvReaderException(
    this.message,
    this.code, {
    this.tableName,
    this.filePath,
    this.csvLine,
    this.csvColumn,
  });

  final String message;
  final String code;
  final String? tableName;
  final String? filePath;
  final int? csvLine;
  final int? csvColumn;

  @override
  String toString() {
    return 'CsvReaderException: $message';
  }
}
