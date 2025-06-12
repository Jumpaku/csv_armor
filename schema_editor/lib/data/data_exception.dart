class DataException implements Exception {
  static const String codeInvalidCsvFailed = 'invalid_csv';
  static const String codeQueryExecutionFailed = 'query_execution_failed';

  DataException(
    this.message,
    this.code, {
    this.tableName,
  });

  final String message;
  final String code;
  final String? tableName;

  @override
  String toString() {
    return 'DataException: $message';
  }
}
