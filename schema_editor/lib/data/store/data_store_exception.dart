
class DataStoreException implements Exception {
  DataStoreException(
      this.message,
      this.statement, {
        this.params = const [],
        this.tableName = '',
        this.cause,
      });

  final String message;
  final String tableName;
  final String statement;
  final List<dynamic> params;
  final Object? cause;

  @override
  String toString() => 'DataStoreException: $message';
}
