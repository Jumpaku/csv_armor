import 'package:schema_editor/schema/schema.dart';

const errorCodeUndefinedColumnType = 'undefined_column_type';
const errorCodeInvalidColumnRegexp = 'invalid_column_regexp';
const errorCodeEmptyPrimaryKey = 'empty_primary_key';
const errorCodeUndefinedPrimaryKeyColumn = 'undefined_primary_key_column';
const errorCodeEmptyUniqueKey = 'empty_unique_key';
const errorCodeUndefinedUniqueKeyColumn = 'undefined_unique_key_column';
const errorCodeEmptyForeignKeyColumns = 'empty_foreign_key_columns';
const errorCodeUndefinedForeignKeyColumn = 'undefined_foreign_key_column';
const errorCodeUndefinedForeignKeyReferenceTable =
    'undefined_foreign_key_reference_table';
const errorCodeInvalidColumnTypeRegexp = 'invalid_column_type_regexp';

class SchemaValidationError {
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
    errors.add(SchemaValidationError(path, code, message));
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
    result.addError([...path], errorCodeInvalidColumnTypeRegexp,
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
  //final referenceColumns = fk.value.reference.uniqueKey;
  if (columns.isEmpty) {
    result.addError(
        [...path, 'foreign_keys', fkName, 'columns'],
        errorCodeEmptyForeignKeyColumns,
        'Foreign key "$fkName" cannot have empty columns in table "$tableName".');
  }
  for (final (fkIdx, fkColumn) in columns.indexed) {
    if (!columnSet.contains(fkColumn)) {
      result.addError(
          [...path, 'foreign_keys', fkName, 'columns', "$fkIdx"],
          errorCodeUndefinedForeignKeyColumn,
          'Foreign key column "$fkColumn" does not exist in table "$tableName".');
    }
  }
  if (!tableMap.containsKey(referenceTable)) {
    result.addError(
        [...path, 'foreign_keys', fkName, 'reference', 'table'],
        errorCodeUndefinedForeignKeyReferenceTable,
        'Reference table "$referenceTable" does not exist in schema.');
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
    result.addError([...path, 'unique_keys', ukName], errorCodeEmptyUniqueKey,
        'Unique key "$ukName" cannot be empty in table "$tableName".');
  }
  for (final (ukIdx, ukColumn) in ukColumns.indexed) {
    if (!columnSet.contains(ukColumn)) {
      result.addError(
          [...path, 'unique_keys', ukName, "$ukIdx"],
          errorCodeUndefinedUniqueKeyColumn,
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
    result.addError([...path, 'primary_key'], errorCodeEmptyPrimaryKey,
        'Primary key cannot be empty in table "$table".');
  }
  for (final (pkIdx, pkColumn) in primaryKey.indexed) {
    if (!columnSet.contains(pkColumn)) {
      result.addError(
          [...path, 'primary_key', "$pkIdx"],
          errorCodeUndefinedPrimaryKeyColumn,
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
      result.addError([...path, 'type'], errorCodeUndefinedColumnType,
          'Undefined column type "${column.type}" in column "${column.name}".');
    }
  }
  if (column.regexp != null) {
    try {
      RegExp(column.regexp!);
    } catch (e) {
      result.addError([...path, 'regexp'], errorCodeInvalidColumnRegexp,
          'Invalid regular expression in column "${column.name}": ${column.regexp}: ${e.toString()}');
    }
  }

  return result;
}
