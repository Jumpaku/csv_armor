import 'package:csv_armor/errors/base_exception.dart';

const fileCacheErrorSchemaReadFailure = "fileCacheErrorSchemaReadFailure";
const fileCacheErrorSchemaWriteFailure = "fileCacheErrorSchemaWriteFailure";
const fileCacheErrorCSVReadFailure = "fileCacheErrorCSVReadFailure";
const fileCacheErrorCSVWriteFailure = "fileCacheErrorCSVWriteFailure";

class FileCacheException extends BaseException {
  FileCacheException(
    String message,
    String code,
    this.path, {
    Object? cause,
  }) : super(message, code, cause == null ? [] : [cause]);

  final String path;
}
