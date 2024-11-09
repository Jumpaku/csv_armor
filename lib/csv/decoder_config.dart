import 'dart:convert';

import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:csv_armor/csv/error.dart';
import 'package:csv_armor/csv/record_separator.dart';
import 'package:embed_annotation/embed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:json_schema/json_schema.dart';
import 'package:yaml/yaml.dart';

part 'decoder_config.g.dart';

@CopyWith()
@JsonSerializable(disallowUnrecognizedKeys: true, explicitToJson: true)
class DecoderConfig {
  const DecoderConfig({
    this.recordSeparator = RecordSeparator.CRLF,
    this.fieldSeparator = ',',
    this.fieldQuote = const DecoderConfigQuote(
      quote: '"',
      quoteEscape: '""',
    ),
  });

  final RecordSeparator recordSeparator;
  final String fieldSeparator;
  final DecoderConfigQuote? fieldQuote;

  factory DecoderConfig.fromJson(Map<String, dynamic> json) =>
      _$DecoderConfigFromJson(json);

  Map<String, dynamic> toJson() => _$DecoderConfigToJson(this);
}

@CopyWith()
@JsonSerializable(disallowUnrecognizedKeys: true, explicitToJson: true)
class DecoderConfigQuote {
  const DecoderConfigQuote({
    this.quote = '"',
    this.quoteEscape = '""',
    this.leftQuote,
    this.leftQuoteEscape,
    this.rightQuote,
    this.rightQuoteEscape,
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

  factory DecoderConfigQuote.fromJson(Map<String, dynamic> json) {
    final result = DecoderConfigQuote._validator.validate(json);
    if (!result.isValid) {
      final errorMessage = result.errors
          .map((e) => "${e.instancePath}: ${e.message}: ${e.schemaPath}")
          .join("\n");
      throw DecodeException(errorMessage, decodeErrorInvalidConfig, [], 0);
    }
    return _$DecoderConfigQuoteFromJson(json);
  }

  Map<String, dynamic> toJson() => _$DecoderConfigQuoteToJson(this);

  static final _validator = _getDecoderConfigSchemaValidator();
}

@EmbedBinary("../../json-schema/decoder-config.yaml")
const decoderConfigYAMLBytes = _$decoderConfigYAMLBytes;

JsonSchema _getDecoderConfigSchemaValidator() {
  final decoderConfigYAML = utf8.decode(decoderConfigYAMLBytes);
  final schema = jsonEncode(loadYaml(decoderConfigYAML));
  return JsonSchema.create(schema);
}
