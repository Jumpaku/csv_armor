import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:csv_armor/csv/armor/schema/error.dart';
import 'package:json_annotation/json_annotation.dart';

part 'table_schema.g.dart';

@CopyWith()
@JsonSerializable(disallowUnrecognizedKeys: true, explicitToJson: true)
class TableSchema {
  @JsonKey(name: "description")
  final String description;
  @JsonKey(name: "headers")
  final List<List<String>> headers;
  @JsonKey(name: "columns")
  final List<Column> columns;
  @JsonKey(name: "primary_key")
  final List<String> primaryKey;
  @JsonKey(name: "unique_key")
  final Map<String, List<String>> uniqueKey;
  @JsonKey(name: "foreign_key")
  final Map<String, ForeignKey> foreignKey;

  TableSchema({
    this.description = "",
    this.headers = const [],
    required this.columns,
    required this.primaryKey,
    this.uniqueKey = const {},
    this.foreignKey = const {},
  }) {
    if (columns.isEmpty) {
      throw SchemaException("Table schema must have at least one column",
          schemaErrorEmptyColumn, "columns");
    }

    final columnSet = <String>{};
    for (final (idx, column) in columns.indexed) {
      if (columnSet.contains(column.name)) {
        throw SchemaException("Duplicate column name in table schema",
            schemaErrorDuplicatedColumn, "columns[$idx]=${column.name}");
      }
      columnSet.add(column.name);
    }

    if (primaryKey.isEmpty) {
      throw SchemaException("Table schema must have a primary key",
          schemaErrorEmptyPrimaryKey, "primary_key");
    }

    for (final (idx, key) in primaryKey.indexed) {
      if (!columns.any((c) => c.name == key)) {
        throw SchemaException("Primary key column not found in table schema",
            schemaErrorPrimaryKeyNotInColumns, "primary_key[$idx]=$key");
      }
    }

    for (final uk in uniqueKey.keys) {
      if (uniqueKey[uk]!.isEmpty) {
        throw SchemaException("Unique key must have at least one column",
            schemaErrorEmptyUniqueKey, "unique_key[$uk]");
      }
      for (final (idx, key) in uniqueKey[uk]!.indexed) {
        if (!columns.any((c) => c.name == key)) {
          throw SchemaException("Unique key column not found in table schema",
              schemaErrorUniqueKeyNotInColumns, "unique_key[$uk][$idx]=$key");
        }
      }
    }

    for (final fk in foreignKey.keys) {
      if (foreignKey[fk]!.columns.isEmpty) {
        throw SchemaException("Foreign key must have at least one column",
            schemaErrorEmptyForeignKey, "foreign_key[$fk].columns");
      }
      for (final (idx, key) in foreignKey[fk]!.columns.indexed) {
        if (!columns.any((c) => c.name == key)) {
          throw SchemaException("Foreign key column not found in table schema",
              schemaErrorForeignKeyNotInColumns, "foreign_key[$fk][$idx]=$key");
        }
      }
    }
  }

  factory TableSchema.fromJson(Map<String, dynamic> json) =>
      _$TableSchemaFromJson(json);

  Map<String, dynamic> toJson() => _$TableSchemaToJson(this);
}

@CopyWith()
@JsonSerializable(disallowUnrecognizedKeys: true, explicitToJson: true)
class Column {
  @JsonKey(name: "name")
  final String name;
  @JsonKey(name: "description")
  final String description;
  @JsonKey(name: "allow_empty")
  final bool allowEmpty;
  @JsonKey(name: "type")
  final String? type;
  @JsonKey(name: "regex")
  final String? regex;

  Column(
    this.name, {
    this.description = "",
    this.allowEmpty = false,
    this.type,
    this.regex,
  });

  factory Column.fromJson(Map<String, dynamic> json) => _$ColumnFromJson(json);

  Map<String, dynamic> toJson() => _$ColumnToJson(this);
}

@CopyWith()
@JsonSerializable(disallowUnrecognizedKeys: true, explicitToJson: true)
class ForeignKey {
  @JsonKey(name: "columns")
  final List<String> columns;
  @JsonKey(name: "reference")
  final ForeignKeyReference reference;

  ForeignKey(this.columns, this.reference);

  factory ForeignKey.fromJson(Map<String, dynamic> json) =>
      _$ForeignKeyFromJson(json);

  Map<String, dynamic> toJson() => _$ForeignKeyToJson(this);
}

@CopyWith()
@JsonSerializable(disallowUnrecognizedKeys: true, explicitToJson: true)
class ForeignKeyReference {
  @JsonKey(name: "table")
  final String table;
  @JsonKey(name: "unique_key")
  final String? uniqueKey;

  ForeignKeyReference(this.table, {this.uniqueKey});

  factory ForeignKeyReference.fromJson(Map<String, dynamic> json) =>
      _$ForeignKeyReferenceFromJson(json);

  Map<String, dynamic> toJson() => _$ForeignKeyReferenceToJson(this);
}
