import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:csv_armor/csv/armor/schema/error.dart';
import 'package:csv_armor/csv/armor/schema/field_type.dart';
import 'package:csv_armor/csv/armor/schema/schema_validator.dart';
import 'package:csv_armor/csv/field_quote.dart';
import 'package:csv_armor/csv/field_separator.dart';
import 'package:csv_armor/csv/record_separator.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:yaml/yaml.dart';

part 'schema.g.dart';

@CopyWith()
@JsonSerializable(disallowUnrecognizedKeys: true, explicitToJson: true)
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
    _validateSchema(this);
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
        "failed to decode YAML",
        schemaErrorYamlEncodeFailure,
        "",
        cause: e,
      );
    }

    final validation = getSchemaValidator().validate(json);
    if (!validation.isValid) {
      throw SchemaException(
        "failed to validate schema",
        schemaErrorSchemaValidationFailure,
        "",
        cause: validation.errors,
      );
    }

    return Schema.fromJson(json as Map<String, dynamic>);
  }

  factory Schema.fromJson(Map<String, dynamic> json) =>
      _tryFromJSON(() => _$SchemaFromJson(json));

  Map<String, dynamic> toJson() => _$SchemaToJson(this);

  Map<String, int> columnIndex() =>
      {for (final (i, c) in columns.indexed) c.name: i};

  @override
  bool operator ==(Object other) =>
      other is Schema &&
      const DeepCollectionEquality().equals(toJson(), other.toJson());

  @override
  int get hashCode => const DeepCollectionEquality().hash(toJson());

  _$SchemaCWProxy get copyWith => _$SchemaCWProxyImpl(this);
}

@CopyWith()
@JsonSerializable(disallowUnrecognizedKeys: true, explicitToJson: true)
class Column {
  Column(
    this.name, {
    this.allowEmpty = false,
    this.type = FieldType.text,
    this.regex,
  });

  @JsonKey(name: "name")
  final String name;
  @JsonKey(name: "allow_empty")
  final bool allowEmpty;
  @JsonKey(name: "type")
  final FieldType type;
  @JsonKey(name: "regex")
  final String? regex;

  factory Column.fromJson(Map<String, dynamic> json) =>
      _tryFromJSON(() => _$ColumnFromJson(json));

  Map<String, dynamic> toJson() => _$ColumnToJson(this);

  @override
  bool operator ==(Object other) =>
      other is Column &&
      const DeepCollectionEquality().equals(toJson(), other.toJson());

  @override
  int get hashCode => const DeepCollectionEquality().hash(toJson());

  _$ColumnCWProxy get copyWith => _$ColumnCWProxyImpl(this);
}

@CopyWith()
@JsonSerializable(disallowUnrecognizedKeys: true, explicitToJson: true)
class ForeignKey {
  ForeignKey(this.columns, this.reference);

  @JsonKey(name: "columns")
  final List<String> columns;
  @JsonKey(name: "reference")
  final ForeignKeyReference reference;

  factory ForeignKey.fromJson(Map<String, dynamic> json) =>
      _tryFromJSON(() => _$ForeignKeyFromJson(json));

  Map<String, dynamic> toJson() => _$ForeignKeyToJson(this);

  @override
  bool operator ==(Object other) =>
      other is ForeignKey &&
      const DeepCollectionEquality().equals(toJson(), other.toJson());

  @override
  int get hashCode => const DeepCollectionEquality().hash(toJson());

  _$ForeignKeyCWProxy get copyWith => _$ForeignKeyCWProxyImpl(this);
}

@CopyWith()
@JsonSerializable(disallowUnrecognizedKeys: true, explicitToJson: true)
class ForeignKeyReference {
  ForeignKeyReference(this.schemaPath, this.columns);

  @JsonKey(name: "schema_path")
  final String schemaPath;
  @JsonKey(name: "columns")
  final List<String> columns;

  factory ForeignKeyReference.fromJson(Map<String, dynamic> json) =>
      _tryFromJSON(() => _$ForeignKeyReferenceFromJson(json));

  Map<String, dynamic> toJson() => _$ForeignKeyReferenceToJson(this);

  @override
  bool operator ==(Object other) =>
      other is ForeignKeyReference &&
      const DeepCollectionEquality().equals(toJson(), other.toJson());

  @override
  int get hashCode => const DeepCollectionEquality().hash(toJson());

  _$ForeignKeyReferenceCWProxy get copyWith =>
      _$ForeignKeyReferenceCWProxyImpl(this);
}

T _tryFromJSON<T>(T Function() fromJson) {
  try {
    return fromJson();
  } on SchemaException {
    rethrow;
  } catch (e) {
    throw SchemaException(
      "failed to decode ${T.runtimeType} form YAML",
      schemaErrorYamlEncodeFailure,
      "",
      cause: e,
    );
  }
}

void _validateSchema(Schema schema) {
  // validate columns
  if (schema.columns.isEmpty) {
    throw SchemaException(
      "empty columns not allowed",
      schemaErrorEmptyColumns,
      schema.name ?? "<unknown>",
    );
  }
  final columnNameSet = <String, int>{};
  for (final column in schema.columns) {
    columnNameSet.update(column.name, (n) => n + 1, ifAbsent: () => 1);
  }
  for (final (i, column) in schema.columns.indexed) {
    if ((columnNameSet[column.name] ?? 0) > 1) {
      throw SchemaException(
        "duplicate column name not allowed",
        schemaErrorDuplicatedColumnName,
        "${schema.name ?? "<unknown>"}[$i]",
      );
    }
    if (column.name == "") {
      throw SchemaException(
        "empty column name not allowed",
        schemaErrorEmptyColumnName,
        "${schema.name ?? "<unknown>"}[$i]",
      );
    }

    if (column.regex != null) {
      try {
        RegExp(column.regex!);
      } catch (e) {
        throw SchemaException(
          "invalid formatRegex",
          schemaErrorInvalidColumnFormatRegex,
          "${schema.name ?? "<unknown>"}[$i] (${column.name})",
          cause: e,
        );
      }
    }
  }

  // validate primaryKey
  if (schema.primaryKey.isEmpty) {
    throw SchemaException(
      "empty primaryKey column not allowed",
      schemaErrorEmptyPrimaryKeyColumn,
      schema.name ?? "<unknown>",
    );
  }
  if (!schema.primaryKey.every(columnNameSet.containsKey)) {
    throw SchemaException(
      "primaryKey column not in columns",
      schemaErrorPrimaryKeyNotInColumns,
      schema.name ?? "<unknown>",
    );
  }

  // validate uniqueKey
  schema.uniqueKey.forEach((ukName, uk) {
    if (uk.isEmpty) {
      throw SchemaException(
        "empty uniqueKey column not allowed",
        schemaErrorEmptyUniqueKeyColumn,
        "${schema.name ?? ""}[${ukName}]",
      );
    }
    if (!uk.every(columnNameSet.containsKey)) {
      throw SchemaException(
        "uniqueKey column not in columns",
        schemaErrorUniqueKeyNotInColumns,
        "${schema.name ?? ""}[${ukName}]",
      );
    }
  });

  // validate foreignKey
  schema.foreignKey.forEach((fkName, fk) {
    if (fk.columns.isEmpty) {
      throw SchemaException(
        "empty foreignKey referencing column not allowed",
        schemaErrorEmptyForeignKeyBaseColumn,
        "${schema.name ?? ""}[${fkName}]",
      );
    }
    if (!fk.columns.every(columnNameSet.containsKey)) {
      throw SchemaException(
        "uniqueKey column not in columns",
        schemaErrorForeignKeyReferenceColumnNotInColumns,
        "${schema.name ?? ""}[${fkName}]",
      );
    }
    if (fk.columns.length != fk.reference.columns.length) {
      throw SchemaException(
        "foreign key columns and reference columns must have the same length",
        schemaErrorForeignKeyColumnCountMismatch,
        "${schema.name ?? ""}[${fkName}]",
      );
    }
  });
}
