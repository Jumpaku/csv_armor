// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'result.dart';

class ValidationResultMapper extends ClassMapperBase<ValidationResult> {
  ValidationResultMapper._();

  static ValidationResultMapper? _instance;
  static ValidationResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ValidationResultMapper._());
      ValidationErrorMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'ValidationResult';

  static List<ValidationError> _$errors(ValidationResult v) => v.errors;
  static const Field<ValidationResult, List<ValidationError>> _f$errors =
      Field('errors', _$errors, opt: true, def: const []);

  @override
  final MappableFields<ValidationResult> fields = const {
    #errors: _f$errors,
  };

  static ValidationResult _instantiate(DecodingData data) {
    return ValidationResult(errors: data.dec(_f$errors));
  }

  @override
  final Function instantiate = _instantiate;

  static ValidationResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ValidationResult>(map);
  }

  static ValidationResult fromJson(String json) {
    return ensureInitialized().decodeJson<ValidationResult>(json);
  }
}

mixin ValidationResultMappable {
  String toJson() {
    return ValidationResultMapper.ensureInitialized()
        .encodeJson<ValidationResult>(this as ValidationResult);
  }

  Map<String, dynamic> toMap() {
    return ValidationResultMapper.ensureInitialized()
        .encodeMap<ValidationResult>(this as ValidationResult);
  }

  ValidationResultCopyWith<ValidationResult, ValidationResult, ValidationResult>
      get copyWith => _ValidationResultCopyWithImpl(
          this as ValidationResult, $identity, $identity);
  @override
  String toString() {
    return ValidationResultMapper.ensureInitialized()
        .stringifyValue(this as ValidationResult);
  }

  @override
  bool operator ==(Object other) {
    return ValidationResultMapper.ensureInitialized()
        .equalsValue(this as ValidationResult, other);
  }

  @override
  int get hashCode {
    return ValidationResultMapper.ensureInitialized()
        .hashValue(this as ValidationResult);
  }
}

extension ValidationResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ValidationResult, $Out> {
  ValidationResultCopyWith<$R, ValidationResult, $Out>
      get $asValidationResult =>
          $base.as((v, t, t2) => _ValidationResultCopyWithImpl(v, t, t2));
}

abstract class ValidationResultCopyWith<$R, $In extends ValidationResult, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, ValidationError,
      ValidationErrorCopyWith<$R, ValidationError, ValidationError>> get errors;
  $R call({List<ValidationError>? errors});
  ValidationResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _ValidationResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ValidationResult, $Out>
    implements ValidationResultCopyWith<$R, ValidationResult, $Out> {
  _ValidationResultCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ValidationResult> $mapper =
      ValidationResultMapper.ensureInitialized();
  @override
  ListCopyWith<$R, ValidationError,
          ValidationErrorCopyWith<$R, ValidationError, ValidationError>>
      get errors => ListCopyWith($value.errors, (v, t) => v.copyWith.$chain(t),
          (v) => call(errors: v));
  @override
  $R call({List<ValidationError>? errors}) =>
      $apply(FieldCopyWithData({if (errors != null) #errors: errors}));
  @override
  ValidationResult $make(CopyWithData data) =>
      ValidationResult(errors: data.get(#errors, or: $value.errors));

  @override
  ValidationResultCopyWith<$R2, ValidationResult, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _ValidationResultCopyWithImpl($value, $cast, t);
}

class ValidationErrorMapper extends ClassMapperBase<ValidationError> {
  ValidationErrorMapper._();

  static ValidationErrorMapper? _instance;
  static ValidationErrorMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ValidationErrorMapper._());
      SchemaCSVNotFoundMapper.ensureInitialized();
      TooFewHeadersMapper.ensureInitialized();
      ColumnCountMismatchMapper.ensureInitialized();
      DuplicatedPrimaryKeyMapper.ensureInitialized();
      DuplicatedUniqueKeyMapper.ensureInitialized();
      FieldHasNoTypeMatchMapper.ensureInitialized();
      FieldHasNoRegexMatchMapper.ensureInitialized();
      EmptyFieldNotAllowedMapper.ensureInitialized();
      ForeignKeyReferenceNotUniqueInForeignColumnsMapper.ensureInitialized();
      ForeignKeyReferenceColumnNotInForeignColumnsMapper.ensureInitialized();
      ForeignKeyViolationMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'ValidationError';

  @override
  final MappableFields<ValidationError> fields = const {};

  static ValidationError _instantiate(DecodingData data) {
    throw MapperException.missingSubclass(
        'ValidationError', 'kind', '${data.value['kind']}');
  }

  @override
  final Function instantiate = _instantiate;

  static ValidationError fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ValidationError>(map);
  }

  static ValidationError fromJson(String json) {
    return ensureInitialized().decodeJson<ValidationError>(json);
  }
}

mixin ValidationErrorMappable {
  String toJson();
  Map<String, dynamic> toMap();
  ValidationErrorCopyWith<ValidationError, ValidationError, ValidationError>
      get copyWith;
}

abstract class ValidationErrorCopyWith<$R, $In extends ValidationError, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call();
  ValidationErrorCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class SchemaCSVNotFoundMapper extends SubClassMapperBase<SchemaCSVNotFound> {
  SchemaCSVNotFoundMapper._();

  static SchemaCSVNotFoundMapper? _instance;
  static SchemaCSVNotFoundMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SchemaCSVNotFoundMapper._());
      ValidationErrorMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'SchemaCSVNotFound';

  static String _$schemaPath(SchemaCSVNotFound v) => v.schemaPath;
  static const Field<SchemaCSVNotFound, String> _f$schemaPath =
      Field('schemaPath', _$schemaPath, key: 'schema_path');

  @override
  final MappableFields<SchemaCSVNotFound> fields = const {
    #schemaPath: _f$schemaPath,
  };

  @override
  final String discriminatorKey = 'kind';
  @override
  final dynamic discriminatorValue = 'SchemaCSVNotFound';
  @override
  late final ClassMapperBase superMapper =
      ValidationErrorMapper.ensureInitialized();

  static SchemaCSVNotFound _instantiate(DecodingData data) {
    return SchemaCSVNotFound(data.dec(_f$schemaPath));
  }

  @override
  final Function instantiate = _instantiate;

  static SchemaCSVNotFound fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SchemaCSVNotFound>(map);
  }

  static SchemaCSVNotFound fromJson(String json) {
    return ensureInitialized().decodeJson<SchemaCSVNotFound>(json);
  }
}

mixin SchemaCSVNotFoundMappable {
  String toJson() {
    return SchemaCSVNotFoundMapper.ensureInitialized()
        .encodeJson<SchemaCSVNotFound>(this as SchemaCSVNotFound);
  }

  Map<String, dynamic> toMap() {
    return SchemaCSVNotFoundMapper.ensureInitialized()
        .encodeMap<SchemaCSVNotFound>(this as SchemaCSVNotFound);
  }

  SchemaCSVNotFoundCopyWith<SchemaCSVNotFound, SchemaCSVNotFound,
          SchemaCSVNotFound>
      get copyWith => _SchemaCSVNotFoundCopyWithImpl(
          this as SchemaCSVNotFound, $identity, $identity);
  @override
  String toString() {
    return SchemaCSVNotFoundMapper.ensureInitialized()
        .stringifyValue(this as SchemaCSVNotFound);
  }

  @override
  bool operator ==(Object other) {
    return SchemaCSVNotFoundMapper.ensureInitialized()
        .equalsValue(this as SchemaCSVNotFound, other);
  }

  @override
  int get hashCode {
    return SchemaCSVNotFoundMapper.ensureInitialized()
        .hashValue(this as SchemaCSVNotFound);
  }
}

extension SchemaCSVNotFoundValueCopy<$R, $Out>
    on ObjectCopyWith<$R, SchemaCSVNotFound, $Out> {
  SchemaCSVNotFoundCopyWith<$R, SchemaCSVNotFound, $Out>
      get $asSchemaCSVNotFound =>
          $base.as((v, t, t2) => _SchemaCSVNotFoundCopyWithImpl(v, t, t2));
}

abstract class SchemaCSVNotFoundCopyWith<$R, $In extends SchemaCSVNotFound,
    $Out> implements ValidationErrorCopyWith<$R, $In, $Out> {
  @override
  $R call({String? schemaPath});
  SchemaCSVNotFoundCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _SchemaCSVNotFoundCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, SchemaCSVNotFound, $Out>
    implements SchemaCSVNotFoundCopyWith<$R, SchemaCSVNotFound, $Out> {
  _SchemaCSVNotFoundCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<SchemaCSVNotFound> $mapper =
      SchemaCSVNotFoundMapper.ensureInitialized();
  @override
  $R call({String? schemaPath}) => $apply(
      FieldCopyWithData({if (schemaPath != null) #schemaPath: schemaPath}));
  @override
  SchemaCSVNotFound $make(CopyWithData data) =>
      SchemaCSVNotFound(data.get(#schemaPath, or: $value.schemaPath));

  @override
  SchemaCSVNotFoundCopyWith<$R2, SchemaCSVNotFound, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _SchemaCSVNotFoundCopyWithImpl($value, $cast, t);
}

class TooFewHeadersMapper extends SubClassMapperBase<TooFewHeaders> {
  TooFewHeadersMapper._();

  static TooFewHeadersMapper? _instance;
  static TooFewHeadersMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = TooFewHeadersMapper._());
      ValidationErrorMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'TooFewHeaders';

  static int _$actualHeaders(TooFewHeaders v) => v.actualHeaders;
  static const Field<TooFewHeaders, int> _f$actualHeaders =
      Field('actualHeaders', _$actualHeaders, key: 'actual_headers');

  @override
  final MappableFields<TooFewHeaders> fields = const {
    #actualHeaders: _f$actualHeaders,
  };

  @override
  final String discriminatorKey = 'kind';
  @override
  final dynamic discriminatorValue = 'TooFewHeaders';
  @override
  late final ClassMapperBase superMapper =
      ValidationErrorMapper.ensureInitialized();

  static TooFewHeaders _instantiate(DecodingData data) {
    return TooFewHeaders(data.dec(_f$actualHeaders));
  }

  @override
  final Function instantiate = _instantiate;

  static TooFewHeaders fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<TooFewHeaders>(map);
  }

  static TooFewHeaders fromJson(String json) {
    return ensureInitialized().decodeJson<TooFewHeaders>(json);
  }
}

mixin TooFewHeadersMappable {
  String toJson() {
    return TooFewHeadersMapper.ensureInitialized()
        .encodeJson<TooFewHeaders>(this as TooFewHeaders);
  }

  Map<String, dynamic> toMap() {
    return TooFewHeadersMapper.ensureInitialized()
        .encodeMap<TooFewHeaders>(this as TooFewHeaders);
  }

  TooFewHeadersCopyWith<TooFewHeaders, TooFewHeaders, TooFewHeaders>
      get copyWith => _TooFewHeadersCopyWithImpl(
          this as TooFewHeaders, $identity, $identity);
  @override
  String toString() {
    return TooFewHeadersMapper.ensureInitialized()
        .stringifyValue(this as TooFewHeaders);
  }

  @override
  bool operator ==(Object other) {
    return TooFewHeadersMapper.ensureInitialized()
        .equalsValue(this as TooFewHeaders, other);
  }

  @override
  int get hashCode {
    return TooFewHeadersMapper.ensureInitialized()
        .hashValue(this as TooFewHeaders);
  }
}

extension TooFewHeadersValueCopy<$R, $Out>
    on ObjectCopyWith<$R, TooFewHeaders, $Out> {
  TooFewHeadersCopyWith<$R, TooFewHeaders, $Out> get $asTooFewHeaders =>
      $base.as((v, t, t2) => _TooFewHeadersCopyWithImpl(v, t, t2));
}

abstract class TooFewHeadersCopyWith<$R, $In extends TooFewHeaders, $Out>
    implements ValidationErrorCopyWith<$R, $In, $Out> {
  @override
  $R call({int? actualHeaders});
  TooFewHeadersCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _TooFewHeadersCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, TooFewHeaders, $Out>
    implements TooFewHeadersCopyWith<$R, TooFewHeaders, $Out> {
  _TooFewHeadersCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<TooFewHeaders> $mapper =
      TooFewHeadersMapper.ensureInitialized();
  @override
  $R call({int? actualHeaders}) => $apply(FieldCopyWithData(
      {if (actualHeaders != null) #actualHeaders: actualHeaders}));
  @override
  TooFewHeaders $make(CopyWithData data) =>
      TooFewHeaders(data.get(#actualHeaders, or: $value.actualHeaders));

  @override
  TooFewHeadersCopyWith<$R2, TooFewHeaders, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _TooFewHeadersCopyWithImpl($value, $cast, t);
}

class ColumnCountMismatchMapper
    extends SubClassMapperBase<ColumnCountMismatch> {
  ColumnCountMismatchMapper._();

  static ColumnCountMismatchMapper? _instance;
  static ColumnCountMismatchMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ColumnCountMismatchMapper._());
      ValidationErrorMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'ColumnCountMismatch';

  static int _$rowIndex(ColumnCountMismatch v) => v.rowIndex;
  static const Field<ColumnCountMismatch, int> _f$rowIndex =
      Field('rowIndex', _$rowIndex, key: 'row_index');
  static int _$actualColumns(ColumnCountMismatch v) => v.actualColumns;
  static const Field<ColumnCountMismatch, int> _f$actualColumns =
      Field('actualColumns', _$actualColumns, key: 'actual_columns');

  @override
  final MappableFields<ColumnCountMismatch> fields = const {
    #rowIndex: _f$rowIndex,
    #actualColumns: _f$actualColumns,
  };

  @override
  final String discriminatorKey = 'kind';
  @override
  final dynamic discriminatorValue = 'ColumnCountMismatch';
  @override
  late final ClassMapperBase superMapper =
      ValidationErrorMapper.ensureInitialized();

  static ColumnCountMismatch _instantiate(DecodingData data) {
    return ColumnCountMismatch(
        data.dec(_f$rowIndex), data.dec(_f$actualColumns));
  }

  @override
  final Function instantiate = _instantiate;

  static ColumnCountMismatch fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ColumnCountMismatch>(map);
  }

  static ColumnCountMismatch fromJson(String json) {
    return ensureInitialized().decodeJson<ColumnCountMismatch>(json);
  }
}

mixin ColumnCountMismatchMappable {
  String toJson() {
    return ColumnCountMismatchMapper.ensureInitialized()
        .encodeJson<ColumnCountMismatch>(this as ColumnCountMismatch);
  }

  Map<String, dynamic> toMap() {
    return ColumnCountMismatchMapper.ensureInitialized()
        .encodeMap<ColumnCountMismatch>(this as ColumnCountMismatch);
  }

  ColumnCountMismatchCopyWith<ColumnCountMismatch, ColumnCountMismatch,
          ColumnCountMismatch>
      get copyWith => _ColumnCountMismatchCopyWithImpl(
          this as ColumnCountMismatch, $identity, $identity);
  @override
  String toString() {
    return ColumnCountMismatchMapper.ensureInitialized()
        .stringifyValue(this as ColumnCountMismatch);
  }

  @override
  bool operator ==(Object other) {
    return ColumnCountMismatchMapper.ensureInitialized()
        .equalsValue(this as ColumnCountMismatch, other);
  }

  @override
  int get hashCode {
    return ColumnCountMismatchMapper.ensureInitialized()
        .hashValue(this as ColumnCountMismatch);
  }
}

extension ColumnCountMismatchValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ColumnCountMismatch, $Out> {
  ColumnCountMismatchCopyWith<$R, ColumnCountMismatch, $Out>
      get $asColumnCountMismatch =>
          $base.as((v, t, t2) => _ColumnCountMismatchCopyWithImpl(v, t, t2));
}

abstract class ColumnCountMismatchCopyWith<$R, $In extends ColumnCountMismatch,
    $Out> implements ValidationErrorCopyWith<$R, $In, $Out> {
  @override
  $R call({int? rowIndex, int? actualColumns});
  ColumnCountMismatchCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _ColumnCountMismatchCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ColumnCountMismatch, $Out>
    implements ColumnCountMismatchCopyWith<$R, ColumnCountMismatch, $Out> {
  _ColumnCountMismatchCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ColumnCountMismatch> $mapper =
      ColumnCountMismatchMapper.ensureInitialized();
  @override
  $R call({int? rowIndex, int? actualColumns}) => $apply(FieldCopyWithData({
        if (rowIndex != null) #rowIndex: rowIndex,
        if (actualColumns != null) #actualColumns: actualColumns
      }));
  @override
  ColumnCountMismatch $make(CopyWithData data) => ColumnCountMismatch(
      data.get(#rowIndex, or: $value.rowIndex),
      data.get(#actualColumns, or: $value.actualColumns));

  @override
  ColumnCountMismatchCopyWith<$R2, ColumnCountMismatch, $Out2>
      $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
          _ColumnCountMismatchCopyWithImpl($value, $cast, t);
}

class DuplicatedPrimaryKeyMapper
    extends SubClassMapperBase<DuplicatedPrimaryKey> {
  DuplicatedPrimaryKeyMapper._();

  static DuplicatedPrimaryKeyMapper? _instance;
  static DuplicatedPrimaryKeyMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = DuplicatedPrimaryKeyMapper._());
      ValidationErrorMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'DuplicatedPrimaryKey';

  static List<String> _$key(DuplicatedPrimaryKey v) => v.key;
  static const Field<DuplicatedPrimaryKey, List<String>> _f$key =
      Field('key', _$key);
  static List<int> _$rowIndex(DuplicatedPrimaryKey v) => v.rowIndex;
  static const Field<DuplicatedPrimaryKey, List<int>> _f$rowIndex =
      Field('rowIndex', _$rowIndex, key: 'row_index');

  @override
  final MappableFields<DuplicatedPrimaryKey> fields = const {
    #key: _f$key,
    #rowIndex: _f$rowIndex,
  };

  @override
  final String discriminatorKey = 'kind';
  @override
  final dynamic discriminatorValue = 'DuplicatedPrimaryKey';
  @override
  late final ClassMapperBase superMapper =
      ValidationErrorMapper.ensureInitialized();

  static DuplicatedPrimaryKey _instantiate(DecodingData data) {
    return DuplicatedPrimaryKey(data.dec(_f$key), data.dec(_f$rowIndex));
  }

  @override
  final Function instantiate = _instantiate;

  static DuplicatedPrimaryKey fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<DuplicatedPrimaryKey>(map);
  }

  static DuplicatedPrimaryKey fromJson(String json) {
    return ensureInitialized().decodeJson<DuplicatedPrimaryKey>(json);
  }
}

mixin DuplicatedPrimaryKeyMappable {
  String toJson() {
    return DuplicatedPrimaryKeyMapper.ensureInitialized()
        .encodeJson<DuplicatedPrimaryKey>(this as DuplicatedPrimaryKey);
  }

  Map<String, dynamic> toMap() {
    return DuplicatedPrimaryKeyMapper.ensureInitialized()
        .encodeMap<DuplicatedPrimaryKey>(this as DuplicatedPrimaryKey);
  }

  DuplicatedPrimaryKeyCopyWith<DuplicatedPrimaryKey, DuplicatedPrimaryKey,
          DuplicatedPrimaryKey>
      get copyWith => _DuplicatedPrimaryKeyCopyWithImpl(
          this as DuplicatedPrimaryKey, $identity, $identity);
  @override
  String toString() {
    return DuplicatedPrimaryKeyMapper.ensureInitialized()
        .stringifyValue(this as DuplicatedPrimaryKey);
  }

  @override
  bool operator ==(Object other) {
    return DuplicatedPrimaryKeyMapper.ensureInitialized()
        .equalsValue(this as DuplicatedPrimaryKey, other);
  }

  @override
  int get hashCode {
    return DuplicatedPrimaryKeyMapper.ensureInitialized()
        .hashValue(this as DuplicatedPrimaryKey);
  }
}

extension DuplicatedPrimaryKeyValueCopy<$R, $Out>
    on ObjectCopyWith<$R, DuplicatedPrimaryKey, $Out> {
  DuplicatedPrimaryKeyCopyWith<$R, DuplicatedPrimaryKey, $Out>
      get $asDuplicatedPrimaryKey =>
          $base.as((v, t, t2) => _DuplicatedPrimaryKeyCopyWithImpl(v, t, t2));
}

abstract class DuplicatedPrimaryKeyCopyWith<
    $R,
    $In extends DuplicatedPrimaryKey,
    $Out> implements ValidationErrorCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get key;
  ListCopyWith<$R, int, ObjectCopyWith<$R, int, int>> get rowIndex;
  @override
  $R call({List<String>? key, List<int>? rowIndex});
  DuplicatedPrimaryKeyCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _DuplicatedPrimaryKeyCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, DuplicatedPrimaryKey, $Out>
    implements DuplicatedPrimaryKeyCopyWith<$R, DuplicatedPrimaryKey, $Out> {
  _DuplicatedPrimaryKeyCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<DuplicatedPrimaryKey> $mapper =
      DuplicatedPrimaryKeyMapper.ensureInitialized();
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get key =>
      ListCopyWith($value.key, (v, t) => ObjectCopyWith(v, $identity, t),
          (v) => call(key: v));
  @override
  ListCopyWith<$R, int, ObjectCopyWith<$R, int, int>> get rowIndex =>
      ListCopyWith($value.rowIndex, (v, t) => ObjectCopyWith(v, $identity, t),
          (v) => call(rowIndex: v));
  @override
  $R call({List<String>? key, List<int>? rowIndex}) => $apply(FieldCopyWithData(
      {if (key != null) #key: key, if (rowIndex != null) #rowIndex: rowIndex}));
  @override
  DuplicatedPrimaryKey $make(CopyWithData data) => DuplicatedPrimaryKey(
      data.get(#key, or: $value.key), data.get(#rowIndex, or: $value.rowIndex));

  @override
  DuplicatedPrimaryKeyCopyWith<$R2, DuplicatedPrimaryKey, $Out2>
      $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
          _DuplicatedPrimaryKeyCopyWithImpl($value, $cast, t);
}

class DuplicatedUniqueKeyMapper
    extends SubClassMapperBase<DuplicatedUniqueKey> {
  DuplicatedUniqueKeyMapper._();

  static DuplicatedUniqueKeyMapper? _instance;
  static DuplicatedUniqueKeyMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = DuplicatedUniqueKeyMapper._());
      ValidationErrorMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'DuplicatedUniqueKey';

  static String _$name(DuplicatedUniqueKey v) => v.name;
  static const Field<DuplicatedUniqueKey, String> _f$name =
      Field('name', _$name);
  static List<String> _$key(DuplicatedUniqueKey v) => v.key;
  static const Field<DuplicatedUniqueKey, List<String>> _f$key =
      Field('key', _$key);
  static List<int> _$rowIndex(DuplicatedUniqueKey v) => v.rowIndex;
  static const Field<DuplicatedUniqueKey, List<int>> _f$rowIndex =
      Field('rowIndex', _$rowIndex, key: 'row_index');

  @override
  final MappableFields<DuplicatedUniqueKey> fields = const {
    #name: _f$name,
    #key: _f$key,
    #rowIndex: _f$rowIndex,
  };

  @override
  final String discriminatorKey = 'kind';
  @override
  final dynamic discriminatorValue = 'DuplicatedUniqueKey';
  @override
  late final ClassMapperBase superMapper =
      ValidationErrorMapper.ensureInitialized();

  static DuplicatedUniqueKey _instantiate(DecodingData data) {
    return DuplicatedUniqueKey(
        data.dec(_f$name), data.dec(_f$key), data.dec(_f$rowIndex));
  }

  @override
  final Function instantiate = _instantiate;

  static DuplicatedUniqueKey fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<DuplicatedUniqueKey>(map);
  }

  static DuplicatedUniqueKey fromJson(String json) {
    return ensureInitialized().decodeJson<DuplicatedUniqueKey>(json);
  }
}

mixin DuplicatedUniqueKeyMappable {
  String toJson() {
    return DuplicatedUniqueKeyMapper.ensureInitialized()
        .encodeJson<DuplicatedUniqueKey>(this as DuplicatedUniqueKey);
  }

  Map<String, dynamic> toMap() {
    return DuplicatedUniqueKeyMapper.ensureInitialized()
        .encodeMap<DuplicatedUniqueKey>(this as DuplicatedUniqueKey);
  }

  DuplicatedUniqueKeyCopyWith<DuplicatedUniqueKey, DuplicatedUniqueKey,
          DuplicatedUniqueKey>
      get copyWith => _DuplicatedUniqueKeyCopyWithImpl(
          this as DuplicatedUniqueKey, $identity, $identity);
  @override
  String toString() {
    return DuplicatedUniqueKeyMapper.ensureInitialized()
        .stringifyValue(this as DuplicatedUniqueKey);
  }

  @override
  bool operator ==(Object other) {
    return DuplicatedUniqueKeyMapper.ensureInitialized()
        .equalsValue(this as DuplicatedUniqueKey, other);
  }

  @override
  int get hashCode {
    return DuplicatedUniqueKeyMapper.ensureInitialized()
        .hashValue(this as DuplicatedUniqueKey);
  }
}

extension DuplicatedUniqueKeyValueCopy<$R, $Out>
    on ObjectCopyWith<$R, DuplicatedUniqueKey, $Out> {
  DuplicatedUniqueKeyCopyWith<$R, DuplicatedUniqueKey, $Out>
      get $asDuplicatedUniqueKey =>
          $base.as((v, t, t2) => _DuplicatedUniqueKeyCopyWithImpl(v, t, t2));
}

abstract class DuplicatedUniqueKeyCopyWith<$R, $In extends DuplicatedUniqueKey,
    $Out> implements ValidationErrorCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get key;
  ListCopyWith<$R, int, ObjectCopyWith<$R, int, int>> get rowIndex;
  @override
  $R call({String? name, List<String>? key, List<int>? rowIndex});
  DuplicatedUniqueKeyCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _DuplicatedUniqueKeyCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, DuplicatedUniqueKey, $Out>
    implements DuplicatedUniqueKeyCopyWith<$R, DuplicatedUniqueKey, $Out> {
  _DuplicatedUniqueKeyCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<DuplicatedUniqueKey> $mapper =
      DuplicatedUniqueKeyMapper.ensureInitialized();
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get key =>
      ListCopyWith($value.key, (v, t) => ObjectCopyWith(v, $identity, t),
          (v) => call(key: v));
  @override
  ListCopyWith<$R, int, ObjectCopyWith<$R, int, int>> get rowIndex =>
      ListCopyWith($value.rowIndex, (v, t) => ObjectCopyWith(v, $identity, t),
          (v) => call(rowIndex: v));
  @override
  $R call({String? name, List<String>? key, List<int>? rowIndex}) =>
      $apply(FieldCopyWithData({
        if (name != null) #name: name,
        if (key != null) #key: key,
        if (rowIndex != null) #rowIndex: rowIndex
      }));
  @override
  DuplicatedUniqueKey $make(CopyWithData data) => DuplicatedUniqueKey(
      data.get(#name, or: $value.name),
      data.get(#key, or: $value.key),
      data.get(#rowIndex, or: $value.rowIndex));

  @override
  DuplicatedUniqueKeyCopyWith<$R2, DuplicatedUniqueKey, $Out2>
      $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
          _DuplicatedUniqueKeyCopyWithImpl($value, $cast, t);
}

class FieldHasNoTypeMatchMapper
    extends SubClassMapperBase<FieldHasNoTypeMatch> {
  FieldHasNoTypeMatchMapper._();

  static FieldHasNoTypeMatchMapper? _instance;
  static FieldHasNoTypeMatchMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FieldHasNoTypeMatchMapper._());
      ValidationErrorMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'FieldHasNoTypeMatch';

  static int _$rowIndex(FieldHasNoTypeMatch v) => v.rowIndex;
  static const Field<FieldHasNoTypeMatch, int> _f$rowIndex =
      Field('rowIndex', _$rowIndex, key: 'row_index');
  static int _$columnIndex(FieldHasNoTypeMatch v) => v.columnIndex;
  static const Field<FieldHasNoTypeMatch, int> _f$columnIndex =
      Field('columnIndex', _$columnIndex, key: 'column_index');
  static String _$type(FieldHasNoTypeMatch v) => v.type;
  static const Field<FieldHasNoTypeMatch, String> _f$type =
      Field('type', _$type);

  @override
  final MappableFields<FieldHasNoTypeMatch> fields = const {
    #rowIndex: _f$rowIndex,
    #columnIndex: _f$columnIndex,
    #type: _f$type,
  };

  @override
  final String discriminatorKey = 'kind';
  @override
  final dynamic discriminatorValue = 'FieldHasNoTypeMatch';
  @override
  late final ClassMapperBase superMapper =
      ValidationErrorMapper.ensureInitialized();

  static FieldHasNoTypeMatch _instantiate(DecodingData data) {
    return FieldHasNoTypeMatch(
        data.dec(_f$rowIndex), data.dec(_f$columnIndex), data.dec(_f$type));
  }

  @override
  final Function instantiate = _instantiate;

  static FieldHasNoTypeMatch fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FieldHasNoTypeMatch>(map);
  }

  static FieldHasNoTypeMatch fromJson(String json) {
    return ensureInitialized().decodeJson<FieldHasNoTypeMatch>(json);
  }
}

mixin FieldHasNoTypeMatchMappable {
  String toJson() {
    return FieldHasNoTypeMatchMapper.ensureInitialized()
        .encodeJson<FieldHasNoTypeMatch>(this as FieldHasNoTypeMatch);
  }

  Map<String, dynamic> toMap() {
    return FieldHasNoTypeMatchMapper.ensureInitialized()
        .encodeMap<FieldHasNoTypeMatch>(this as FieldHasNoTypeMatch);
  }

  FieldHasNoTypeMatchCopyWith<FieldHasNoTypeMatch, FieldHasNoTypeMatch,
          FieldHasNoTypeMatch>
      get copyWith => _FieldHasNoTypeMatchCopyWithImpl(
          this as FieldHasNoTypeMatch, $identity, $identity);
  @override
  String toString() {
    return FieldHasNoTypeMatchMapper.ensureInitialized()
        .stringifyValue(this as FieldHasNoTypeMatch);
  }

  @override
  bool operator ==(Object other) {
    return FieldHasNoTypeMatchMapper.ensureInitialized()
        .equalsValue(this as FieldHasNoTypeMatch, other);
  }

  @override
  int get hashCode {
    return FieldHasNoTypeMatchMapper.ensureInitialized()
        .hashValue(this as FieldHasNoTypeMatch);
  }
}

extension FieldHasNoTypeMatchValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FieldHasNoTypeMatch, $Out> {
  FieldHasNoTypeMatchCopyWith<$R, FieldHasNoTypeMatch, $Out>
      get $asFieldHasNoTypeMatch =>
          $base.as((v, t, t2) => _FieldHasNoTypeMatchCopyWithImpl(v, t, t2));
}

abstract class FieldHasNoTypeMatchCopyWith<$R, $In extends FieldHasNoTypeMatch,
    $Out> implements ValidationErrorCopyWith<$R, $In, $Out> {
  @override
  $R call({int? rowIndex, int? columnIndex, String? type});
  FieldHasNoTypeMatchCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _FieldHasNoTypeMatchCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FieldHasNoTypeMatch, $Out>
    implements FieldHasNoTypeMatchCopyWith<$R, FieldHasNoTypeMatch, $Out> {
  _FieldHasNoTypeMatchCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FieldHasNoTypeMatch> $mapper =
      FieldHasNoTypeMatchMapper.ensureInitialized();
  @override
  $R call({int? rowIndex, int? columnIndex, String? type}) =>
      $apply(FieldCopyWithData({
        if (rowIndex != null) #rowIndex: rowIndex,
        if (columnIndex != null) #columnIndex: columnIndex,
        if (type != null) #type: type
      }));
  @override
  FieldHasNoTypeMatch $make(CopyWithData data) => FieldHasNoTypeMatch(
      data.get(#rowIndex, or: $value.rowIndex),
      data.get(#columnIndex, or: $value.columnIndex),
      data.get(#type, or: $value.type));

  @override
  FieldHasNoTypeMatchCopyWith<$R2, FieldHasNoTypeMatch, $Out2>
      $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
          _FieldHasNoTypeMatchCopyWithImpl($value, $cast, t);
}

class FieldHasNoRegexMatchMapper
    extends SubClassMapperBase<FieldHasNoRegexMatch> {
  FieldHasNoRegexMatchMapper._();

  static FieldHasNoRegexMatchMapper? _instance;
  static FieldHasNoRegexMatchMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FieldHasNoRegexMatchMapper._());
      ValidationErrorMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'FieldHasNoRegexMatch';

  static int _$rowIndex(FieldHasNoRegexMatch v) => v.rowIndex;
  static const Field<FieldHasNoRegexMatch, int> _f$rowIndex =
      Field('rowIndex', _$rowIndex, key: 'row_index');
  static int _$columnIndex(FieldHasNoRegexMatch v) => v.columnIndex;
  static const Field<FieldHasNoRegexMatch, int> _f$columnIndex =
      Field('columnIndex', _$columnIndex, key: 'column_index');
  static String _$regex(FieldHasNoRegexMatch v) => v.regex;
  static const Field<FieldHasNoRegexMatch, String> _f$regex =
      Field('regex', _$regex);

  @override
  final MappableFields<FieldHasNoRegexMatch> fields = const {
    #rowIndex: _f$rowIndex,
    #columnIndex: _f$columnIndex,
    #regex: _f$regex,
  };

  @override
  final String discriminatorKey = 'kind';
  @override
  final dynamic discriminatorValue = 'FieldHasNoRegexMatch';
  @override
  late final ClassMapperBase superMapper =
      ValidationErrorMapper.ensureInitialized();

  static FieldHasNoRegexMatch _instantiate(DecodingData data) {
    return FieldHasNoRegexMatch(
        data.dec(_f$rowIndex), data.dec(_f$columnIndex), data.dec(_f$regex));
  }

  @override
  final Function instantiate = _instantiate;

  static FieldHasNoRegexMatch fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FieldHasNoRegexMatch>(map);
  }

  static FieldHasNoRegexMatch fromJson(String json) {
    return ensureInitialized().decodeJson<FieldHasNoRegexMatch>(json);
  }
}

mixin FieldHasNoRegexMatchMappable {
  String toJson() {
    return FieldHasNoRegexMatchMapper.ensureInitialized()
        .encodeJson<FieldHasNoRegexMatch>(this as FieldHasNoRegexMatch);
  }

  Map<String, dynamic> toMap() {
    return FieldHasNoRegexMatchMapper.ensureInitialized()
        .encodeMap<FieldHasNoRegexMatch>(this as FieldHasNoRegexMatch);
  }

  FieldHasNoRegexMatchCopyWith<FieldHasNoRegexMatch, FieldHasNoRegexMatch,
          FieldHasNoRegexMatch>
      get copyWith => _FieldHasNoRegexMatchCopyWithImpl(
          this as FieldHasNoRegexMatch, $identity, $identity);
  @override
  String toString() {
    return FieldHasNoRegexMatchMapper.ensureInitialized()
        .stringifyValue(this as FieldHasNoRegexMatch);
  }

  @override
  bool operator ==(Object other) {
    return FieldHasNoRegexMatchMapper.ensureInitialized()
        .equalsValue(this as FieldHasNoRegexMatch, other);
  }

  @override
  int get hashCode {
    return FieldHasNoRegexMatchMapper.ensureInitialized()
        .hashValue(this as FieldHasNoRegexMatch);
  }
}

extension FieldHasNoRegexMatchValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FieldHasNoRegexMatch, $Out> {
  FieldHasNoRegexMatchCopyWith<$R, FieldHasNoRegexMatch, $Out>
      get $asFieldHasNoRegexMatch =>
          $base.as((v, t, t2) => _FieldHasNoRegexMatchCopyWithImpl(v, t, t2));
}

abstract class FieldHasNoRegexMatchCopyWith<
    $R,
    $In extends FieldHasNoRegexMatch,
    $Out> implements ValidationErrorCopyWith<$R, $In, $Out> {
  @override
  $R call({int? rowIndex, int? columnIndex, String? regex});
  FieldHasNoRegexMatchCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _FieldHasNoRegexMatchCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FieldHasNoRegexMatch, $Out>
    implements FieldHasNoRegexMatchCopyWith<$R, FieldHasNoRegexMatch, $Out> {
  _FieldHasNoRegexMatchCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FieldHasNoRegexMatch> $mapper =
      FieldHasNoRegexMatchMapper.ensureInitialized();
  @override
  $R call({int? rowIndex, int? columnIndex, String? regex}) =>
      $apply(FieldCopyWithData({
        if (rowIndex != null) #rowIndex: rowIndex,
        if (columnIndex != null) #columnIndex: columnIndex,
        if (regex != null) #regex: regex
      }));
  @override
  FieldHasNoRegexMatch $make(CopyWithData data) => FieldHasNoRegexMatch(
      data.get(#rowIndex, or: $value.rowIndex),
      data.get(#columnIndex, or: $value.columnIndex),
      data.get(#regex, or: $value.regex));

  @override
  FieldHasNoRegexMatchCopyWith<$R2, FieldHasNoRegexMatch, $Out2>
      $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
          _FieldHasNoRegexMatchCopyWithImpl($value, $cast, t);
}

class EmptyFieldNotAllowedMapper
    extends SubClassMapperBase<EmptyFieldNotAllowed> {
  EmptyFieldNotAllowedMapper._();

  static EmptyFieldNotAllowedMapper? _instance;
  static EmptyFieldNotAllowedMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = EmptyFieldNotAllowedMapper._());
      ValidationErrorMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'EmptyFieldNotAllowed';

  static int _$rowIndex(EmptyFieldNotAllowed v) => v.rowIndex;
  static const Field<EmptyFieldNotAllowed, int> _f$rowIndex =
      Field('rowIndex', _$rowIndex, key: 'row_index');
  static int _$columnIndex(EmptyFieldNotAllowed v) => v.columnIndex;
  static const Field<EmptyFieldNotAllowed, int> _f$columnIndex =
      Field('columnIndex', _$columnIndex, key: 'column_index');

  @override
  final MappableFields<EmptyFieldNotAllowed> fields = const {
    #rowIndex: _f$rowIndex,
    #columnIndex: _f$columnIndex,
  };

  @override
  final String discriminatorKey = 'kind';
  @override
  final dynamic discriminatorValue = 'EmptyFieldNotAllowed';
  @override
  late final ClassMapperBase superMapper =
      ValidationErrorMapper.ensureInitialized();

  static EmptyFieldNotAllowed _instantiate(DecodingData data) {
    return EmptyFieldNotAllowed(
        data.dec(_f$rowIndex), data.dec(_f$columnIndex));
  }

  @override
  final Function instantiate = _instantiate;

  static EmptyFieldNotAllowed fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<EmptyFieldNotAllowed>(map);
  }

  static EmptyFieldNotAllowed fromJson(String json) {
    return ensureInitialized().decodeJson<EmptyFieldNotAllowed>(json);
  }
}

mixin EmptyFieldNotAllowedMappable {
  String toJson() {
    return EmptyFieldNotAllowedMapper.ensureInitialized()
        .encodeJson<EmptyFieldNotAllowed>(this as EmptyFieldNotAllowed);
  }

  Map<String, dynamic> toMap() {
    return EmptyFieldNotAllowedMapper.ensureInitialized()
        .encodeMap<EmptyFieldNotAllowed>(this as EmptyFieldNotAllowed);
  }

  EmptyFieldNotAllowedCopyWith<EmptyFieldNotAllowed, EmptyFieldNotAllowed,
          EmptyFieldNotAllowed>
      get copyWith => _EmptyFieldNotAllowedCopyWithImpl(
          this as EmptyFieldNotAllowed, $identity, $identity);
  @override
  String toString() {
    return EmptyFieldNotAllowedMapper.ensureInitialized()
        .stringifyValue(this as EmptyFieldNotAllowed);
  }

  @override
  bool operator ==(Object other) {
    return EmptyFieldNotAllowedMapper.ensureInitialized()
        .equalsValue(this as EmptyFieldNotAllowed, other);
  }

  @override
  int get hashCode {
    return EmptyFieldNotAllowedMapper.ensureInitialized()
        .hashValue(this as EmptyFieldNotAllowed);
  }
}

extension EmptyFieldNotAllowedValueCopy<$R, $Out>
    on ObjectCopyWith<$R, EmptyFieldNotAllowed, $Out> {
  EmptyFieldNotAllowedCopyWith<$R, EmptyFieldNotAllowed, $Out>
      get $asEmptyFieldNotAllowed =>
          $base.as((v, t, t2) => _EmptyFieldNotAllowedCopyWithImpl(v, t, t2));
}

abstract class EmptyFieldNotAllowedCopyWith<
    $R,
    $In extends EmptyFieldNotAllowed,
    $Out> implements ValidationErrorCopyWith<$R, $In, $Out> {
  @override
  $R call({int? rowIndex, int? columnIndex});
  EmptyFieldNotAllowedCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _EmptyFieldNotAllowedCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, EmptyFieldNotAllowed, $Out>
    implements EmptyFieldNotAllowedCopyWith<$R, EmptyFieldNotAllowed, $Out> {
  _EmptyFieldNotAllowedCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<EmptyFieldNotAllowed> $mapper =
      EmptyFieldNotAllowedMapper.ensureInitialized();
  @override
  $R call({int? rowIndex, int? columnIndex}) => $apply(FieldCopyWithData({
        if (rowIndex != null) #rowIndex: rowIndex,
        if (columnIndex != null) #columnIndex: columnIndex
      }));
  @override
  EmptyFieldNotAllowed $make(CopyWithData data) => EmptyFieldNotAllowed(
      data.get(#rowIndex, or: $value.rowIndex),
      data.get(#columnIndex, or: $value.columnIndex));

  @override
  EmptyFieldNotAllowedCopyWith<$R2, EmptyFieldNotAllowed, $Out2>
      $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
          _EmptyFieldNotAllowedCopyWithImpl($value, $cast, t);
}

class ForeignKeyReferenceNotUniqueInForeignColumnsMapper
    extends SubClassMapperBase<ForeignKeyReferenceNotUniqueInForeignColumns> {
  ForeignKeyReferenceNotUniqueInForeignColumnsMapper._();

  static ForeignKeyReferenceNotUniqueInForeignColumnsMapper? _instance;
  static ForeignKeyReferenceNotUniqueInForeignColumnsMapper
      ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
          _instance = ForeignKeyReferenceNotUniqueInForeignColumnsMapper._());
      ValidationErrorMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'ForeignKeyReferenceNotUniqueInForeignColumns';

  static String _$name(ForeignKeyReferenceNotUniqueInForeignColumns v) =>
      v.name;
  static const Field<ForeignKeyReferenceNotUniqueInForeignColumns, String>
      _f$name = Field('name', _$name);

  @override
  final MappableFields<ForeignKeyReferenceNotUniqueInForeignColumns> fields =
      const {
    #name: _f$name,
  };

  @override
  final String discriminatorKey = 'kind';
  @override
  final dynamic discriminatorValue =
      'ForeignKeyReferenceNotUniqueInForeignColumns';
  @override
  late final ClassMapperBase superMapper =
      ValidationErrorMapper.ensureInitialized();

  static ForeignKeyReferenceNotUniqueInForeignColumns _instantiate(
      DecodingData data) {
    return ForeignKeyReferenceNotUniqueInForeignColumns(data.dec(_f$name));
  }

  @override
  final Function instantiate = _instantiate;

  static ForeignKeyReferenceNotUniqueInForeignColumns fromMap(
      Map<String, dynamic> map) {
    return ensureInitialized()
        .decodeMap<ForeignKeyReferenceNotUniqueInForeignColumns>(map);
  }

  static ForeignKeyReferenceNotUniqueInForeignColumns fromJson(String json) {
    return ensureInitialized()
        .decodeJson<ForeignKeyReferenceNotUniqueInForeignColumns>(json);
  }
}

mixin ForeignKeyReferenceNotUniqueInForeignColumnsMappable {
  String toJson() {
    return ForeignKeyReferenceNotUniqueInForeignColumnsMapper
            .ensureInitialized()
        .encodeJson<ForeignKeyReferenceNotUniqueInForeignColumns>(
            this as ForeignKeyReferenceNotUniqueInForeignColumns);
  }

  Map<String, dynamic> toMap() {
    return ForeignKeyReferenceNotUniqueInForeignColumnsMapper
            .ensureInitialized()
        .encodeMap<ForeignKeyReferenceNotUniqueInForeignColumns>(
            this as ForeignKeyReferenceNotUniqueInForeignColumns);
  }

  ForeignKeyReferenceNotUniqueInForeignColumnsCopyWith<
          ForeignKeyReferenceNotUniqueInForeignColumns,
          ForeignKeyReferenceNotUniqueInForeignColumns,
          ForeignKeyReferenceNotUniqueInForeignColumns>
      get copyWith => _ForeignKeyReferenceNotUniqueInForeignColumnsCopyWithImpl(
          this as ForeignKeyReferenceNotUniqueInForeignColumns,
          $identity,
          $identity);
  @override
  String toString() {
    return ForeignKeyReferenceNotUniqueInForeignColumnsMapper
            .ensureInitialized()
        .stringifyValue(this as ForeignKeyReferenceNotUniqueInForeignColumns);
  }

  @override
  bool operator ==(Object other) {
    return ForeignKeyReferenceNotUniqueInForeignColumnsMapper
            .ensureInitialized()
        .equalsValue(
            this as ForeignKeyReferenceNotUniqueInForeignColumns, other);
  }

  @override
  int get hashCode {
    return ForeignKeyReferenceNotUniqueInForeignColumnsMapper
            .ensureInitialized()
        .hashValue(this as ForeignKeyReferenceNotUniqueInForeignColumns);
  }
}

extension ForeignKeyReferenceNotUniqueInForeignColumnsValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ForeignKeyReferenceNotUniqueInForeignColumns, $Out> {
  ForeignKeyReferenceNotUniqueInForeignColumnsCopyWith<
      $R,
      ForeignKeyReferenceNotUniqueInForeignColumns,
      $Out> get $asForeignKeyReferenceNotUniqueInForeignColumns => $base.as((v,
          t, t2) =>
      _ForeignKeyReferenceNotUniqueInForeignColumnsCopyWithImpl(v, t, t2));
}

abstract class ForeignKeyReferenceNotUniqueInForeignColumnsCopyWith<
    $R,
    $In extends ForeignKeyReferenceNotUniqueInForeignColumns,
    $Out> implements ValidationErrorCopyWith<$R, $In, $Out> {
  @override
  $R call({String? name});
  ForeignKeyReferenceNotUniqueInForeignColumnsCopyWith<$R2, $In, $Out2>
      $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _ForeignKeyReferenceNotUniqueInForeignColumnsCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ForeignKeyReferenceNotUniqueInForeignColumns,
        $Out>
    implements
        ForeignKeyReferenceNotUniqueInForeignColumnsCopyWith<$R,
            ForeignKeyReferenceNotUniqueInForeignColumns, $Out> {
  _ForeignKeyReferenceNotUniqueInForeignColumnsCopyWithImpl(
      super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ForeignKeyReferenceNotUniqueInForeignColumns>
      $mapper =
      ForeignKeyReferenceNotUniqueInForeignColumnsMapper.ensureInitialized();
  @override
  $R call({String? name}) =>
      $apply(FieldCopyWithData({if (name != null) #name: name}));
  @override
  ForeignKeyReferenceNotUniqueInForeignColumns $make(CopyWithData data) =>
      ForeignKeyReferenceNotUniqueInForeignColumns(
          data.get(#name, or: $value.name));

  @override
  ForeignKeyReferenceNotUniqueInForeignColumnsCopyWith<$R2,
      ForeignKeyReferenceNotUniqueInForeignColumns, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _ForeignKeyReferenceNotUniqueInForeignColumnsCopyWithImpl(
          $value, $cast, t);
}

class ForeignKeyReferenceColumnNotInForeignColumnsMapper
    extends SubClassMapperBase<ForeignKeyReferenceColumnNotInForeignColumns> {
  ForeignKeyReferenceColumnNotInForeignColumnsMapper._();

  static ForeignKeyReferenceColumnNotInForeignColumnsMapper? _instance;
  static ForeignKeyReferenceColumnNotInForeignColumnsMapper
      ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
          _instance = ForeignKeyReferenceColumnNotInForeignColumnsMapper._());
      ValidationErrorMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'ForeignKeyReferenceColumnNotInForeignColumns';

  static String _$name(ForeignKeyReferenceColumnNotInForeignColumns v) =>
      v.name;
  static const Field<ForeignKeyReferenceColumnNotInForeignColumns, String>
      _f$name = Field('name', _$name);
  static String _$referenceColumn(
          ForeignKeyReferenceColumnNotInForeignColumns v) =>
      v.referenceColumn;
  static const Field<ForeignKeyReferenceColumnNotInForeignColumns, String>
      _f$referenceColumn =
      Field('referenceColumn', _$referenceColumn, key: 'reference_column');

  @override
  final MappableFields<ForeignKeyReferenceColumnNotInForeignColumns> fields =
      const {
    #name: _f$name,
    #referenceColumn: _f$referenceColumn,
  };

  @override
  final String discriminatorKey = 'kind';
  @override
  final dynamic discriminatorValue =
      'ForeignKeyReferenceColumnNotInForeignColumns';
  @override
  late final ClassMapperBase superMapper =
      ValidationErrorMapper.ensureInitialized();

  static ForeignKeyReferenceColumnNotInForeignColumns _instantiate(
      DecodingData data) {
    return ForeignKeyReferenceColumnNotInForeignColumns(
        data.dec(_f$name), data.dec(_f$referenceColumn));
  }

  @override
  final Function instantiate = _instantiate;

  static ForeignKeyReferenceColumnNotInForeignColumns fromMap(
      Map<String, dynamic> map) {
    return ensureInitialized()
        .decodeMap<ForeignKeyReferenceColumnNotInForeignColumns>(map);
  }

  static ForeignKeyReferenceColumnNotInForeignColumns fromJson(String json) {
    return ensureInitialized()
        .decodeJson<ForeignKeyReferenceColumnNotInForeignColumns>(json);
  }
}

mixin ForeignKeyReferenceColumnNotInForeignColumnsMappable {
  String toJson() {
    return ForeignKeyReferenceColumnNotInForeignColumnsMapper
            .ensureInitialized()
        .encodeJson<ForeignKeyReferenceColumnNotInForeignColumns>(
            this as ForeignKeyReferenceColumnNotInForeignColumns);
  }

  Map<String, dynamic> toMap() {
    return ForeignKeyReferenceColumnNotInForeignColumnsMapper
            .ensureInitialized()
        .encodeMap<ForeignKeyReferenceColumnNotInForeignColumns>(
            this as ForeignKeyReferenceColumnNotInForeignColumns);
  }

  ForeignKeyReferenceColumnNotInForeignColumnsCopyWith<
          ForeignKeyReferenceColumnNotInForeignColumns,
          ForeignKeyReferenceColumnNotInForeignColumns,
          ForeignKeyReferenceColumnNotInForeignColumns>
      get copyWith => _ForeignKeyReferenceColumnNotInForeignColumnsCopyWithImpl(
          this as ForeignKeyReferenceColumnNotInForeignColumns,
          $identity,
          $identity);
  @override
  String toString() {
    return ForeignKeyReferenceColumnNotInForeignColumnsMapper
            .ensureInitialized()
        .stringifyValue(this as ForeignKeyReferenceColumnNotInForeignColumns);
  }

  @override
  bool operator ==(Object other) {
    return ForeignKeyReferenceColumnNotInForeignColumnsMapper
            .ensureInitialized()
        .equalsValue(
            this as ForeignKeyReferenceColumnNotInForeignColumns, other);
  }

  @override
  int get hashCode {
    return ForeignKeyReferenceColumnNotInForeignColumnsMapper
            .ensureInitialized()
        .hashValue(this as ForeignKeyReferenceColumnNotInForeignColumns);
  }
}

extension ForeignKeyReferenceColumnNotInForeignColumnsValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ForeignKeyReferenceColumnNotInForeignColumns, $Out> {
  ForeignKeyReferenceColumnNotInForeignColumnsCopyWith<
      $R,
      ForeignKeyReferenceColumnNotInForeignColumns,
      $Out> get $asForeignKeyReferenceColumnNotInForeignColumns => $base.as((v,
          t, t2) =>
      _ForeignKeyReferenceColumnNotInForeignColumnsCopyWithImpl(v, t, t2));
}

abstract class ForeignKeyReferenceColumnNotInForeignColumnsCopyWith<
    $R,
    $In extends ForeignKeyReferenceColumnNotInForeignColumns,
    $Out> implements ValidationErrorCopyWith<$R, $In, $Out> {
  @override
  $R call({String? name, String? referenceColumn});
  ForeignKeyReferenceColumnNotInForeignColumnsCopyWith<$R2, $In, $Out2>
      $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _ForeignKeyReferenceColumnNotInForeignColumnsCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ForeignKeyReferenceColumnNotInForeignColumns,
        $Out>
    implements
        ForeignKeyReferenceColumnNotInForeignColumnsCopyWith<$R,
            ForeignKeyReferenceColumnNotInForeignColumns, $Out> {
  _ForeignKeyReferenceColumnNotInForeignColumnsCopyWithImpl(
      super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ForeignKeyReferenceColumnNotInForeignColumns>
      $mapper =
      ForeignKeyReferenceColumnNotInForeignColumnsMapper.ensureInitialized();
  @override
  $R call({String? name, String? referenceColumn}) => $apply(FieldCopyWithData({
        if (name != null) #name: name,
        if (referenceColumn != null) #referenceColumn: referenceColumn
      }));
  @override
  ForeignKeyReferenceColumnNotInForeignColumns $make(CopyWithData data) =>
      ForeignKeyReferenceColumnNotInForeignColumns(
          data.get(#name, or: $value.name),
          data.get(#referenceColumn, or: $value.referenceColumn));

  @override
  ForeignKeyReferenceColumnNotInForeignColumnsCopyWith<$R2,
      ForeignKeyReferenceColumnNotInForeignColumns, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _ForeignKeyReferenceColumnNotInForeignColumnsCopyWithImpl(
          $value, $cast, t);
}

class ForeignKeyViolationMapper
    extends SubClassMapperBase<ForeignKeyViolation> {
  ForeignKeyViolationMapper._();

  static ForeignKeyViolationMapper? _instance;
  static ForeignKeyViolationMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ForeignKeyViolationMapper._());
      ValidationErrorMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'ForeignKeyViolation';

  static String _$name(ForeignKeyViolation v) => v.name;
  static const Field<ForeignKeyViolation, String> _f$name =
      Field('name', _$name);
  static int _$rowIndex(ForeignKeyViolation v) => v.rowIndex;
  static const Field<ForeignKeyViolation, int> _f$rowIndex =
      Field('rowIndex', _$rowIndex, key: 'row_index');
  static List<String> _$baseKey(ForeignKeyViolation v) => v.baseKey;
  static const Field<ForeignKeyViolation, List<String>> _f$baseKey =
      Field('baseKey', _$baseKey, key: 'base_key');

  @override
  final MappableFields<ForeignKeyViolation> fields = const {
    #name: _f$name,
    #rowIndex: _f$rowIndex,
    #baseKey: _f$baseKey,
  };

  @override
  final String discriminatorKey = 'kind';
  @override
  final dynamic discriminatorValue = 'ForeignKeyViolation';
  @override
  late final ClassMapperBase superMapper =
      ValidationErrorMapper.ensureInitialized();

  static ForeignKeyViolation _instantiate(DecodingData data) {
    return ForeignKeyViolation(
        data.dec(_f$name), data.dec(_f$rowIndex), data.dec(_f$baseKey));
  }

  @override
  final Function instantiate = _instantiate;

  static ForeignKeyViolation fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ForeignKeyViolation>(map);
  }

  static ForeignKeyViolation fromJson(String json) {
    return ensureInitialized().decodeJson<ForeignKeyViolation>(json);
  }
}

mixin ForeignKeyViolationMappable {
  String toJson() {
    return ForeignKeyViolationMapper.ensureInitialized()
        .encodeJson<ForeignKeyViolation>(this as ForeignKeyViolation);
  }

  Map<String, dynamic> toMap() {
    return ForeignKeyViolationMapper.ensureInitialized()
        .encodeMap<ForeignKeyViolation>(this as ForeignKeyViolation);
  }

  ForeignKeyViolationCopyWith<ForeignKeyViolation, ForeignKeyViolation,
          ForeignKeyViolation>
      get copyWith => _ForeignKeyViolationCopyWithImpl(
          this as ForeignKeyViolation, $identity, $identity);
  @override
  String toString() {
    return ForeignKeyViolationMapper.ensureInitialized()
        .stringifyValue(this as ForeignKeyViolation);
  }

  @override
  bool operator ==(Object other) {
    return ForeignKeyViolationMapper.ensureInitialized()
        .equalsValue(this as ForeignKeyViolation, other);
  }

  @override
  int get hashCode {
    return ForeignKeyViolationMapper.ensureInitialized()
        .hashValue(this as ForeignKeyViolation);
  }
}

extension ForeignKeyViolationValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ForeignKeyViolation, $Out> {
  ForeignKeyViolationCopyWith<$R, ForeignKeyViolation, $Out>
      get $asForeignKeyViolation =>
          $base.as((v, t, t2) => _ForeignKeyViolationCopyWithImpl(v, t, t2));
}

abstract class ForeignKeyViolationCopyWith<$R, $In extends ForeignKeyViolation,
    $Out> implements ValidationErrorCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get baseKey;
  @override
  $R call({String? name, int? rowIndex, List<String>? baseKey});
  ForeignKeyViolationCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _ForeignKeyViolationCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ForeignKeyViolation, $Out>
    implements ForeignKeyViolationCopyWith<$R, ForeignKeyViolation, $Out> {
  _ForeignKeyViolationCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ForeignKeyViolation> $mapper =
      ForeignKeyViolationMapper.ensureInitialized();
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get baseKey =>
      ListCopyWith($value.baseKey, (v, t) => ObjectCopyWith(v, $identity, t),
          (v) => call(baseKey: v));
  @override
  $R call({String? name, int? rowIndex, List<String>? baseKey}) =>
      $apply(FieldCopyWithData({
        if (name != null) #name: name,
        if (rowIndex != null) #rowIndex: rowIndex,
        if (baseKey != null) #baseKey: baseKey
      }));
  @override
  ForeignKeyViolation $make(CopyWithData data) => ForeignKeyViolation(
      data.get(#name, or: $value.name),
      data.get(#rowIndex, or: $value.rowIndex),
      data.get(#baseKey, or: $value.baseKey));

  @override
  ForeignKeyViolationCopyWith<$R2, ForeignKeyViolation, $Out2>
      $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
          _ForeignKeyViolationCopyWithImpl($value, $cast, t);
}
