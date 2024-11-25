import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'database_config.g.dart';

@CopyWith()
@JsonSerializable(disallowUnrecognizedKeys: true, explicitToJson: true)
class DatabaseConfig {
  @JsonKey(name: "tables")
  final Map<String, TablePath> tables;

  DatabaseConfig({required this.tables});

  factory DatabaseConfig.fromJson(Map<String, dynamic> json) =>
      _$DatabaseConfigFromJson(json);

  Map<String, dynamic> toJson() => _$DatabaseConfigToJson(this);
}

@CopyWith()
@JsonSerializable(disallowUnrecognizedKeys: true, explicitToJson: true)
class TablePath {
  @JsonKey(name: "schema_path")
  final String schemaPath;
  @JsonKey(name: "csv_path")
  final String csvPath;

  TablePath({
    required this.schemaPath,
    required this.csvPath,
  });

  factory TablePath.fromJson(Map<String, dynamic> json) => _$TablePathFromJson(json);

  Map<String, dynamic> toJson() => _$TablePathToJson(this);
}
