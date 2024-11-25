import 'package:csv_armor/csv/armor/validate/result.dart';
import 'package:csv_armor/csv/armor/validate/validate_func.dart';
/*
class Validator {
  Validator(this._schemaCSVCache);

  final SchemaCSVCache _schemaCSVCache;

  ValidationResult validate(String schemaPath, {bool reload = false}) {
    final schemaCSV = _schemaCSVCache[schemaPath];
    if (schemaCSV == null) {
      return ValidationResult(errors: [SchemaCSVNotFound(schemaPath)]);
    }
    final csv = schemaCSV.csv;
    final schema = schemaCSV.schema;

    final errors = validateShape(schema, csv);
    if (errors.isNotEmpty) {
      return ValidationResult(errors: errors);
    }

    errors.addAll(validatePrimaryKey(schema, csv));
    errors.addAll(validateUniqueKey(schema, csv));
    errors.addAll(validateFieldFormat(schema, csv));
    schema.foreignKey.forEach((fkName, fk) {
      final foreignSchemaPath = _schemaCSVCache.resolveFromSchema(
        schemaPath,
        fk.reference.schemaPath,
      );
      final foreignSchemaCSV = _schemaCSVCache[foreignSchemaPath];
      if (foreignSchemaCSV == null) {
        errors.add(SchemaCSVNotFound(foreignSchemaPath));
        return;
      }

      final fkSchemaErrors =
          validateForeignKeySchema(schema, foreignSchemaCSV.schema);
      if (fkSchemaErrors.isNotEmpty) {
        errors.addAll(fkSchemaErrors);
        return;
      }
      final foreignSchema = foreignSchemaCSV.schema;
      final foreignCSV = foreignSchemaCSV.csv;
      errors.addAll(
        validateForeignKey(fkName, schema, csv, foreignSchema, foreignCSV),
      );
    });

    return ValidationResult(errors: errors);
  }
}
*/