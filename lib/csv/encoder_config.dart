import 'dart:convert';

import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:csv_armor/csv/error.dart';
import 'package:csv_armor/csv/record_separator.dart';
import 'package:csv_armor/src/require.dart';
import 'package:embed_annotation/embed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:json_schema/json_schema.dart';
import 'package:yaml/yaml.dart';

part 'encoder_config.g.dart';

@CopyWith()
@JsonSerializable(disallowUnrecognizedKeys: true, explicitToJson: true)
class EncoderConfig {
  EncoderConfig({
    this.recordSeparator = RecordSeparator.CRLF,
    this.terminatesWithRecordSeparator = false,
    this.fieldSeparator = ',',
    this.fieldQuote = const EncoderConfigQuote(
      quote: '"',
      quoteEscape: '""',
      always: false,
    ),
  }) {
    require(recordSeparator != RecordSeparator.ANY, ["recordSeparator"],
        "ANY is not allowed");
  }

  final RecordSeparator recordSeparator;
  final bool terminatesWithRecordSeparator;
  final String fieldSeparator;
  final EncoderConfigQuote? fieldQuote;

  factory EncoderConfig.fromJson(Map<String, dynamic> json) =>
      _$EncoderConfigFromJson(json);

  Map<String, dynamic> toJson() => _$EncoderConfigToJson(this);
}

@CopyWith()
@JsonSerializable(disallowUnrecognizedKeys: true, explicitToJson: true)
class EncoderConfigQuote {
  const EncoderConfigQuote({
    this.quote = '"',
    this.quoteEscape = '""',
    this.leftQuote,
    this.leftQuoteEscape,
    this.rightQuote,
    this.rightQuoteEscape,
    this.always = false,
  });

  @JsonKey(name: "quote")
  final String? quote;
  @JsonKey(name: "quote_escape")
  final String? quoteEscape;
  @JsonKey(name: "left_quote")
  final String? leftQuote;
  @JsonKey(name: "left_quote_escape")
  final String? leftQuoteEscape;
  @JsonKey(name: "right_quote")
  final String? rightQuote;
  @JsonKey(name: "right_quote_escape")
  final String? rightQuoteEscape;
  @JsonKey(name: "always")
  final bool always;

  factory EncoderConfigQuote.fromJson(Map<String, dynamic> json) {
    final result = EncoderConfigQuote._validator.validate(json);
    if (!result.isValid) {
      final errorMessage = result.errors
          .map((e) => "${e.instancePath}: ${e.message}: ${e.schemaPath}")
          .join("\n");
      throw DecodeException(errorMessage, decodeErrorInvalidConfig, [], 0);
    }
    return _$EncoderConfigQuoteFromJson(json);
  }

  Map<String, dynamic> toJson() => _$EncoderConfigQuoteToJson(this);

  static final _validator = _getEncoderConfigSchemaValidator();
}

@EmbedBinary("../../json-schema/encoder-config.yaml")
const encoderConfigYAMLBytes = _$encoderConfigYAMLBytes;

JsonSchema _getEncoderConfigSchemaValidator() {
  final encoderConfigYAML = utf8.decode(encoderConfigYAMLBytes);
  final schema = jsonEncode(loadYaml(encoderConfigYAML));
  return JsonSchema.create(schema);
}
