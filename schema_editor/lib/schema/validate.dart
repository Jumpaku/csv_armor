import 'package:schema_editor/schema/schema.dart';
import 'package:schema_editor/schema/validation_result.dart';

ValidationResult validateSchema(Schema schema) {
  final result = ValidationResult();

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

ValidationResult validateColumnType(
  List<String> path,
  String columnTypeKey,
  String columnTypeValue,
) {
  final result = ValidationResult();
  try {
    RegExp(columnTypeValue);
  } catch (e) {
    result.addError(
        [...path],
        ValidationError.codeInvalidColumnTypeRegexp,
        'Invalid regular expression for column type "$columnTypeKey": $columnTypeValue: ${e.toString()}');
  }
  return result;
}

// <csv-path> := [<prefix>] <path-component> [ '/' <path-component> ]...
// <prefix> := './' | '../' | '/'
// <path-component> := <text_or_placeholder> [ <text_or_placeholder> ]...
// <text_or_placeholder> := <text> | <placeholder>
// <placeholder> := '[' <text> ']'
// <text> := character sequence excluding '[', ']', '/', and '*'
final _csvPathRegExp = RegExp(
    r'^(\.\.?\/)?([^*\/\[\]]+|\[[^*\/\[\]]+\])+(\/([^*\/\[\]]+|\[[^*\/\[\]]+\])+)*$');

// <placeholder> := '[' <text> ']'
// <text> := character sequence excluding '[', ']', '/', and '*'
final _csvPathPlaceholderRegExp = RegExp(r'\[[^*\/\[\]]+\]');

ValidationResult validateTableConfig(
  List<String> path,
  Set<String> typeSet,
  Map<String, TableConfig> tableMap,
  TableConfig config,
) {
  final result = ValidationResult();

  final columnSet = {for (var col in config.columns) col.name};

  if (config.name.isEmpty) {
    result.addError([...path, 'name'], ValidationError.codeEmptyTableName,
        'Table name cannot be empty.');
  }

  if (config.csvPath.isEmpty) {
    result.addError(
        [...path, 'csv_path'],
        ValidationError.codeEmptyCsvPath,
        'Table CSV path cannot be empty.');
  } else {
    if (!_csvPathRegExp.hasMatch(config.csvPath)) {
      result.addError(
          [...path, 'csv_path'],
          ValidationError.codeInvalidCsvPath,
          'Table CSV path "${config.csvPath}" is invalid: regexp ${_csvPathRegExp.pattern}');
    } else {
      final matches = _csvPathPlaceholderRegExp.allMatches(config.csvPath);
      for (final match in matches) {
        final placeholder = match.group(0)!;
        final colName =
            placeholder.substring(1, placeholder.length - 1); // Remove brackets
        if (!columnSet.contains(colName)) {
          result.addError(
              [...path, 'csv_path'],
              ValidationError.codeUndefinedCsvPathPlaceholder,
              'Table CSV path placeholder "$placeholder" in "${config.csvPath}" is not defined.');
        }
      }
    }
  }

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

ValidationResult validateForeignKey(
  List<String> path,
  Map<String, TableConfig> tableMap,
  String tableName,
  Set<String> columnSet,
  String fkName,
  ForeignKey foreignKey,
) {
  final result = ValidationResult();
  final columns = foreignKey.columns;
  final referenceTable = foreignKey.reference.table;
  if (fkName.isEmpty) {
    result.addError(
        [...path, 'foreign_keys', fkName],
        ValidationError.codeEmptyForeignKeyName,
        'Foreign key name cannot be empty in table "$tableName".');
  }
  if (columns.isEmpty) {
    result.addError(
        [...path, 'foreign_keys', fkName, 'columns'],
        ValidationError.codeEmptyForeignKeyColumns,
        'Foreign key "$fkName" cannot have empty columns in table "$tableName".');
  }
  for (final (fkIdx, fkColumn) in columns.indexed) {
    if (!columnSet.contains(fkColumn)) {
      result.addError(
          [...path, 'foreign_keys', fkName, 'columns', "$fkIdx"],
          ValidationError.codeUndefinedForeignKeyColumn,
          'Foreign key column "$fkColumn" does not exist in table "$tableName".');
    }
  }
  if (!tableMap.containsKey(referenceTable)) {
    result.addError(
        [...path, 'foreign_keys', fkName, 'reference', 'table'],
        ValidationError.codeUndefinedForeignKeyReferenceTable,
        'Reference table "$referenceTable" does not exist in schema.');
  } else {
    final referenceUk = foreignKey.reference.uniqueKey;
    final refUk = tableMap[referenceTable]?.uniqueKey ?? {};
    if (referenceUk != null && referenceUk.isNotEmpty) {
      if (!refUk.containsKey(referenceUk)) {
        result.addError(
            [...path, 'foreign_keys', fkName, 'reference', 'unique_key'],
            ValidationError.codeUndefinedForeignKeyReferenceUniqueKey,
            'Reference unique key "$referenceUk" does not exist in table "$referenceTable".');
      }
    }
  }

  return result;
}

ValidationResult validateUniqueKey(
  List<String> path,
  String tableName,
  Set<String> columnSet,
  String ukName,
  List<String> ukColumns,
) {
  final result = ValidationResult();
  if (ukName.isEmpty) {
    result.addError(
        [...path, 'unique_keys', ukName],
        ValidationError.codeEmptyUniqueKeyName,
        'Unique key name cannot be empty in table "$tableName".');
  }
  if (ukColumns.isEmpty) {
    result.addError(
        [...path, 'unique_keys', ukName],
        ValidationError.codeEmptyUniqueKeyColumns,
        'Unique key "$ukName" cannot be empty in table "$tableName".');
  }
  for (final (ukIdx, ukColumn) in ukColumns.indexed) {
    if (!columnSet.contains(ukColumn)) {
      result.addError(
          [...path, 'unique_keys', ukName, "$ukIdx"],
          ValidationError.codeUndefinedUniqueKeyColumn,
          'Unique key column "$ukColumn" does not exist in table "$tableName".');
    }
  }
  return result;
}

ValidationResult validatePrimaryKey(
  List<String> path,
  Set<String> columnSet,
  String table,
  List<String> primaryKey,
) {
  final result = ValidationResult();
  if (primaryKey.isEmpty) {
    result.addError(
        [...path, 'primary_key'],
        ValidationError.codeEmptyPrimaryKey,
        'Primary key cannot be empty in table "$table".');
  }
  for (final (pkIdx, pkColumn) in primaryKey.indexed) {
    if (!columnSet.contains(pkColumn)) {
      result.addError(
          [...path, 'primary_key', "$pkIdx"],
          ValidationError.codeUndefinedPrimaryKeyColumn,
          'Primary key column "$pkColumn" does not exist in table "$table".');
    }
  }
  return result;
}

ValidationResult validateColumn(
  List<String> path,
  Set<String> typeSet,
  TableColumn column,
) {
  final result = ValidationResult();
  if (column.type != null) {
    if (!typeSet.contains(column.type!)) {
      result.addError(
          [...path, 'type'],
          ValidationError.codeUndefinedColumnType,
          'Undefined column type "${column.type}" in column "${column.name}".');
    }
  }
  if (column.regexp != null) {
    try {
      RegExp(column.regexp!);
    } catch (e) {
      result.addError(
          [...path, 'regexp'],
          ValidationError.codeInvalidColumnRegexp,
          'Invalid regular expression in column "${column.name}": ${column.regexp}: ${e.toString()}');
    }
  }

  return result;
}
