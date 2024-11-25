// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database_config.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$DatabaseConfigCWProxy {
  DatabaseConfig tables(Map<String, TablePath> tables);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DatabaseConfig(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DatabaseConfig(...).copyWith(id: 12, name: "My name")
  /// ````
  DatabaseConfig call({
    Map<String, TablePath>? tables,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfDatabaseConfig.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfDatabaseConfig.copyWith.fieldName(...)`
class _$DatabaseConfigCWProxyImpl implements _$DatabaseConfigCWProxy {
  const _$DatabaseConfigCWProxyImpl(this._value);

  final DatabaseConfig _value;

  @override
  DatabaseConfig tables(Map<String, TablePath> tables) => this(tables: tables);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DatabaseConfig(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DatabaseConfig(...).copyWith(id: 12, name: "My name")
  /// ````
  DatabaseConfig call({
    Object? tables = const $CopyWithPlaceholder(),
  }) {
    return DatabaseConfig(
      tables: tables == const $CopyWithPlaceholder() || tables == null
          ? _value.tables
          // ignore: cast_nullable_to_non_nullable
          : tables as Map<String, TablePath>,
    );
  }
}

extension $DatabaseConfigCopyWith on DatabaseConfig {
  /// Returns a callable class that can be used as follows: `instanceOfDatabaseConfig.copyWith(...)` or like so:`instanceOfDatabaseConfig.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$DatabaseConfigCWProxy get copyWith => _$DatabaseConfigCWProxyImpl(this);
}

abstract class _$TablePathCWProxy {
  TablePath schemaPath(String schemaPath);

  TablePath csvPath(String csvPath);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `TablePath(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// TablePath(...).copyWith(id: 12, name: "My name")
  /// ````
  TablePath call({
    String? schemaPath,
    String? csvPath,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfTablePath.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfTablePath.copyWith.fieldName(...)`
class _$TablePathCWProxyImpl implements _$TablePathCWProxy {
  const _$TablePathCWProxyImpl(this._value);

  final TablePath _value;

  @override
  TablePath schemaPath(String schemaPath) => this(schemaPath: schemaPath);

  @override
  TablePath csvPath(String csvPath) => this(csvPath: csvPath);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `TablePath(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// TablePath(...).copyWith(id: 12, name: "My name")
  /// ````
  TablePath call({
    Object? schemaPath = const $CopyWithPlaceholder(),
    Object? csvPath = const $CopyWithPlaceholder(),
  }) {
    return TablePath(
      schemaPath:
          schemaPath == const $CopyWithPlaceholder() || schemaPath == null
              ? _value.schemaPath
              // ignore: cast_nullable_to_non_nullable
              : schemaPath as String,
      csvPath: csvPath == const $CopyWithPlaceholder() || csvPath == null
          ? _value.csvPath
          // ignore: cast_nullable_to_non_nullable
          : csvPath as String,
    );
  }
}

extension $TablePathCopyWith on TablePath {
  /// Returns a callable class that can be used as follows: `instanceOfTablePath.copyWith(...)` or like so:`instanceOfTablePath.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$TablePathCWProxy get copyWith => _$TablePathCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DatabaseConfig _$DatabaseConfigFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    allowedKeys: const ['tables'],
  );
  return DatabaseConfig(
    tables: (json['tables'] as Map<String, dynamic>).map(
      (k, e) => MapEntry(k, TablePath.fromJson(e as Map<String, dynamic>)),
    ),
  );
}

Map<String, dynamic> _$DatabaseConfigToJson(DatabaseConfig instance) =>
    <String, dynamic>{
      'tables': instance.tables.map((k, e) => MapEntry(k, e.toJson())),
    };

TablePath _$TablePathFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    allowedKeys: const ['schema_path', 'csv_path'],
  );
  return TablePath(
    schemaPath: json['schema_path'] as String,
    csvPath: json['csv_path'] as String,
  );
}

Map<String, dynamic> _$TablePathToJson(TablePath instance) => <String, dynamic>{
      'schema_path': instance.schemaPath,
      'csv_path': instance.csvPath,
    };
