import 'package:csv_armor/errors/base_exception.dart';

const String schemaErrorEmptyColumn = 'SchemaErrorEmptyColumn';
const String schemaErrorDuplicatedColumn = 'SchemaErrorDuplicatedColumn';
const String schemaErrorEmptyPrimaryKey = 'SchemaErrorEmptyPrimaryKey';
const String schemaErrorPrimaryKeyNotInColumns =
    'SchemaErrorPrimaryKeyNotInColumns';
const String schemaErrorEmptyUniqueKey = 'SchemaErrorEmptyUniqueKey';
const String schemaErrorUniqueKeyNotInColumns =
    'SchemaErrorUniqueKeyNotInColumns';
const String schemaErrorEmptyForeignKey = 'SchemaErrorEmptyForeignKey';
const String schemaErrorForeignKeyNotInColumns =
    'SchemaErrorForeignKeyNotInColumns';

class SchemaException extends BaseException {
  SchemaException(String message, String code, this.name, {Object? cause})
      : super(message, code, cause == null ? [] : [cause]);

  final String? name;
}
