import 'package:dart_mappable/dart_mappable.dart';
import 'package:yaml_edit/yaml_edit.dart';

part 'result.mapper.dart';

@MappableClass(caseStyle: CaseStyle.snakeCase)
class ValidationResult with ValidationResultMappable {
  ValidationResult({this.errors = const []});

  final List<ValidationError> errors;

  bool get valid => errors.isEmpty;

  @override
  String toString() =>
      (YamlEditor('')..update([], toMap()..putIfAbsent("valid", () => valid)))
          .toString();
}

@MappableClass(caseStyle: CaseStyle.snakeCase, discriminatorKey: 'kind')
sealed class ValidationError with ValidationErrorMappable {}

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  discriminatorValue: 'InvalidSchema',
)
class InvalidSchema extends ValidationError with InvalidSchemaMappable {
  InvalidSchema(this.schemaPath, this.code) : super();

  final String schemaPath;
  final String code;
}

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  discriminatorValue: 'InvalidCSV',
)
class InvalidCSV extends ValidationError with InvalidCSVMappable {
  InvalidCSV(this.csvPath, this.code) : super();

  final String csvPath;
  final String code;
}

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  discriminatorValue: 'TooFewHeaders',
)
class TooFewHeaders extends ValidationError with TooFewHeadersMappable {
  TooFewHeaders(this.actualHeaders) : super();

  final int actualHeaders;
}

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  discriminatorValue: 'ColumnCountMismatch',
)
class ColumnCountMismatch extends ValidationError
    with ColumnCountMismatchMappable {
  ColumnCountMismatch(this.rowIndex, this.actualColumns) : super();

  final int rowIndex;
  final int actualColumns;
}

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  discriminatorValue: 'DuplicatedPrimaryKey',
)
class DuplicatedPrimaryKey extends ValidationError
    with DuplicatedPrimaryKeyMappable {
  DuplicatedPrimaryKey(this.key, this.rowIndex) : super();

  final List<String> key;
  final List<int> rowIndex;
}

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  discriminatorValue: 'DuplicatedUniqueKey',
)
class DuplicatedUniqueKey extends ValidationError
    with DuplicatedUniqueKeyMappable {
  DuplicatedUniqueKey(this.name, this.key, this.rowIndex) : super();

  final String name;
  final List<String> key;
  final List<int> rowIndex;
}

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  discriminatorValue: 'FieldHasNoTypeMatch',
)
class FieldHasNoTypeMatch extends ValidationError
    with FieldHasNoTypeMatchMappable {
  FieldHasNoTypeMatch(this.rowIndex, this.columnIndex, this.type) : super();

  final int rowIndex;
  final int columnIndex;
  final String type;
}

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  discriminatorValue: 'FieldHasNoRegexMatch',
)
class FieldHasNoRegexMatch extends ValidationError
    with FieldHasNoRegexMatchMappable {
  FieldHasNoRegexMatch(this.rowIndex, this.columnIndex, this.regex) : super();

  final int rowIndex;
  final int columnIndex;
  final String regex;
}

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  discriminatorValue: 'EmptyFieldNotAllowed',
)
class EmptyFieldNotAllowed extends ValidationError
    with EmptyFieldNotAllowedMappable {
  EmptyFieldNotAllowed(this.rowIndex, this.columnIndex) : super();

  final int rowIndex;
  final int columnIndex;
}

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  discriminatorValue: 'ForeignKeyNonUniqueReference',
)
class ForeignKeyNonUniqueReference extends ValidationError
    with ForeignKeyNonUniqueReferenceMappable {
  ForeignKeyNonUniqueReference(this.name) : super();

  final String name;
}

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  discriminatorValue: 'ForeignKeyReferenceColumnNotInForeignColumns',
)
class ForeignKeyReferenceColumnNotInForeignColumns extends ValidationError
    with ForeignKeyReferenceColumnNotInForeignColumnsMappable {
  ForeignKeyReferenceColumnNotInForeignColumns(this.name, this.referenceColumn)
      : super();
  final String name;
  final String referenceColumn;
}

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  discriminatorValue: 'ForeignKeyNotFound',
)
class ForeignKeyNotFound extends ValidationError
    with ForeignKeyNotFoundMappable {
  ForeignKeyNotFound(this.name, this.rowIndex, this.baseKey) : super();

  final String name;
  final int rowIndex;
  final List<String> baseKey;
}
