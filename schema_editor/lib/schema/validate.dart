import 'package:schema_editor/schema/schema.dart';

class SchemaValidationError {
  static const codeUndefinedColumnType = 'undefined_column_type';
  static const codeInvalidColumnRegexp = 'invalid_column_regexp';
  static const codeEmptyPrimaryKey = 'empty_primary_key';
  static const codeUndefinedPrimaryKeyColumn = 'undefined_primary_key_column';
  static const codeEmptyUniqueKey = 'empty_unique_key';
  static const codeUndefinedUniqueKeyColumn = 'undefined_unique_key_column';
  static const codeEmptyForeignKeyColumns = 'empty_foreign_key_columns';
  static const codeUndefinedForeignKeyColumn = 'undefined_foreign_key_column';
  static const codeUndefinedForeignKeyReferenceTable =
      'undefined_foreign_key_reference_table';
  static const codeInvalidColumnTypeRegexp = 'invalid_column_type_regexp';
  static const codeUndefinedForeignKeyReferenceUniqueKey =
      'undefined_foreign_key_reference_unique_key';
  static const codeInvalidAgainstJsonSchema = 'invalid_against_json_schema';

  SchemaValidationError(this.path, this.code, this.message);

  final List<String> path;
  final String code;
  final String message;
}

class SchemaValidationResult {
  SchemaValidationResult({this.errors = const []});

  List<SchemaValidationError> errors;

  bool get isValid => errors.isEmpty;

  void addError(List<String> path, String code, String message) {
    errors = [...errors, SchemaValidationError(path, code, message)];
  }

  void merge(SchemaValidationResult other) {
    errors.addAll(other.errors);
  }
}

SchemaValidationResult validateSchema(Schema schema) {
  final result = SchemaValidationResult();

  final columnTypeSet = schema.columnType.keys.toSet();
  final tableConfigMap = {
    for (var table in schema.tableConfig) table.name: table
  };

  for (final (tableIdx, config) in schema.tableConfig.indexed) {
    result.merge(validateTableConfig(
        ['table_config', '$tableIdx'], columnTypeSet, tableConfigMap, config));
  }
  for (final columnType in schema.columnType.entries) {
    result.merge(validateColumnType(
        ['column_type', columnType.key], columnType.key, columnType.value));
  }

  return result;
}

SchemaValidationResult validateColumnType(
  List<String> path,
  String columnTypeKey,
  String columnTypeValue,
) {
  final result = SchemaValidationResult();
  try {
    RegExp(columnTypeValue);
  } catch (e) {
    result.addError(
        [...path],
        SchemaValidationError.codeInvalidColumnTypeRegexp,
        'Invalid regular expression for column type "$columnTypeKey": $columnTypeValue: ${e.toString()}');
  }
  return result;
}

SchemaValidationResult validateTableConfig(
  List<String> path,
  Set<String> typeSet,
  Map<String, TableConfig> tableMap,
  TableConfig config,
) {
  final result = SchemaValidationResult();
  final columnSet = {for (var col in config.columns) col.name};
  for (final (columnIdx, column) in config.columns.indexed) {
    result.merge(
        validateColumn([...path, 'columns', "$columnIdx"], typeSet, column));
  }

  result.merge(
      validatePrimaryKey(path, columnSet, config.name, config.primaryKey));

  for (final uk in config.uniqueKey.entries) {
    result.merge(
        validateUniqueKey(path, config.name, columnSet, uk.key, uk.value));
  }
  for (final fk in config.foreignKey.entries) {
    result.merge(validateForeignKey(
        path, tableMap, config.name, columnSet, fk.key, fk.value));
  }

  return result;
}

SchemaValidationResult validateForeignKey(
  List<String> path,
  Map<String, TableConfig> tableMap,
  String tableName,
  Set<String> columnSet,
  String fkName,
  ForeignKey foreignKey,
) {
  final result = SchemaValidationResult();
  final columns = foreignKey.columns;
  final referenceTable = foreignKey.reference.table;
  if (columns.isEmpty) {
    result.addError(
        [...path, 'foreign_keys', fkName, 'columns'],
        SchemaValidationError.codeEmptyForeignKeyColumns,
        'Foreign key "$fkName" cannot have empty columns in table "$tableName".');
  }
  for (final (fkIdx, fkColumn) in columns.indexed) {
    if (!columnSet.contains(fkColumn)) {
      result.addError(
          [...path, 'foreign_keys', fkName, 'columns', "$fkIdx"],
          SchemaValidationError.codeUndefinedForeignKeyColumn,
          'Foreign key column "$fkColumn" does not exist in table "$tableName".');
    }
  }
  if (!tableMap.containsKey(referenceTable)) {
    result.addError(
        [...path, 'foreign_keys', fkName, 'reference', 'table'],
        SchemaValidationError.codeUndefinedForeignKeyReferenceTable,
        'Reference table "$referenceTable" does not exist in schema.');
  } else {
    final referenceUk = foreignKey.reference.uniqueKey;
    final refUk = tableMap[referenceTable]?.uniqueKey ?? {};
    if (referenceUk != null && referenceUk.isNotEmpty) {
      if (!refUk.containsKey(referenceUk)) {
        result.addError(
            [...path, 'foreign_keys', fkName, 'reference', 'unique_key'],
            SchemaValidationError.codeUndefinedForeignKeyReferenceUniqueKey,
            'Reference unique key "$referenceUk" does not exist in table "$referenceTable".');
      }
    }
  }

  return result;
}

SchemaValidationResult validateUniqueKey(
  List<String> path,
  String tableName,
  Set<String> columnSet,
  String ukName,
  List<String> ukColumns,
) {
  final result = SchemaValidationResult();
  if (ukColumns.isEmpty) {
    result.addError(
        [...path, 'unique_keys', ukName],
        SchemaValidationError.codeEmptyUniqueKey,
        'Unique key "$ukName" cannot be empty in table "$tableName".');
  }
  for (final (ukIdx, ukColumn) in ukColumns.indexed) {
    if (!columnSet.contains(ukColumn)) {
      result.addError(
          [...path, 'unique_keys', ukName, "$ukIdx"],
          SchemaValidationError.codeUndefinedUniqueKeyColumn,
          'Unique key column "$ukColumn" does not exist in table "$tableName".');
    }
  }
  return result;
}

SchemaValidationResult validatePrimaryKey(
  List<String> path,
  Set<String> columnSet,
  String table,
  List<String> primaryKey,
) {
  final result = SchemaValidationResult();
  if (primaryKey.isEmpty) {
    result.addError(
        [...path, 'primary_key'],
        SchemaValidationError.codeEmptyPrimaryKey,
        'Primary key cannot be empty in table "$table".');
  }
  for (final (pkIdx, pkColumn) in primaryKey.indexed) {
    if (!columnSet.contains(pkColumn)) {
      result.addError(
          [...path, 'primary_key', "$pkIdx"],
          SchemaValidationError.codeUndefinedPrimaryKeyColumn,
          'Primary key column "$pkColumn" does not exist in table "$table".');
    }
  }
  return result;
}

SchemaValidationResult validateColumn(
  List<String> path,
  Set<String> typeSet,
  TableColumn column,
) {
  final result = SchemaValidationResult();
  if (column.type != null) {
    if (!typeSet.contains(column.type!)) {
      result.addError(
          [...path, 'type'],
          SchemaValidationError.codeUndefinedColumnType,
          'Undefined column type "${column.type}" in column "${column.name}".');
    }
  }
  if (column.regexp != null) {
    try {
      RegExp(column.regexp!);
    } catch (e) {
      result.addError(
          [...path, 'regexp'],
          SchemaValidationError.codeInvalidColumnRegexp,
          'Invalid regular expression in column "${column.name}": ${column.regexp}: ${e.toString()}');
    }
  }

  return result;
}
