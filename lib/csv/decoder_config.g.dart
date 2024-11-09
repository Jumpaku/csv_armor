// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'decoder_config.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$DecoderConfigCWProxy {
  DecoderConfig recordSeparator(RecordSeparator recordSeparator);

  DecoderConfig fieldSeparator(String fieldSeparator);

  DecoderConfig fieldQuote(DecoderConfigQuote? fieldQuote);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DecoderConfig(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DecoderConfig(...).copyWith(id: 12, name: "My name")
  /// ````
  DecoderConfig call({
    RecordSeparator? recordSeparator,
    String? fieldSeparator,
    DecoderConfigQuote? fieldQuote,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfDecoderConfig.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfDecoderConfig.copyWith.fieldName(...)`
class _$DecoderConfigCWProxyImpl implements _$DecoderConfigCWProxy {
  const _$DecoderConfigCWProxyImpl(this._value);

  final DecoderConfig _value;

  @override
  DecoderConfig recordSeparator(RecordSeparator recordSeparator) =>
      this(recordSeparator: recordSeparator);

  @override
  DecoderConfig fieldSeparator(String fieldSeparator) =>
      this(fieldSeparator: fieldSeparator);

  @override
  DecoderConfig fieldQuote(DecoderConfigQuote? fieldQuote) =>
      this(fieldQuote: fieldQuote);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DecoderConfig(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DecoderConfig(...).copyWith(id: 12, name: "My name")
  /// ````
  DecoderConfig call({
    Object? recordSeparator = const $CopyWithPlaceholder(),
    Object? fieldSeparator = const $CopyWithPlaceholder(),
    Object? fieldQuote = const $CopyWithPlaceholder(),
  }) {
    return DecoderConfig(
      recordSeparator: recordSeparator == const $CopyWithPlaceholder() ||
              recordSeparator == null
          ? _value.recordSeparator
          // ignore: cast_nullable_to_non_nullable
          : recordSeparator as RecordSeparator,
      fieldSeparator: fieldSeparator == const $CopyWithPlaceholder() ||
              fieldSeparator == null
          ? _value.fieldSeparator
          // ignore: cast_nullable_to_non_nullable
          : fieldSeparator as String,
      fieldQuote: fieldQuote == const $CopyWithPlaceholder()
          ? _value.fieldQuote
          // ignore: cast_nullable_to_non_nullable
          : fieldQuote as DecoderConfigQuote?,
    );
  }
}

extension $DecoderConfigCopyWith on DecoderConfig {
  /// Returns a callable class that can be used as follows: `instanceOfDecoderConfig.copyWith(...)` or like so:`instanceOfDecoderConfig.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$DecoderConfigCWProxy get copyWith => _$DecoderConfigCWProxyImpl(this);
}

abstract class _$DecoderConfigQuoteCWProxy {
  DecoderConfigQuote quote(String? quote);

  DecoderConfigQuote quoteEscape(String? quoteEscape);

  DecoderConfigQuote leftQuote(String? leftQuote);

  DecoderConfigQuote leftQuoteEscape(String? leftQuoteEscape);

  DecoderConfigQuote rightQuote(String? rightQuote);

  DecoderConfigQuote rightQuoteEscape(String? rightQuoteEscape);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DecoderConfigQuote(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DecoderConfigQuote(...).copyWith(id: 12, name: "My name")
  /// ````
  DecoderConfigQuote call({
    String? quote,
    String? quoteEscape,
    String? leftQuote,
    String? leftQuoteEscape,
    String? rightQuote,
    String? rightQuoteEscape,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfDecoderConfigQuote.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfDecoderConfigQuote.copyWith.fieldName(...)`
class _$DecoderConfigQuoteCWProxyImpl implements _$DecoderConfigQuoteCWProxy {
  const _$DecoderConfigQuoteCWProxyImpl(this._value);

  final DecoderConfigQuote _value;

  @override
  DecoderConfigQuote quote(String? quote) => this(quote: quote);

  @override
  DecoderConfigQuote quoteEscape(String? quoteEscape) =>
      this(quoteEscape: quoteEscape);

  @override
  DecoderConfigQuote leftQuote(String? leftQuote) => this(leftQuote: leftQuote);

  @override
  DecoderConfigQuote leftQuoteEscape(String? leftQuoteEscape) =>
      this(leftQuoteEscape: leftQuoteEscape);

  @override
  DecoderConfigQuote rightQuote(String? rightQuote) =>
      this(rightQuote: rightQuote);

  @override
  DecoderConfigQuote rightQuoteEscape(String? rightQuoteEscape) =>
      this(rightQuoteEscape: rightQuoteEscape);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DecoderConfigQuote(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DecoderConfigQuote(...).copyWith(id: 12, name: "My name")
  /// ````
  DecoderConfigQuote call({
    Object? quote = const $CopyWithPlaceholder(),
    Object? quoteEscape = const $CopyWithPlaceholder(),
    Object? leftQuote = const $CopyWithPlaceholder(),
    Object? leftQuoteEscape = const $CopyWithPlaceholder(),
    Object? rightQuote = const $CopyWithPlaceholder(),
    Object? rightQuoteEscape = const $CopyWithPlaceholder(),
  }) {
    return DecoderConfigQuote(
      quote: quote == const $CopyWithPlaceholder()
          ? _value.quote
          // ignore: cast_nullable_to_non_nullable
          : quote as String?,
      quoteEscape: quoteEscape == const $CopyWithPlaceholder()
          ? _value.quoteEscape
          // ignore: cast_nullable_to_non_nullable
          : quoteEscape as String?,
      leftQuote: leftQuote == const $CopyWithPlaceholder()
          ? _value.leftQuote
          // ignore: cast_nullable_to_non_nullable
          : leftQuote as String?,
      leftQuoteEscape: leftQuoteEscape == const $CopyWithPlaceholder()
          ? _value.leftQuoteEscape
          // ignore: cast_nullable_to_non_nullable
          : leftQuoteEscape as String?,
      rightQuote: rightQuote == const $CopyWithPlaceholder()
          ? _value.rightQuote
          // ignore: cast_nullable_to_non_nullable
          : rightQuote as String?,
      rightQuoteEscape: rightQuoteEscape == const $CopyWithPlaceholder()
          ? _value.rightQuoteEscape
          // ignore: cast_nullable_to_non_nullable
          : rightQuoteEscape as String?,
    );
  }
}

extension $DecoderConfigQuoteCopyWith on DecoderConfigQuote {
  /// Returns a callable class that can be used as follows: `instanceOfDecoderConfigQuote.copyWith(...)` or like so:`instanceOfDecoderConfigQuote.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$DecoderConfigQuoteCWProxy get copyWith =>
      _$DecoderConfigQuoteCWProxyImpl(this);
}

// **************************************************************************
// BinaryEmbeddingGenerator
// **************************************************************************

const _$decoderConfigYAMLBytes = [
  34,
  36,
  115,
  99,
  104,
  101,
  109,
  97,
  34,
  58,
  32,
  34,
  104,
  116,
  116,
  112,
  115,
  58,
  47,
  47,
  106,
  115,
  111,
  110,
  45,
  115,
  99,
  104,
  101,
  109,
  97,
  46,
  111,
  114,
  103,
  47,
  100,
  114,
  97,
  102,
  116,
  47,
  48,
  55,
  47,
  115,
  99,
  104,
  101,
  109,
  97,
  34,
  10,
  34,
  116,
  105,
  116,
  108,
  101,
  34,
  58,
  32,
  34,
  67,
  83,
  86,
  32,
  68,
  101,
  99,
  111,
  100,
  101,
  114,
  32,
  67,
  111,
  110,
  102,
  105,
  103,
  34,
  10,
  10,
  116,
  121,
  112,
  101,
  58,
  32,
  111,
  98,
  106,
  101,
  99,
  116,
  10,
  112,
  114,
  111,
  112,
  101,
  114,
  116,
  105,
  101,
  115,
  58,
  10,
  32,
  32,
  102,
  105,
  101,
  108,
  100,
  95,
  115,
  101,
  112,
  97,
  114,
  97,
  116,
  111,
  114,
  58,
  10,
  32,
  32,
  32,
  32,
  116,
  121,
  112,
  101,
  58,
  32,
  115,
  116,
  114,
  105,
  110,
  103,
  10,
  32,
  32,
  32,
  32,
  100,
  101,
  102,
  97,
  117,
  108,
  116,
  58,
  32,
  34,
  44,
  34,
  10,
  32,
  32,
  114,
  101,
  99,
  111,
  114,
  100,
  95,
  115,
  101,
  112,
  97,
  114,
  97,
  116,
  111,
  114,
  58,
  10,
  32,
  32,
  32,
  32,
  116,
  121,
  112,
  101,
  58,
  32,
  115,
  116,
  114,
  105,
  110,
  103,
  10,
  32,
  32,
  32,
  32,
  101,
  110,
  117,
  109,
  58,
  32,
  91,
  32,
  34,
  67,
  82,
  76,
  70,
  34,
  44,
  32,
  34,
  76,
  70,
  34,
  44,
  32,
  34,
  67,
  82,
  34,
  44,
  32,
  34,
  65,
  78,
  89,
  34,
  32,
  93,
  10,
  32,
  32,
  102,
  105,
  101,
  108,
  100,
  95,
  113,
  117,
  111,
  116,
  101,
  58,
  10,
  32,
  32,
  32,
  32,
  111,
  110,
  101,
  79,
  102,
  58,
  10,
  32,
  32,
  32,
  32,
  32,
  32,
  45,
  32,
  116,
  121,
  112,
  101,
  58,
  32,
  111,
  98,
  106,
  101,
  99,
  116,
  10,
  32,
  32,
  32,
  32,
  32,
  32,
  32,
  32,
  112,
  114,
  111,
  112,
  101,
  114,
  116,
  105,
  101,
  115,
  58,
  10,
  32,
  32,
  32,
  32,
  32,
  32,
  32,
  32,
  32,
  32,
  113,
  117,
  111,
  116,
  101,
  58,
  10,
  32,
  32,
  32,
  32,
  32,
  32,
  32,
  32,
  32,
  32,
  32,
  32,
  116,
  121,
  112,
  101,
  58,
  32,
  115,
  116,
  114,
  105,
  110,
  103,
  10,
  32,
  32,
  32,
  32,
  32,
  32,
  32,
  32,
  32,
  32,
  32,
  32,
  100,
  101,
  102,
  97,
  117,
  108,
  116,
  58,
  32,
  39,
  34,
  39,
  10,
  32,
  32,
  32,
  32,
  32,
  32,
  32,
  32,
  32,
  32,
  101,
  115,
  99,
  97,
  112,
  101,
  58,
  10,
  32,
  32,
  32,
  32,
  32,
  32,
  32,
  32,
  32,
  32,
  32,
  32,
  116,
  121,
  112,
  101,
  58,
  32,
  115,
  116,
  114,
  105,
  110,
  103,
  10,
  32,
  32,
  32,
  32,
  32,
  32,
  32,
  32,
  32,
  32,
  32,
  32,
  100,
  101,
  102,
  97,
  117,
  108,
  116,
  58,
  32,
  39,
  34,
  34,
  39,
  10,
  32,
  32,
  32,
  32,
  32,
  32,
  32,
  32,
  97,
  100,
  100,
  105,
  116,
  105,
  111,
  110,
  97,
  108,
  80,
  114,
  111,
  112,
  101,
  114,
  116,
  105,
  101,
  115,
  58,
  32,
  102,
  97,
  108,
  115,
  101,
  10,
  32,
  32,
  32,
  32,
  32,
  32,
  45,
  32,
  116,
  121,
  112,
  101,
  58,
  32,
  111,
  98,
  106,
  101,
  99,
  116,
  10,
  32,
  32,
  32,
  32,
  32,
  32,
  32,
  32,
  112,
  114,
  111,
  112,
  101,
  114,
  116,
  105,
  101,
  115,
  58,
  10,
  32,
  32,
  32,
  32,
  32,
  32,
  32,
  32,
  32,
  32,
  108,
  101,
  102,
  116,
  95,
  113,
  117,
  111,
  116,
  101,
  58,
  10,
  32,
  32,
  32,
  32,
  32,
  32,
  32,
  32,
  32,
  32,
  32,
  32,
  116,
  121,
  112,
  101,
  58,
  32,
  115,
  116,
  114,
  105,
  110,
  103,
  10,
  32,
  32,
  32,
  32,
  32,
  32,
  32,
  32,
  32,
  32,
  108,
  101,
  102,
  116,
  95,
  101,
  115,
  99,
  97,
  112,
  101,
  58,
  10,
  32,
  32,
  32,
  32,
  32,
  32,
  32,
  32,
  32,
  32,
  32,
  32,
  116,
  121,
  112,
  101,
  58,
  32,
  115,
  116,
  114,
  105,
  110,
  103,
  10,
  32,
  32,
  32,
  32,
  32,
  32,
  32,
  32,
  32,
  32,
  114,
  105,
  103,
  104,
  116,
  95,
  113,
  117,
  111,
  116,
  101,
  58,
  10,
  32,
  32,
  32,
  32,
  32,
  32,
  32,
  32,
  32,
  32,
  32,
  32,
  116,
  121,
  112,
  101,
  58,
  32,
  115,
  116,
  114,
  105,
  110,
  103,
  10,
  32,
  32,
  32,
  32,
  32,
  32,
  32,
  32,
  32,
  32,
  114,
  105,
  103,
  104,
  116,
  95,
  101,
  115,
  99,
  97,
  112,
  101,
  58,
  10,
  32,
  32,
  32,
  32,
  32,
  32,
  32,
  32,
  32,
  32,
  32,
  32,
  116,
  121,
  112,
  101,
  58,
  32,
  115,
  116,
  114,
  105,
  110,
  103,
  10,
  32,
  32,
  32,
  32,
  32,
  32,
  32,
  32,
  97,
  100,
  100,
  105,
  116,
  105,
  111,
  110,
  97,
  108,
  80,
  114,
  111,
  112,
  101,
  114,
  116,
  105,
  101,
  115,
  58,
  32,
  102,
  97,
  108,
  115,
  101,
  10,
  97,
  100,
  100,
  105,
  116,
  105,
  111,
  110,
  97,
  108,
  80,
  114,
  111,
  112,
  101,
  114,
  116,
  105,
  101,
  115,
  58,
  32,
  102,
  97,
  108,
  115,
  101,
  10
];

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DecoderConfig _$DecoderConfigFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    allowedKeys: const ['recordSeparator', 'fieldSeparator', 'fieldQuote'],
  );
  return DecoderConfig(
    recordSeparator: $enumDecodeNullable(
            _$RecordSeparatorEnumMap, json['recordSeparator']) ??
        RecordSeparator.CRLF,
    fieldSeparator: json['fieldSeparator'] as String? ?? ',',
    fieldQuote: json['fieldQuote'] == null
        ? const DecoderConfigQuote(quote: '"', quoteEscape: '""')
        : DecoderConfigQuote.fromJson(
            json['fieldQuote'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$DecoderConfigToJson(DecoderConfig instance) =>
    <String, dynamic>{
      'recordSeparator': _$RecordSeparatorEnumMap[instance.recordSeparator]!,
      'fieldSeparator': instance.fieldSeparator,
      'fieldQuote': instance.fieldQuote?.toJson(),
    };

const _$RecordSeparatorEnumMap = {
  RecordSeparator.ANY: 'ANY',
  RecordSeparator.CRLF: 'CRLF',
  RecordSeparator.LF: 'LF',
  RecordSeparator.CR: 'CR',
};

DecoderConfigQuote _$DecoderConfigQuoteFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    allowedKeys: const [
      'quote',
      'quote_escape',
      'left_quote',
      'left_quote_escape',
      'right_quote',
      'right_quote_escape'
    ],
  );
  return DecoderConfigQuote(
    quote: json['quote'] as String? ?? '"',
    quoteEscape: json['quote_escape'] as String? ?? '""',
    leftQuote: json['left_quote'] as String?,
    leftQuoteEscape: json['left_quote_escape'] as String?,
    rightQuote: json['right_quote'] as String?,
    rightQuoteEscape: json['right_quote_escape'] as String?,
  );
}

Map<String, dynamic> _$DecoderConfigQuoteToJson(DecoderConfigQuote instance) =>
    <String, dynamic>{
      'quote': instance.quote,
      'quote_escape': instance.quoteEscape,
      'left_quote': instance.leftQuote,
      'left_quote_escape': instance.leftQuoteEscape,
      'right_quote': instance.rightQuote,
      'right_quote_escape': instance.rightQuoteEscape,
    };
