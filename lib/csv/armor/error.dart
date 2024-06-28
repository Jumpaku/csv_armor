import 'package:csv_armor/errors/base_exception.dart';

const readWriteErrorSchemaReadFailure = "readWriteErrorSchemaReadFailure";
const readWriteErrorSchemaWriteFailure = "readWriteErrorSchemaWriteFailure";
const readWriteErrorCSVReadFailure = "readWriteErrorCSVReadFailure";
const readWriteErrorCSVWriteFailure = "readWriteErrorCSVWriteFailure";

class ReadWriteException extends BaseException {
  ReadWriteException(
    String message,
    String code,
    this.targetPath,
    this.pathFrom, {
    Object? cause,
  }) : super(message, code, cause == null ? [] : [cause]);

  final String targetPath;
  final String pathFrom;
}
