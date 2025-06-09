import 'dart:convert';
import 'dart:io';

import 'package:schema_editor/schema/schema.dart';
import 'package:schema_editor/schema/validate.dart';
import 'package:schema_editor/schema/json_schema.dart';

void main(List<String> args) async {
  if (args.length != 1) {
    stderr.writeln('Usage: dart validate_schema.dart <schema.json>');
    exit(2);
  }
  final filePath = args[0];
  try {
    final jsonString = await File(filePath).readAsString();
    final jsonMap = json.decode(jsonString) as Map<String, dynamic>;
    final schema = Schema.fromJson(jsonMap);

    final result = SchemaValidationResult();
    result.merge(validateByJsonSchema(schema));
    result.merge(validateSchema(schema));

    if (!result.isValid) {
      stdout.writeln(jsonEncode(result.toJson()));
      exit(1);
    }
  } catch (e, st) {
    stderr.writeln('Error: $e');
    stderr.writeln(st);
    exit(2);
  }
}
