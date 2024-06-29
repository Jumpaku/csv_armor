import 'package:csv_armor/errors/base_exception.dart';

const schemaErrorYamlEncodeFailure = "schemaErrorYamlEncodeFailure";
const schemaErrorSchemaValidationFailure = "schemaErrorSchemaValidationFailure";
const schemaErrorInvalidColumnFormatRegex =
    "schemaErrorInvalidColumnFormatRegex";
const schemaErrorDuplicatedColumnName = "schemaErrorDuplicatedColumnName";
const schemaErrorEmptyColumns = "schemaErrorEmptyColumns";
const schemaErrorEmptyColumnName = "schemaErrorEmptyColumnName";
const schemaErrorEmptyPrimaryKeyColumn = "schemaErrorEmptyPrimaryKeyColumn";
const schemaErrorPrimaryKeyNotInColumns = "schemaErrorPrimaryKeyNotInColumns";
const schemaErrorEmptyUniqueKeyColumn = "schemaErrorEmptyUniqueKeyColumn";
const schemaErrorUniqueKeyNotInColumns = "schemaErrorUniqueKeyNotInColumns";
const schemaErrorEmptyForeignKeyBaseColumn =
    "schemaErrorEmptyForeignKeyBaseColumn";
const schemaErrorForeignKeyReferenceColumnNotInColumns =
    "schemaErrorForeignKeyReferenceColumnNotInColumns";
const schemaErrorForeignKeyColumnCountMismatch =
    "schemaErrorForeignKeyColumnCountMismatch";

class SchemaException extends BaseException {
  SchemaException(String message, String code, this.name, {Object? cause})
      : super(message, code, cause == null ? [] : [cause]);

  final String? name;
}
