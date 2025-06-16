import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'schema.g.dart';

/// Represents a CSV Armor Schema with table configurations, column types, and validation rules
@CopyWith()
@JsonSerializable(
    disallowUnrecognizedKeys: true, explicitToJson: true, includeIfNull: false)
class Schema {
  Schema({
    this.tableConfig = const [],
    this.columnType = const {},
    this.validation = const [],
    this.decodeConfig,
  });

  @JsonKey(name: 'table_config')
  List<TableConfig> tableConfig; // Can be TableConfig or import path
  @JsonKey(name: 'column_type')
  Map<String, String> columnType;
  @JsonKey(name: 'validation')
  List<Validation> validation; // Can be Validation or import path
  @JsonKey(name: 'decode_config')
  DecodeConfig? decodeConfig;

  factory Schema.fromJson(Map<String, dynamic> json) => _$SchemaFromJson(json);

  Map<String, dynamic> toJson() => _$SchemaToJson(this);
}

/// Represents a table configuration in CSV Armor
@CopyWith()
@JsonSerializable(
    disallowUnrecognizedKeys: true, explicitToJson: true, includeIfNull: false)
class TableConfig {
  TableConfig({
    this.import,
    this.name = '',
    this.csvPath = '',
    this.columns = const [],
    this.primaryKey = const [],
    this.uniqueKey = const {},
    this.foreignKey = const {},
  });

  @JsonKey(name: 'import')
  String? import;
  @JsonKey(name: 'name')
  String name;
  @JsonKey(name: 'csv_path')
  String csvPath;
  @JsonKey(name: 'columns')
  List<TableColumn> columns;
  @JsonKey(name: 'primary_key')
  List<String> primaryKey;
  @JsonKey(name: 'unique_key')
  Map<String, List<String>> uniqueKey;
  @JsonKey(name: 'foreign_key')
  Map<String, ForeignKey> foreignKey;

  factory TableConfig.fromJson(Map<String, dynamic> json) =>
      _$TableConfigFromJson(json);

  Map<String, dynamic> toJson() => _$TableConfigToJson(this);
}

/// Represents a column definition in a CSV table
@CopyWith()
@JsonSerializable(
    disallowUnrecognizedKeys: true, explicitToJson: true, includeIfNull: false)
class TableColumn {
  TableColumn({
    required this.name,
    this.description,
    this.allowEmpty = false,
    this.type,
    this.regexp,
  });

  @JsonKey(name: 'name')
  String name;
  @JsonKey(name: 'description')
  String? description;
  @JsonKey(name: 'allow_empty')
  bool allowEmpty;
  @JsonKey(name: 'type')
  String? type;
  @JsonKey(name: 'regexp')
  String? regexp;

  factory TableColumn.fromJson(Map<String, dynamic> json) =>
      _$TableColumnFromJson(json);

  Map<String, dynamic> toJson() => _$TableColumnToJson(this);
}

/// Represents a foreign key constraint
@CopyWith()
@JsonSerializable(
    disallowUnrecognizedKeys: true, explicitToJson: true, includeIfNull: false)
class ForeignKey {
  ForeignKey({
    required this.columns,
    required this.reference,
    this.ignoreEmpty = false,
  });

  @JsonKey(name: 'columns')
  List<String> columns;
  @JsonKey(name: 'reference')
  ForeignKeyReference reference;
  @JsonKey(name: 'ignore_empty')
  bool ignoreEmpty;

  factory ForeignKey.fromJson(Map<String, dynamic> json) =>
      _$ForeignKeyFromJson(json);

  Map<String, dynamic> toJson() => _$ForeignKeyToJson(this);
}

/// Represents a reference to a foreign table and its unique key
@CopyWith()
@JsonSerializable(
    disallowUnrecognizedKeys: true, explicitToJson: true, includeIfNull: false)
class ForeignKeyReference {
  ForeignKeyReference({
    required this.table,
    this.uniqueKey,
  });

  @JsonKey(name: 'table')
  String table;
  @JsonKey(name: 'unique_key')
  String? uniqueKey;

  factory ForeignKeyReference.fromJson(Map<String, dynamic> json) =>
      _$ForeignKeyReferenceFromJson(json);

  Map<String, dynamic> toJson() => _$ForeignKeyReferenceToJson(this);
}

/// Represents a custom validation rule defined by a SQL query
@CopyWith()
@JsonSerializable(
    disallowUnrecognizedKeys: true, explicitToJson: true, includeIfNull: false)
class Validation {
  Validation({
    this.import,
    this.message = '',
    this.validationQuery = '',
  });

  @JsonKey(name: 'import')
  String? import;
  @JsonKey(name: 'message')
  String message;
  @JsonKey(name: 'validation_query')
  String validationQuery;

  factory Validation.fromJson(Map<String, dynamic> json) =>
      _$ValidationFromJson(json);

  Map<String, dynamic> toJson() => _$ValidationToJson(this);
}

/// Represents decode configuration for CSV files
@CopyWith()
@JsonSerializable(
    disallowUnrecognizedKeys: true, explicitToJson: true, includeIfNull: false)
class DecodeConfig {
  DecodeConfig({
    this.headerLines,
    this.recordSeparator,
    this.fieldSeparator,
    this.fieldQuote,
  });

  @JsonKey(name: 'import')
  String? import;
  @JsonKey(name: 'header_lines')
  int? headerLines;
  @JsonKey(name: 'record_separator')
  RecordSeparator? recordSeparator;
  @JsonKey(name: 'field_separator')
  String? fieldSeparator;
  @JsonKey(name: 'field_quote')
  FieldQuote? fieldQuote;

  factory DecodeConfig.fromJson(Map<String, dynamic> json) =>
      _$DecodeConfigFromJson(json);

  Map<String, dynamic> toJson() => _$DecodeConfigToJson(this);
}

/// Represents the record separator configuration for CSV files
@JsonEnum()
enum RecordSeparator {
  CRLF, // \r\n
  LF, // \n
  CR, // \r
  ANY, // any of the above
}

/// Represents field quote configuration for CSV files
@CopyWith()
@JsonSerializable(
    disallowUnrecognizedKeys: true, explicitToJson: true, includeIfNull: false)
class FieldQuote {
  FieldQuote({
    this.left,
    this.leftEscape,
    this.right,
    this.rightEscape,
  });

  @JsonKey(name: 'left')
  String? left;
  @JsonKey(name: 'left_escape')
  String? leftEscape;
  @JsonKey(name: 'right')
  String? right;
  @JsonKey(name: 'right_escape')
  String? rightEscape;

  factory FieldQuote.fromJson(Map<String, dynamic> json) =>
      _$FieldQuoteFromJson(json);

  Map<String, dynamic> toJson() => _$FieldQuoteToJson(this);
}
