// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schema.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$SchemaCWProxy {
  Schema csvPath(String csvPath);

  Schema columns(List<Column> columns);

  Schema primaryKey(List<String> primaryKey);

  Schema name(String? name);

  Schema headers(int headers);

  Schema uniqueKey(Map<String, List<String>> uniqueKey);

  Schema foreignKey(Map<String, ForeignKey> foreignKey);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Schema(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Schema(...).copyWith(id: 12, name: "My name")
  /// ````
  Schema call({
    String? csvPath,
    List<Column>? columns,
    List<String>? primaryKey,
    String? name,
    int? headers,
    Map<String, List<String>>? uniqueKey,
    Map<String, ForeignKey>? foreignKey,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfSchema.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfSchema.copyWith.fieldName(...)`
class _$SchemaCWProxyImpl implements _$SchemaCWProxy {
  const _$SchemaCWProxyImpl(this._value);

  final Schema _value;

  @override
  Schema csvPath(String csvPath) => this(csvPath: csvPath);

  @override
  Schema columns(List<Column> columns) => this(columns: columns);

  @override
  Schema primaryKey(List<String> primaryKey) => this(primaryKey: primaryKey);

  @override
  Schema name(String? name) => this(name: name);

  @override
  Schema headers(int headers) => this(headers: headers);

  @override
  Schema uniqueKey(Map<String, List<String>> uniqueKey) =>
      this(uniqueKey: uniqueKey);

  @override
  Schema foreignKey(Map<String, ForeignKey> foreignKey) =>
      this(foreignKey: foreignKey);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Schema(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Schema(...).copyWith(id: 12, name: "My name")
  /// ````
  Schema call({
    Object? csvPath = const $CopyWithPlaceholder(),
    Object? columns = const $CopyWithPlaceholder(),
    Object? primaryKey = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? headers = const $CopyWithPlaceholder(),
    Object? uniqueKey = const $CopyWithPlaceholder(),
    Object? foreignKey = const $CopyWithPlaceholder(),
  }) {
    return Schema(
      csvPath == const $CopyWithPlaceholder() || csvPath == null
          ? _value.csvPath
          // ignore: cast_nullable_to_non_nullable
          : csvPath as String,
      columns == const $CopyWithPlaceholder() || columns == null
          ? _value.columns
          // ignore: cast_nullable_to_non_nullable
          : columns as List<Column>,
      primaryKey == const $CopyWithPlaceholder() || primaryKey == null
          ? _value.primaryKey
          // ignore: cast_nullable_to_non_nullable
          : primaryKey as List<String>,
      name: name == const $CopyWithPlaceholder()
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String?,
      headers: headers == const $CopyWithPlaceholder() || headers == null
          ? _value.headers
          // ignore: cast_nullable_to_non_nullable
          : headers as int,
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

extension $SchemaCopyWith on Schema {
  /// Returns a callable class that can be used as follows: `instanceOfSchema.copyWith(...)` or like so:`instanceOfSchema.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$SchemaCWProxy get copyWith => _$SchemaCWProxyImpl(this);
}

abstract class _$ColumnCWProxy {
  Column name(String name);

  Column allowEmpty(bool allowEmpty);

  Column type(FieldType type);

  Column regex(String? regex);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Column(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Column(...).copyWith(id: 12, name: "My name")
  /// ````
  Column call({
    String? name,
    bool? allowEmpty,
    FieldType? type,
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
  Column allowEmpty(bool allowEmpty) => this(allowEmpty: allowEmpty);

  @override
  Column type(FieldType type) => this(type: type);

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
    Object? allowEmpty = const $CopyWithPlaceholder(),
    Object? type = const $CopyWithPlaceholder(),
    Object? regex = const $CopyWithPlaceholder(),
  }) {
    return Column(
      name == const $CopyWithPlaceholder() || name == null
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String,
      allowEmpty:
          allowEmpty == const $CopyWithPlaceholder() || allowEmpty == null
              ? _value.allowEmpty
              // ignore: cast_nullable_to_non_nullable
              : allowEmpty as bool,
      type: type == const $CopyWithPlaceholder() || type == null
          ? _value.type
          // ignore: cast_nullable_to_non_nullable
          : type as FieldType,
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
  ForeignKeyReference schemaPath(String schemaPath);

  ForeignKeyReference columns(List<String> columns);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ForeignKeyReference(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ForeignKeyReference(...).copyWith(id: 12, name: "My name")
  /// ````
  ForeignKeyReference call({
    String? schemaPath,
    List<String>? columns,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfForeignKeyReference.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfForeignKeyReference.copyWith.fieldName(...)`
class _$ForeignKeyReferenceCWProxyImpl implements _$ForeignKeyReferenceCWProxy {
  const _$ForeignKeyReferenceCWProxyImpl(this._value);

  final ForeignKeyReference _value;

  @override
  ForeignKeyReference schemaPath(String schemaPath) =>
      this(schemaPath: schemaPath);

  @override
  ForeignKeyReference columns(List<String> columns) => this(columns: columns);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ForeignKeyReference(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ForeignKeyReference(...).copyWith(id: 12, name: "My name")
  /// ````
  ForeignKeyReference call({
    Object? schemaPath = const $CopyWithPlaceholder(),
    Object? columns = const $CopyWithPlaceholder(),
  }) {
    return ForeignKeyReference(
      schemaPath == const $CopyWithPlaceholder() || schemaPath == null
          ? _value.schemaPath
          // ignore: cast_nullable_to_non_nullable
          : schemaPath as String,
      columns == const $CopyWithPlaceholder() || columns == null
          ? _value.columns
          // ignore: cast_nullable_to_non_nullable
          : columns as List<String>,
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

Schema _$SchemaFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    allowedKeys: const [
      'name',
      'csv_path',
      'headers',
      'columns',
      'primary_key',
      'unique_key',
      'foreign_key'
    ],
  );
  return Schema(
    json['csv_path'] as String,
    (json['columns'] as List<dynamic>)
        .map((e) => Column.fromJson(e as Map<String, dynamic>))
        .toList(),
    (json['primary_key'] as List<dynamic>).map((e) => e as String).toList(),
    name: json['name'] as String?,
    headers: (json['headers'] as num?)?.toInt() ?? 0,
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

Map<String, dynamic> _$SchemaToJson(Schema instance) => <String, dynamic>{
      'name': instance.name,
      'csv_path': instance.csvPath,
      'headers': instance.headers,
      'columns': instance.columns.map((e) => e.toJson()).toList(),
      'primary_key': instance.primaryKey,
      'unique_key': instance.uniqueKey,
      'foreign_key': instance.foreignKey.map((k, e) => MapEntry(k, e.toJson())),
    };

Column _$ColumnFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    allowedKeys: const ['name', 'allow_empty', 'type', 'regex'],
  );
  return Column(
    json['name'] as String,
    allowEmpty: json['allow_empty'] as bool? ?? false,
    type:
        $enumDecodeNullable(_$FieldTypeEnumMap, json['type']) ?? FieldType.text,
    regex: json['regex'] as String?,
  );
}

Map<String, dynamic> _$ColumnToJson(Column instance) => <String, dynamic>{
      'name': instance.name,
      'allow_empty': instance.allowEmpty,
      'type': _$FieldTypeEnumMap[instance.type]!,
      'regex': instance.regex,
    };

const _$FieldTypeEnumMap = {
  FieldType.text: 'text',
  FieldType.integer: 'integer',
  FieldType.boolean: 'boolean',
  FieldType.datetime: 'datetime',
  FieldType.decimal: 'decimal',
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
    allowedKeys: const ['schema_path', 'columns'],
  );
  return ForeignKeyReference(
    json['schema_path'] as String,
    (json['columns'] as List<dynamic>).map((e) => e as String).toList(),
  );
}

Map<String, dynamic> _$ForeignKeyReferenceToJson(
        ForeignKeyReference instance) =>
    <String, dynamic>{
      'schema_path': instance.schemaPath,
      'columns': instance.columns,
    };
