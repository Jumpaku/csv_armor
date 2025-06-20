// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schema.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$SchemaCWProxy {
  Schema tableConfig(List<TableConfig> tableConfig);

  Schema columnType(Map<String, String> columnType);

  Schema validation(List<Validation> validation);

  Schema decodeConfig(DecodeConfig? decodeConfig);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Schema(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Schema(...).copyWith(id: 12, name: "My name")
  /// ````
  Schema call({
    List<TableConfig>? tableConfig,
    Map<String, String>? columnType,
    List<Validation>? validation,
    DecodeConfig? decodeConfig,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfSchema.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfSchema.copyWith.fieldName(...)`
class _$SchemaCWProxyImpl implements _$SchemaCWProxy {
  const _$SchemaCWProxyImpl(this._value);

  final Schema _value;

  @override
  Schema tableConfig(List<TableConfig> tableConfig) =>
      this(tableConfig: tableConfig);

  @override
  Schema columnType(Map<String, String> columnType) =>
      this(columnType: columnType);

  @override
  Schema validation(List<Validation> validation) =>
      this(validation: validation);

  @override
  Schema decodeConfig(DecodeConfig? decodeConfig) =>
      this(decodeConfig: decodeConfig);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Schema(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Schema(...).copyWith(id: 12, name: "My name")
  /// ````
  Schema call({
    Object? tableConfig = const $CopyWithPlaceholder(),
    Object? columnType = const $CopyWithPlaceholder(),
    Object? validation = const $CopyWithPlaceholder(),
    Object? decodeConfig = const $CopyWithPlaceholder(),
  }) {
    return Schema(
      tableConfig:
          tableConfig == const $CopyWithPlaceholder() || tableConfig == null
              ? _value.tableConfig
              // ignore: cast_nullable_to_non_nullable
              : tableConfig as List<TableConfig>,
      columnType:
          columnType == const $CopyWithPlaceholder() || columnType == null
              ? _value.columnType
              // ignore: cast_nullable_to_non_nullable
              : columnType as Map<String, String>,
      validation:
          validation == const $CopyWithPlaceholder() || validation == null
              ? _value.validation
              // ignore: cast_nullable_to_non_nullable
              : validation as List<Validation>,
      decodeConfig: decodeConfig == const $CopyWithPlaceholder()
          ? _value.decodeConfig
          // ignore: cast_nullable_to_non_nullable
          : decodeConfig as DecodeConfig?,
    );
  }
}

extension $SchemaCopyWith on Schema {
  /// Returns a callable class that can be used as follows: `instanceOfSchema.copyWith(...)` or like so:`instanceOfSchema.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$SchemaCWProxy get copyWith => _$SchemaCWProxyImpl(this);
}

abstract class _$TableConfigCWProxy {
  TableConfig import(String? import);

  TableConfig name(String name);

  TableConfig csvPath(String csvPath);

  TableConfig columns(List<TableColumn> columns);

  TableConfig primaryKey(List<String> primaryKey);

  TableConfig uniqueKey(Map<String, List<String>> uniqueKey);

  TableConfig foreignKey(Map<String, ForeignKey> foreignKey);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `TableConfig(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// TableConfig(...).copyWith(id: 12, name: "My name")
  /// ````
  TableConfig call({
    String? import,
    String? name,
    String? csvPath,
    List<TableColumn>? columns,
    List<String>? primaryKey,
    Map<String, List<String>>? uniqueKey,
    Map<String, ForeignKey>? foreignKey,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfTableConfig.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfTableConfig.copyWith.fieldName(...)`
class _$TableConfigCWProxyImpl implements _$TableConfigCWProxy {
  const _$TableConfigCWProxyImpl(this._value);

  final TableConfig _value;

  @override
  TableConfig import(String? import) => this(import: import);

  @override
  TableConfig name(String name) => this(name: name);

  @override
  TableConfig csvPath(String csvPath) => this(csvPath: csvPath);

  @override
  TableConfig columns(List<TableColumn> columns) => this(columns: columns);

  @override
  TableConfig primaryKey(List<String> primaryKey) =>
      this(primaryKey: primaryKey);

  @override
  TableConfig uniqueKey(Map<String, List<String>> uniqueKey) =>
      this(uniqueKey: uniqueKey);

  @override
  TableConfig foreignKey(Map<String, ForeignKey> foreignKey) =>
      this(foreignKey: foreignKey);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `TableConfig(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// TableConfig(...).copyWith(id: 12, name: "My name")
  /// ````
  TableConfig call({
    Object? import = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? csvPath = const $CopyWithPlaceholder(),
    Object? columns = const $CopyWithPlaceholder(),
    Object? primaryKey = const $CopyWithPlaceholder(),
    Object? uniqueKey = const $CopyWithPlaceholder(),
    Object? foreignKey = const $CopyWithPlaceholder(),
  }) {
    return TableConfig(
      import: import == const $CopyWithPlaceholder()
          ? _value.import
          // ignore: cast_nullable_to_non_nullable
          : import as String?,
      name: name == const $CopyWithPlaceholder() || name == null
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String,
      csvPath: csvPath == const $CopyWithPlaceholder() || csvPath == null
          ? _value.csvPath
          // ignore: cast_nullable_to_non_nullable
          : csvPath as String,
      columns: columns == const $CopyWithPlaceholder() || columns == null
          ? _value.columns
          // ignore: cast_nullable_to_non_nullable
          : columns as List<TableColumn>,
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

extension $TableConfigCopyWith on TableConfig {
  /// Returns a callable class that can be used as follows: `instanceOfTableConfig.copyWith(...)` or like so:`instanceOfTableConfig.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$TableConfigCWProxy get copyWith => _$TableConfigCWProxyImpl(this);
}

abstract class _$TableColumnCWProxy {
  TableColumn name(String name);

  TableColumn description(String? description);

  TableColumn allowEmpty(bool allowEmpty);

  TableColumn type(String? type);

  TableColumn regexp(String? regexp);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `TableColumn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// TableColumn(...).copyWith(id: 12, name: "My name")
  /// ````
  TableColumn call({
    String? name,
    String? description,
    bool? allowEmpty,
    String? type,
    String? regexp,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfTableColumn.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfTableColumn.copyWith.fieldName(...)`
class _$TableColumnCWProxyImpl implements _$TableColumnCWProxy {
  const _$TableColumnCWProxyImpl(this._value);

  final TableColumn _value;

  @override
  TableColumn name(String name) => this(name: name);

  @override
  TableColumn description(String? description) =>
      this(description: description);

  @override
  TableColumn allowEmpty(bool allowEmpty) => this(allowEmpty: allowEmpty);

  @override
  TableColumn type(String? type) => this(type: type);

  @override
  TableColumn regexp(String? regexp) => this(regexp: regexp);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `TableColumn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// TableColumn(...).copyWith(id: 12, name: "My name")
  /// ````
  TableColumn call({
    Object? name = const $CopyWithPlaceholder(),
    Object? description = const $CopyWithPlaceholder(),
    Object? allowEmpty = const $CopyWithPlaceholder(),
    Object? type = const $CopyWithPlaceholder(),
    Object? regexp = const $CopyWithPlaceholder(),
  }) {
    return TableColumn(
      name: name == const $CopyWithPlaceholder() || name == null
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String,
      description: description == const $CopyWithPlaceholder()
          ? _value.description
          // ignore: cast_nullable_to_non_nullable
          : description as String?,
      allowEmpty:
          allowEmpty == const $CopyWithPlaceholder() || allowEmpty == null
              ? _value.allowEmpty
              // ignore: cast_nullable_to_non_nullable
              : allowEmpty as bool,
      type: type == const $CopyWithPlaceholder()
          ? _value.type
          // ignore: cast_nullable_to_non_nullable
          : type as String?,
      regexp: regexp == const $CopyWithPlaceholder()
          ? _value.regexp
          // ignore: cast_nullable_to_non_nullable
          : regexp as String?,
    );
  }
}

extension $TableColumnCopyWith on TableColumn {
  /// Returns a callable class that can be used as follows: `instanceOfTableColumn.copyWith(...)` or like so:`instanceOfTableColumn.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$TableColumnCWProxy get copyWith => _$TableColumnCWProxyImpl(this);
}

abstract class _$ForeignKeyCWProxy {
  ForeignKey columns(List<String> columns);

  ForeignKey reference(ForeignKeyReference reference);

  ForeignKey ignoreEmpty(bool ignoreEmpty);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ForeignKey(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ForeignKey(...).copyWith(id: 12, name: "My name")
  /// ````
  ForeignKey call({
    List<String>? columns,
    ForeignKeyReference? reference,
    bool? ignoreEmpty,
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
  ForeignKey ignoreEmpty(bool ignoreEmpty) => this(ignoreEmpty: ignoreEmpty);

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
    Object? ignoreEmpty = const $CopyWithPlaceholder(),
  }) {
    return ForeignKey(
      columns: columns == const $CopyWithPlaceholder() || columns == null
          ? _value.columns
          // ignore: cast_nullable_to_non_nullable
          : columns as List<String>,
      reference: reference == const $CopyWithPlaceholder() || reference == null
          ? _value.reference
          // ignore: cast_nullable_to_non_nullable
          : reference as ForeignKeyReference,
      ignoreEmpty:
          ignoreEmpty == const $CopyWithPlaceholder() || ignoreEmpty == null
              ? _value.ignoreEmpty
              // ignore: cast_nullable_to_non_nullable
              : ignoreEmpty as bool,
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
      table: table == const $CopyWithPlaceholder() || table == null
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

abstract class _$ValidationCWProxy {
  Validation import(String? import);

  Validation message(String message);

  Validation validationQuery(String validationQuery);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Validation(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Validation(...).copyWith(id: 12, name: "My name")
  /// ````
  Validation call({
    String? import,
    String? message,
    String? validationQuery,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfValidation.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfValidation.copyWith.fieldName(...)`
class _$ValidationCWProxyImpl implements _$ValidationCWProxy {
  const _$ValidationCWProxyImpl(this._value);

  final Validation _value;

  @override
  Validation import(String? import) => this(import: import);

  @override
  Validation message(String message) => this(message: message);

  @override
  Validation validationQuery(String validationQuery) =>
      this(validationQuery: validationQuery);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Validation(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Validation(...).copyWith(id: 12, name: "My name")
  /// ````
  Validation call({
    Object? import = const $CopyWithPlaceholder(),
    Object? message = const $CopyWithPlaceholder(),
    Object? validationQuery = const $CopyWithPlaceholder(),
  }) {
    return Validation(
      import: import == const $CopyWithPlaceholder()
          ? _value.import
          // ignore: cast_nullable_to_non_nullable
          : import as String?,
      message: message == const $CopyWithPlaceholder() || message == null
          ? _value.message
          // ignore: cast_nullable_to_non_nullable
          : message as String,
      validationQuery: validationQuery == const $CopyWithPlaceholder() ||
              validationQuery == null
          ? _value.validationQuery
          // ignore: cast_nullable_to_non_nullable
          : validationQuery as String,
    );
  }
}

extension $ValidationCopyWith on Validation {
  /// Returns a callable class that can be used as follows: `instanceOfValidation.copyWith(...)` or like so:`instanceOfValidation.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ValidationCWProxy get copyWith => _$ValidationCWProxyImpl(this);
}

abstract class _$DecodeConfigCWProxy {
  DecodeConfig headerLines(int? headerLines);

  DecodeConfig recordSeparator(RecordSeparator? recordSeparator);

  DecodeConfig fieldSeparator(String? fieldSeparator);

  DecodeConfig fieldQuote(FieldQuote? fieldQuote);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DecodeConfig(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DecodeConfig(...).copyWith(id: 12, name: "My name")
  /// ````
  DecodeConfig call({
    int? headerLines,
    RecordSeparator? recordSeparator,
    String? fieldSeparator,
    FieldQuote? fieldQuote,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfDecodeConfig.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfDecodeConfig.copyWith.fieldName(...)`
class _$DecodeConfigCWProxyImpl implements _$DecodeConfigCWProxy {
  const _$DecodeConfigCWProxyImpl(this._value);

  final DecodeConfig _value;

  @override
  DecodeConfig headerLines(int? headerLines) => this(headerLines: headerLines);

  @override
  DecodeConfig recordSeparator(RecordSeparator? recordSeparator) =>
      this(recordSeparator: recordSeparator);

  @override
  DecodeConfig fieldSeparator(String? fieldSeparator) =>
      this(fieldSeparator: fieldSeparator);

  @override
  DecodeConfig fieldQuote(FieldQuote? fieldQuote) =>
      this(fieldQuote: fieldQuote);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DecodeConfig(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DecodeConfig(...).copyWith(id: 12, name: "My name")
  /// ````
  DecodeConfig call({
    Object? headerLines = const $CopyWithPlaceholder(),
    Object? recordSeparator = const $CopyWithPlaceholder(),
    Object? fieldSeparator = const $CopyWithPlaceholder(),
    Object? fieldQuote = const $CopyWithPlaceholder(),
  }) {
    return DecodeConfig(
      headerLines: headerLines == const $CopyWithPlaceholder()
          ? _value.headerLines
          // ignore: cast_nullable_to_non_nullable
          : headerLines as int?,
      recordSeparator: recordSeparator == const $CopyWithPlaceholder()
          ? _value.recordSeparator
          // ignore: cast_nullable_to_non_nullable
          : recordSeparator as RecordSeparator?,
      fieldSeparator: fieldSeparator == const $CopyWithPlaceholder()
          ? _value.fieldSeparator
          // ignore: cast_nullable_to_non_nullable
          : fieldSeparator as String?,
      fieldQuote: fieldQuote == const $CopyWithPlaceholder()
          ? _value.fieldQuote
          // ignore: cast_nullable_to_non_nullable
          : fieldQuote as FieldQuote?,
    );
  }
}

extension $DecodeConfigCopyWith on DecodeConfig {
  /// Returns a callable class that can be used as follows: `instanceOfDecodeConfig.copyWith(...)` or like so:`instanceOfDecodeConfig.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$DecodeConfigCWProxy get copyWith => _$DecodeConfigCWProxyImpl(this);
}

abstract class _$FieldQuoteCWProxy {
  FieldQuote left(String? left);

  FieldQuote leftEscape(String? leftEscape);

  FieldQuote right(String? right);

  FieldQuote rightEscape(String? rightEscape);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `FieldQuote(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// FieldQuote(...).copyWith(id: 12, name: "My name")
  /// ````
  FieldQuote call({
    String? left,
    String? leftEscape,
    String? right,
    String? rightEscape,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfFieldQuote.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfFieldQuote.copyWith.fieldName(...)`
class _$FieldQuoteCWProxyImpl implements _$FieldQuoteCWProxy {
  const _$FieldQuoteCWProxyImpl(this._value);

  final FieldQuote _value;

  @override
  FieldQuote left(String? left) => this(left: left);

  @override
  FieldQuote leftEscape(String? leftEscape) => this(leftEscape: leftEscape);

  @override
  FieldQuote right(String? right) => this(right: right);

  @override
  FieldQuote rightEscape(String? rightEscape) => this(rightEscape: rightEscape);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `FieldQuote(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// FieldQuote(...).copyWith(id: 12, name: "My name")
  /// ````
  FieldQuote call({
    Object? left = const $CopyWithPlaceholder(),
    Object? leftEscape = const $CopyWithPlaceholder(),
    Object? right = const $CopyWithPlaceholder(),
    Object? rightEscape = const $CopyWithPlaceholder(),
  }) {
    return FieldQuote(
      left: left == const $CopyWithPlaceholder()
          ? _value.left
          // ignore: cast_nullable_to_non_nullable
          : left as String?,
      leftEscape: leftEscape == const $CopyWithPlaceholder()
          ? _value.leftEscape
          // ignore: cast_nullable_to_non_nullable
          : leftEscape as String?,
      right: right == const $CopyWithPlaceholder()
          ? _value.right
          // ignore: cast_nullable_to_non_nullable
          : right as String?,
      rightEscape: rightEscape == const $CopyWithPlaceholder()
          ? _value.rightEscape
          // ignore: cast_nullable_to_non_nullable
          : rightEscape as String?,
    );
  }
}

extension $FieldQuoteCopyWith on FieldQuote {
  /// Returns a callable class that can be used as follows: `instanceOfFieldQuote.copyWith(...)` or like so:`instanceOfFieldQuote.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$FieldQuoteCWProxy get copyWith => _$FieldQuoteCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Schema _$SchemaFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    allowedKeys: const [
      'table_config',
      'column_type',
      'validation',
      'decode_config'
    ],
  );
  return Schema(
    tableConfig: (json['table_config'] as List<dynamic>?)
            ?.map((e) => TableConfig.fromJson(e as Map<String, dynamic>))
            .toList() ??
        const [],
    columnType: (json['column_type'] as Map<String, dynamic>?)?.map(
          (k, e) => MapEntry(k, e as String),
        ) ??
        const {},
    validation: (json['validation'] as List<dynamic>?)
            ?.map((e) => Validation.fromJson(e as Map<String, dynamic>))
            .toList() ??
        const [],
    decodeConfig: json['decode_config'] == null
        ? null
        : DecodeConfig.fromJson(json['decode_config'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$SchemaToJson(Schema instance) => <String, dynamic>{
      'table_config': instance.tableConfig.map((e) => e.toJson()).toList(),
      'column_type': instance.columnType,
      'validation': instance.validation.map((e) => e.toJson()).toList(),
      if (instance.decodeConfig?.toJson() case final value?)
        'decode_config': value,
    };

TableConfig _$TableConfigFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    allowedKeys: const [
      'import',
      'name',
      'csv_path',
      'columns',
      'primary_key',
      'unique_key',
      'foreign_key'
    ],
  );
  return TableConfig(
    import: json['import'] as String?,
    name: json['name'] as String? ?? '',
    csvPath: json['csv_path'] as String? ?? '',
    columns: (json['columns'] as List<dynamic>?)
            ?.map((e) => TableColumn.fromJson(e as Map<String, dynamic>))
            .toList() ??
        const [],
    primaryKey: (json['primary_key'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList() ??
        const [],
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

Map<String, dynamic> _$TableConfigToJson(TableConfig instance) =>
    <String, dynamic>{
      if (instance.import case final value?) 'import': value,
      'name': instance.name,
      'csv_path': instance.csvPath,
      'columns': instance.columns.map((e) => e.toJson()).toList(),
      'primary_key': instance.primaryKey,
      'unique_key': instance.uniqueKey,
      'foreign_key': instance.foreignKey.map((k, e) => MapEntry(k, e.toJson())),
    };

TableColumn _$TableColumnFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    allowedKeys: const ['name', 'description', 'allow_empty', 'type', 'regexp'],
  );
  return TableColumn(
    name: json['name'] as String,
    description: json['description'] as String?,
    allowEmpty: json['allow_empty'] as bool? ?? false,
    type: json['type'] as String?,
    regexp: json['regexp'] as String?,
  );
}

Map<String, dynamic> _$TableColumnToJson(TableColumn instance) =>
    <String, dynamic>{
      'name': instance.name,
      if (instance.description case final value?) 'description': value,
      'allow_empty': instance.allowEmpty,
      if (instance.type case final value?) 'type': value,
      if (instance.regexp case final value?) 'regexp': value,
    };

ForeignKey _$ForeignKeyFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    allowedKeys: const ['columns', 'reference', 'ignore_empty'],
  );
  return ForeignKey(
    columns:
        (json['columns'] as List<dynamic>).map((e) => e as String).toList(),
    reference:
        ForeignKeyReference.fromJson(json['reference'] as Map<String, dynamic>),
    ignoreEmpty: json['ignore_empty'] as bool? ?? false,
  );
}

Map<String, dynamic> _$ForeignKeyToJson(ForeignKey instance) =>
    <String, dynamic>{
      'columns': instance.columns,
      'reference': instance.reference.toJson(),
      'ignore_empty': instance.ignoreEmpty,
    };

ForeignKeyReference _$ForeignKeyReferenceFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    allowedKeys: const ['table', 'unique_key'],
  );
  return ForeignKeyReference(
    table: json['table'] as String,
    uniqueKey: json['unique_key'] as String?,
  );
}

Map<String, dynamic> _$ForeignKeyReferenceToJson(
        ForeignKeyReference instance) =>
    <String, dynamic>{
      'table': instance.table,
      if (instance.uniqueKey case final value?) 'unique_key': value,
    };

Validation _$ValidationFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    allowedKeys: const ['import', 'message', 'validation_query'],
  );
  return Validation(
    import: json['import'] as String?,
    message: json['message'] as String? ?? '',
    validationQuery: json['validation_query'] as String? ?? '',
  );
}

Map<String, dynamic> _$ValidationToJson(Validation instance) =>
    <String, dynamic>{
      if (instance.import case final value?) 'import': value,
      'message': instance.message,
      'validation_query': instance.validationQuery,
    };

DecodeConfig _$DecodeConfigFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    allowedKeys: const [
      'import',
      'header_lines',
      'record_separator',
      'field_separator',
      'field_quote'
    ],
  );
  return DecodeConfig(
    headerLines: (json['header_lines'] as num?)?.toInt(),
    recordSeparator:
        $enumDecodeNullable(_$RecordSeparatorEnumMap, json['record_separator']),
    fieldSeparator: json['field_separator'] as String?,
    fieldQuote: json['field_quote'] == null
        ? null
        : FieldQuote.fromJson(json['field_quote'] as Map<String, dynamic>),
  )..import = json['import'] as String?;
}

Map<String, dynamic> _$DecodeConfigToJson(DecodeConfig instance) =>
    <String, dynamic>{
      if (instance.import case final value?) 'import': value,
      if (instance.headerLines case final value?) 'header_lines': value,
      if (_$RecordSeparatorEnumMap[instance.recordSeparator] case final value?)
        'record_separator': value,
      if (instance.fieldSeparator case final value?) 'field_separator': value,
      if (instance.fieldQuote?.toJson() case final value?) 'field_quote': value,
    };

const _$RecordSeparatorEnumMap = {
  RecordSeparator.CRLF: 'CRLF',
  RecordSeparator.LF: 'LF',
  RecordSeparator.CR: 'CR',
  RecordSeparator.ANY: 'ANY',
};

FieldQuote _$FieldQuoteFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    allowedKeys: const ['left', 'left_escape', 'right', 'right_escape'],
  );
  return FieldQuote(
    left: json['left'] as String?,
    leftEscape: json['left_escape'] as String?,
    right: json['right'] as String?,
    rightEscape: json['right_escape'] as String?,
  );
}

Map<String, dynamic> _$FieldQuoteToJson(FieldQuote instance) =>
    <String, dynamic>{
      if (instance.left case final value?) 'left': value,
      if (instance.leftEscape case final value?) 'left_escape': value,
      if (instance.right case final value?) 'right': value,
      if (instance.rightEscape case final value?) 'right_escape': value,
    };
