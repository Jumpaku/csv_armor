import 'dart:convert';

import 'package:csv_armor/csv/decoder.dart';
import 'package:csv_armor/csv/schema/error.dart';
import 'package:csv_armor/csv/schema/schema_validator.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:yaml/yaml.dart';

part 'schema.g.dart';

enum FormatType { datetime, integer, decimal, text, boolean }

@JsonSerializable()
class Schema {
  Schema(
    this.csvPath,
    this.columns,
    this.primaryKey, {
    this.name,
    this.headers = 0,
    this.fieldSeparator = FieldSeparator.COMMA,
    this.recordSeparator = RecordSeparator.CRLF,
    this.fieldQuote = FieldQuote.DQUOTE,
    this.uniqueKey = const {},
    this.foreignKey = const {},
  }) {
    if (this.columns.isEmpty) {
      throw SchemaException(
          "empty columns not allowed", schemaErrorEmptyColumn, name ?? "");
    }
    for (final column in this.columns) {
      if (column.formatRegex != null) {
        try {
          RegExp(column.formatRegex!);
        } catch (e) {
          throw SchemaException("invalid formatRegex", schemaErrorInvalidColumnFormatRegex,
              (name ?? "") + " " + column.name,
              cause: e);
        }
      }
    }
    if (this.primaryKey.isEmpty) {
      throw SchemaException("empty primaryKey column not allowed",
          schemaErrorEmptyPrimaryKeyColumn, name ?? "");
    }
    for (final uk in uniqueKey.entries) {
      if (uk.value.isEmpty) {
        throw SchemaException("empty uniqueKey column not allowed",
            schemaErrorEmptyUniqueKeyColumn, (name ?? "") + " " + uk.key);
      }
    }
    for (final fk in foreignKey.entries) {
      if (fk.value.columns.isEmpty) {
        throw SchemaException(
            "empty foreignKey referencing column not allowed",
            schemaErrorEmptyForeignKeyReferencingColumn,
            (name ?? "") + " " + fk.key);
      }
      if (fk.value.reference.columns.isEmpty) {
        throw SchemaException(
            "empty foreignKey referenced column not allowed",
            schemaErrorEmptyForeignKeyReferencedColumn,
            (name ?? "") + " " + fk.key);
      }
    }
  }

  @JsonKey(name: "name")
  final String? name;
  @JsonKey(name: "csv_path")
  final String csvPath;
  @JsonKey(name: "field_separator")
  final FieldSeparator fieldSeparator;
  @JsonKey(name: "record_separator")
  final RecordSeparator recordSeparator;
  @JsonKey(name: "field_quote")
  final FieldQuote fieldQuote;
  @JsonKey(name: "headers")
  final int headers;
  @JsonKey(name: "columns")
  final List<Column> columns;
  @JsonKey(name: "primary_key")
  final List<String> primaryKey;
  @JsonKey(name: "unique_key")
  final Map<String, List<String>> uniqueKey;
  @JsonKey(name: "foreign_key")
  final Map<String, ForeignKey> foreignKey;

  factory Schema.load(String yaml) {
    dynamic json;
    try {
      json = jsonDecode(jsonEncode(loadYaml(yaml)));
    } catch (e) {
      throw SchemaException(
          "failed to decode YAML", schemaErrorYAMLLoadFailure, "",
          cause: e);
    }

    final validation = getSchemaValidator().validate(json);
    if (!validation.isValid) {
      throw SchemaException(
          "failed to validate schema", schemaErrorSchemaValidationFailure, "",
          cause: validation.errors);
    }

    return Schema.fromJson(json);
  }

  factory Schema.fromJson(Map<String, dynamic> json) => _$SchemaFromJson(json);

  Map<String, dynamic> toJson() => _$SchemaToJson(this);
}

@JsonSerializable()
class Column {
  Column(this.name,
      {this.allowEmpty = false, this.formatType, this.formatRegex});

  @JsonKey(name: "name")
  final String name;
  @JsonKey(name: "allow_empty")
  final bool allowEmpty;
  @JsonKey(name: "format_type")
  final FormatType? formatType;
  @JsonKey(name: "format_regex")
  final String? formatRegex;

  factory Column.fromJson(Map<String, dynamic> json) => _$ColumnFromJson(json);

  Map<String, dynamic> toJson() => _$ColumnToJson(this);
}

@JsonSerializable()
class ForeignKey {
  ForeignKey(this.columns, this.reference);

  @JsonKey(name: "columns")
  final List<String> columns;
  @JsonKey(name: "reference")
  final ForeignKeyReference reference;

  factory ForeignKey.fromJson(Map<String, dynamic> json) =>
      _$ForeignKeyFromJson(json);

  Map<String, dynamic> toJson() => _$ForeignKeyToJson(this);
}

@JsonSerializable()
class ForeignKeyReference {
  ForeignKeyReference(this.schemaPath, this.columns);

  @JsonKey(name: "schema_path")
  final String schemaPath;
  @JsonKey(name: "columns")
  final List<String> columns;

  factory ForeignKeyReference.fromJson(Map<String, dynamic> json) =>
      _$ForeignKeyReferenceFromJson(json);

  Map<String, dynamic> toJson() => _$ForeignKeyReferenceToJson(this);
}
