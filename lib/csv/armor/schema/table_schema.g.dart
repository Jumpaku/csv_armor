// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'table_schema.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$TableSchemaCWProxy {
  TableSchema description(String description);

  TableSchema headers(List<List<String>> headers);

  TableSchema columns(List<Column> columns);

  TableSchema primaryKey(List<String> primaryKey);

  TableSchema uniqueKey(Map<String, List<String>> uniqueKey);

  TableSchema foreignKey(Map<String, ForeignKey> foreignKey);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `TableSchema(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// TableSchema(...).copyWith(id: 12, name: "My name")
  /// ````
  TableSchema call({
    String? description,
    List<List<String>>? headers,
    List<Column>? columns,
    List<String>? primaryKey,
    Map<String, List<String>>? uniqueKey,
    Map<String, ForeignKey>? foreignKey,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfTableSchema.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfTableSchema.copyWith.fieldName(...)`
class _$TableSchemaCWProxyImpl implements _$TableSchemaCWProxy {
  const _$TableSchemaCWProxyImpl(this._value);

  final TableSchema _value;

  @override
  TableSchema description(String description) => this(description: description);

  @override
  TableSchema headers(List<List<String>> headers) => this(headers: headers);

  @override
  TableSchema columns(List<Column> columns) => this(columns: columns);

  @override
  TableSchema primaryKey(List<String> primaryKey) =>
      this(primaryKey: primaryKey);

  @override
  TableSchema uniqueKey(Map<String, List<String>> uniqueKey) =>
      this(uniqueKey: uniqueKey);

  @override
  TableSchema foreignKey(Map<String, ForeignKey> foreignKey) =>
      this(foreignKey: foreignKey);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `TableSchema(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// TableSchema(...).copyWith(id: 12, name: "My name")
  /// ````
  TableSchema call({
    Object? description = const $CopyWithPlaceholder(),
    Object? headers = const $CopyWithPlaceholder(),
    Object? columns = const $CopyWithPlaceholder(),
    Object? primaryKey = const $CopyWithPlaceholder(),
    Object? uniqueKey = const $CopyWithPlaceholder(),
    Object? foreignKey = const $CopyWithPlaceholder(),
  }) {
    return TableSchema(
      description:
          description == const $CopyWithPlaceholder() || description == null
              ? _value.description
              // ignore: cast_nullable_to_non_nullable
              : description as String,
      headers: headers == const $CopyWithPlaceholder() || headers == null
          ? _value.headers
          // ignore: cast_nullable_to_non_nullable
          : headers as List<List<String>>,
      columns: columns == const $CopyWithPlaceholder() || columns == null
          ? _value.columns
          // ignore: cast_nullable_to_non_nullable
          : columns as List<Column>,
      primaryKey:
          primaryKey == const $CopyWithPlaceholder() || primaryKey == null
              ? _value.primaryKey
              // ignore: cast_nullable_to_non_nullable
              : primaryKey as List<String>,
      uniqueKey: uniqueKey == const $CopyWithPlaceholder() || uniqueKey == null
          ? _value.uniqueKey
          // ignore: cast_nullable_to_non_nullable
          : uniqueKey as Map<String, List<String>>,
      foreignKey:
          foreignKey == const $CopyWithPlaceholder() || foreignKey == null
              ? _value.foreignKey
              // ignore: cast_nullable_to_non_nullable
              : foreignKey as Map<String, ForeignKey>,
    );
  }
}

extension $TableSchemaCopyWith on TableSchema {
  /// Returns a callable class that can be used as follows: `instanceOfTableSchema.copyWith(...)` or like so:`instanceOfTableSchema.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$TableSchemaCWProxy get copyWith => _$TableSchemaCWProxyImpl(this);
}

abstract class _$ColumnCWProxy {
  Column name(String name);

  Column description(String description);

  Column allowEmpty(bool allowEmpty);

  Column type(String? type);

  Column regex(String? regex);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Column(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Column(...).copyWith(id: 12, name: "My name")
  /// ````
  Column call({
    String? name,
    String? description,
    bool? allowEmpty,
    String? type,
    String? regex,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfColumn.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfColumn.copyWith.fieldName(...)`
class _$ColumnCWProxyImpl implements _$ColumnCWProxy {
  const _$ColumnCWProxyImpl(this._value);

  final Column _value;

  @override
  Column name(String name) => this(name: name);

  @override
  Column description(String description) => this(description: description);

  @override
  Column allowEmpty(bool allowEmpty) => this(allowEmpty: allowEmpty);

  @override
  Column type(String? type) => this(type: type);

  @override
  Column regex(String? regex) => this(regex: regex);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Column(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Column(...).copyWith(id: 12, name: "My name")
  /// ````
  Column call({
    Object? name = const $CopyWithPlaceholder(),
    Object? description = const $CopyWithPlaceholder(),
    Object? allowEmpty = const $CopyWithPlaceholder(),
    Object? type = const $CopyWithPlaceholder(),
    Object? regex = const $CopyWithPlaceholder(),
  }) {
    return Column(
      name == const $CopyWithPlaceholder() || name == null
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String,
      description:
          description == const $CopyWithPlaceholder() || description == null
              ? _value.description
              // ignore: cast_nullable_to_non_nullable
              : description as String,
      allowEmpty:
          allowEmpty == const $CopyWithPlaceholder() || allowEmpty == null
              ? _value.allowEmpty
              // ignore: cast_nullable_to_non_nullable
              : allowEmpty as bool,
      type: type == const $CopyWithPlaceholder()
          ? _value.type
          // ignore: cast_nullable_to_non_nullable
          : type as String?,
      regex: regex == const $CopyWithPlaceholder()
          ? _value.regex
          // ignore: cast_nullable_to_non_nullable
          : regex as String?,
    );
  }
}

extension $ColumnCopyWith on Column {
  /// Returns a callable class that can be used as follows: `instanceOfColumn.copyWith(...)` or like so:`instanceOfColumn.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ColumnCWProxy get copyWith => _$ColumnCWProxyImpl(this);
}

abstract class _$ForeignKeyCWProxy {
  ForeignKey columns(List<String> columns);

  ForeignKey reference(ForeignKeyReference reference);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ForeignKey(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ForeignKey(...).copyWith(id: 12, name: "My name")
  /// ````
  ForeignKey call({
    List<String>? columns,
    ForeignKeyReference? reference,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfForeignKey.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfForeignKey.copyWith.fieldName(...)`
class _$ForeignKeyCWProxyImpl implements _$ForeignKeyCWProxy {
  const _$ForeignKeyCWProxyImpl(this._value);

  final ForeignKey _value;

  @override
  ForeignKey columns(List<String> columns) => this(columns: columns);

  @override
  ForeignKey reference(ForeignKeyReference reference) =>
      this(reference: reference);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ForeignKey(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ForeignKey(...).copyWith(id: 12, name: "My name")
  /// ````
  ForeignKey call({
    Object? columns = const $CopyWithPlaceholder(),
    Object? reference = const $CopyWithPlaceholder(),
  }) {
    return ForeignKey(
      columns == const $CopyWithPlaceholder() || columns == null
          ? _value.columns
          // ignore: cast_nullable_to_non_nullable
          : columns as List<String>,
      reference == const $CopyWithPlaceholder() || reference == null
          ? _value.reference
          // ignore: cast_nullable_to_non_nullable
          : reference as ForeignKeyReference,
    );
  }
}

extension $ForeignKeyCopyWith on ForeignKey {
  /// Returns a callable class that can be used as follows: `instanceOfForeignKey.copyWith(...)` or like so:`instanceOfForeignKey.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ForeignKeyCWProxy get copyWith => _$ForeignKeyCWProxyImpl(this);
}

abstract class _$ForeignKeyReferenceCWProxy {
  ForeignKeyReference table(String table);

  ForeignKeyReference uniqueKey(String? uniqueKey);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ForeignKeyReference(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ForeignKeyReference(...).copyWith(id: 12, name: "My name")
  /// ````
  ForeignKeyReference call({
    String? table,
    String? uniqueKey,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfForeignKeyReference.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfForeignKeyReference.copyWith.fieldName(...)`
class _$ForeignKeyReferenceCWProxyImpl implements _$ForeignKeyReferenceCWProxy {
  const _$ForeignKeyReferenceCWProxyImpl(this._value);

  final ForeignKeyReference _value;

  @override
  ForeignKeyReference table(String table) => this(table: table);

  @override
  ForeignKeyReference uniqueKey(String? uniqueKey) =>
      this(uniqueKey: uniqueKey);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ForeignKeyReference(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ForeignKeyReference(...).copyWith(id: 12, name: "My name")
  /// ````
  ForeignKeyReference call({
    Object? table = const $CopyWithPlaceholder(),
    Object? uniqueKey = const $CopyWithPlaceholder(),
  }) {
    return ForeignKeyReference(
      table == const $CopyWithPlaceholder() || table == null
          ? _value.table
          // ignore: cast_nullable_to_non_nullable
          : table as String,
      uniqueKey: uniqueKey == const $CopyWithPlaceholder()
          ? _value.uniqueKey
          // ignore: cast_nullable_to_non_nullable
          : uniqueKey as String?,
    );
  }
}

extension $ForeignKeyReferenceCopyWith on ForeignKeyReference {
  /// Returns a callable class that can be used as follows: `instanceOfForeignKeyReference.copyWith(...)` or like so:`instanceOfForeignKeyReference.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ForeignKeyReferenceCWProxy get copyWith =>
      _$ForeignKeyReferenceCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TableSchema _$TableSchemaFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    allowedKeys: const [
      'description',
      'headers',
      'columns',
      'primary_key',
      'unique_key',
      'foreign_key'
    ],
  );
  return TableSchema(
    description: json['description'] as String? ?? "",
    headers: (json['headers'] as List<dynamic>?)
            ?.map((e) => (e as List<dynamic>).map((e) => e as String).toList())
            .toList() ??
        const [],
    columns: (json['columns'] as List<dynamic>)
        .map((e) => Column.fromJson(e as Map<String, dynamic>))
        .toList(),
    primaryKey:
        (json['primary_key'] as List<dynamic>).map((e) => e as String).toList(),
    uniqueKey: (json['unique_key'] as Map<String, dynamic>?)?.map(
          (k, e) => MapEntry(
              k, (e as List<dynamic>).map((e) => e as String).toList()),
        ) ??
        const {},
    foreignKey: (json['foreign_key'] as Map<String, dynamic>?)?.map(
          (k, e) => MapEntry(k, ForeignKey.fromJson(e as Map<String, dynamic>)),
        ) ??
        const {},
  );
}

Map<String, dynamic> _$TableSchemaToJson(TableSchema instance) =>
    <String, dynamic>{
      'description': instance.description,
      'headers': instance.headers,
      'columns': instance.columns.map((e) => e.toJson()).toList(),
      'primary_key': instance.primaryKey,
      'unique_key': instance.uniqueKey,
      'foreign_key': instance.foreignKey.map((k, e) => MapEntry(k, e.toJson())),
    };

Column _$ColumnFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    allowedKeys: const ['name', 'description', 'allow_empty', 'type', 'regex'],
  );
  return Column(
    json['name'] as String,
    description: json['description'] as String? ?? "",
    allowEmpty: json['allow_empty'] as bool? ?? false,
    type: json['type'] as String?,
    regex: json['regex'] as String?,
  );
}

Map<String, dynamic> _$ColumnToJson(Column instance) => <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'allow_empty': instance.allowEmpty,
      'type': instance.type,
      'regex': instance.regex,
    };

ForeignKey _$ForeignKeyFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    allowedKeys: const ['columns', 'reference'],
  );
  return ForeignKey(
    (json['columns'] as List<dynamic>).map((e) => e as String).toList(),
    ForeignKeyReference.fromJson(json['reference'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$ForeignKeyToJson(ForeignKey instance) =>
    <String, dynamic>{
      'columns': instance.columns,
      'reference': instance.reference.toJson(),
    };

ForeignKeyReference _$ForeignKeyReferenceFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    allowedKeys: const ['table', 'unique_key'],
  );
  return ForeignKeyReference(
    json['table'] as String,
    uniqueKey: json['unique_key'] as String?,
  );
}

Map<String, dynamic> _$ForeignKeyReferenceToJson(
        ForeignKeyReference instance) =>
    <String, dynamic>{
      'table': instance.table,
      'unique_key': instance.uniqueKey,
    };
