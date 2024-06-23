import 'package:csv_armor/errors/base_exception.dart';

const schemaErrorYAMLLoadFailure = "schemaErrorYAMLLoadFailure";
const schemaErrorSchemaValidationFailure = "schemaErrorSchemaValidationFailure";
const schemaErrorEmptyColumn = "schemaErrorEmptyColumn";
const schemaErrorEmptyPrimaryKeyColumn = "schemaErrorEmptyPrimaryKeyColumn";
const schemaErrorEmptyUniqueKeyColumn = "schemaErrorEmptyUniqueKeyColumn";
const schemaErrorEmptyForeignKeyReferencingColumn =
    "schemaErrorEmptyForeignKeyReferencingColumn";
const schemaErrorEmptyForeignKeyReferencedColumn =
    "schemaErrorEmptyForeignKeyReferencedColumn";

class SchemaException extends BaseException {
  SchemaException(String message, String code, this.name, {Object? cause})
      : super(message, code, cause == null ? [] : [cause]);

  final String name;
}
