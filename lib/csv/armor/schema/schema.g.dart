// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schema.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Schema _$SchemaFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    allowedKeys: const [
      'name',
      'csv_path',
      'field_separator',
      'record_separator',
      'field_quote',
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
    fieldSeparator:
        $enumDecodeNullable(_$FieldSeparatorEnumMap, json['field_separator']) ??
            FieldSeparator.COMMA,
    recordSeparator: $enumDecodeNullable(
            _$RecordSeparatorEnumMap, json['record_separator']) ??
        RecordSeparator.CRLF,
    fieldQuote: $enumDecodeNullable(_$FieldQuoteEnumMap, json['field_quote']) ??
        FieldQuote.DQUOTE,
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
      'field_separator': _$FieldSeparatorEnumMap[instance.fieldSeparator]!,
      'record_separator': _$RecordSeparatorEnumMap[instance.recordSeparator]!,
      'field_quote': _$FieldQuoteEnumMap[instance.fieldQuote]!,
      'headers': instance.headers,
      'columns': instance.columns.map((e) => e.toJson()).toList(),
      'primary_key': instance.primaryKey,
      'unique_key': instance.uniqueKey,
      'foreign_key': instance.foreignKey.map((k, e) => MapEntry(k, e.toJson())),
    };

const _$FieldSeparatorEnumMap = {
  FieldSeparator.COMMA: 'COMMA',
  FieldSeparator.TAB: 'TAB',
};

const _$RecordSeparatorEnumMap = {
  RecordSeparator.ANY: 'ANY',
  RecordSeparator.CRLF: 'CRLF',
  RecordSeparator.LF: 'LF',
  RecordSeparator.CR: 'CR',
};

const _$FieldQuoteEnumMap = {
  FieldQuote.NONE: 'NONE',
  FieldQuote.DQUOTE: 'DQUOTE',
  FieldQuote.SQUOTE: 'SQUOTE',
};

Column _$ColumnFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    allowedKeys: const ['name', 'allow_empty', 'format_type', 'format_regex'],
  );
  return Column(
    json['name'] as String,
    allowEmpty: json['allow_empty'] as bool? ?? false,
    formatType: $enumDecodeNullable(_$FormatTypeEnumMap, json['format_type']) ??
        FormatType.text,
    formatRegex: json['format_regex'] as String?,
  );
}

Map<String, dynamic> _$ColumnToJson(Column instance) => <String, dynamic>{
      'name': instance.name,
      'allow_empty': instance.allowEmpty,
      'format_type': _$FormatTypeEnumMap[instance.formatType]!,
      'format_regex': instance.formatRegex,
    };

const _$FormatTypeEnumMap = {
  FormatType.datetime: 'datetime',
  FormatType.integer: 'integer',
  FormatType.decimal: 'decimal',
  FormatType.text: 'text',
  FormatType.boolean: 'boolean',
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
