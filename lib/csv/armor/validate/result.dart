import 'package:csv_armor/errors/base_exception.dart';

class ValidationResult {
  ValidationResult({this.errors = const []});

  final List<ValidationError> errors;

  bool get valid => errors.isEmpty;
}

sealed class ValidationError {}

class InvalidSchema extends ValidationError {
  InvalidSchema(this.schemaPath, this.error) : super();
  final String schemaPath;
  final BaseException error;
}

class InvalidCSV extends ValidationError {
  InvalidCSV(this.csvPath, this.error) : super();
  final String csvPath;
  final BaseException error;
}

class TooFewHeaders extends ValidationError {
  TooFewHeaders(this.actualHeaders) : super();
  final int actualHeaders;
}

class ColumnCountMismatch extends ValidationError {
  ColumnCountMismatch(this.rowIndex, this.actualColumns) : super();
  final int rowIndex;
  final int actualColumns;
}

class DuplicatedPrimaryKey extends ValidationError {
  DuplicatedPrimaryKey(this.key, this.rowIndex) : super();
  final List<String> key;
  final Set<int> rowIndex;
}

class DuplicatedUniqueKey extends ValidationError {
  DuplicatedUniqueKey(this.name, this.key, this.rowIndex) : super();
  final String name;
  final List<String> key;
  final Set<int> rowIndex;
}

class InvalidFieldFormat extends ValidationError {
  InvalidFieldFormat(this.rowIndex, this.columnIndex, this.pattern) : super();
  final int rowIndex;
  final int columnIndex;
  final String pattern;
}

class ForeignKeyNonUniqueReference extends ValidationError {
  ForeignKeyNonUniqueReference(this.name) : super();
  final String name;
}

class ForeignKeyReferenceColumnNotInForeignColumns extends ValidationError {
  ForeignKeyReferenceColumnNotInForeignColumns(
      this.name, this.referenceColumnName)
      : super();
  final String name;
  final String referenceColumnName;
}

class ForeignKeyNotFound extends ValidationError {
  ForeignKeyNotFound(this.name, this.rowIndex, this.baseKey) : super();
  final String name;
  final int rowIndex;
  final List<String> baseKey;
}
