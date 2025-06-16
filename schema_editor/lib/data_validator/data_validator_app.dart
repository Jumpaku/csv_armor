import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:schema_editor/csv/decoder.dart';
import 'package:schema_editor/csv/decoder_config.dart';
import 'package:schema_editor/data/reader/csv_reader.dart';
import 'package:schema_editor/data/validate.dart' as data;
import 'package:schema_editor/schema/schema.dart' as schema;

class DataValidatorApp extends StatefulWidget {
  const DataValidatorApp({Key? key}) : super(key: key);

  @override
  State<DataValidatorApp> createState() => _DataValidatorAppState();
}

class _DataValidatorAppState extends State<DataValidatorApp> {
  String? schemaFilePath;
  String? workingDirectory;
  List<String> validationErrors = [];
  bool isValidating = false;

  Future<void> pickSchemaFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        initialDirectory: './Documents/csv_armor/schema_editor',
        type: FileType.custom,
        allowedExtensions: ['json', 'yaml', 'yml']);
    if (result != null && result.files.single.path != null) {
      setState(() {
        schemaFilePath = result.files.single.path;
      });
    }
  }

  Future<void> pickWorkingDirectory() async {
    String? selectedDir = await FilePicker.platform.getDirectoryPath(
        initialDirectory: './Documents/csv_armor/schema_editor');
    if (selectedDir != null) {
      setState(() {
        workingDirectory = selectedDir;
      });
    }
  }

  Future<void> validateData() async {
    if (schemaFilePath == null || workingDirectory == null) return;
    setState(() {
      isValidating = true;
      validationErrors.clear();
    });
    final content = await File(schemaFilePath!).readAsString();
    final s = schema.Schema.fromJson(jsonDecode(content));
    final d = s.decodeConfig;
    final r = CsvReader(
        ctx: path.Context(current: workingDirectory),
        decoder: Decoder(DecoderConfig(
          headerLines: d?.headerLines ?? 0,
          fieldSeparator: d?.fieldSeparator ?? "\t",
          recordSeparator: {
            schema.RecordSeparator.ANY: RecordSeparator.any,
            schema.RecordSeparator.CRLF: RecordSeparator.crlf,
            schema.RecordSeparator.CR: RecordSeparator.cr,
            schema.RecordSeparator.LF: RecordSeparator.lf,
          }[d?.recordSeparator ?? schema.RecordSeparator.ANY]!,
          fieldQuote: DecoderConfigQuote(
            leftQuote: d?.fieldQuote?.left ?? '',
            leftQuoteEscape: d?.fieldQuote?.leftEscape ?? '',
            rightQuote: d?.fieldQuote?.right ?? '',
            rightQuoteEscape: d?.fieldQuote?.rightEscape ?? '',
          ),
        )));
    final b = r.readAll(s.tableConfig);
    final v = data.validateData(s, b);

    setState(() {
      validationErrors = v.errors.map((e) => e.message).toList();
      isValidating = false;
    });
  }

  Future<void> saveValidationResult() async {
    if (validationErrors.isEmpty) return;
    String? outputPath = await FilePicker.platform.saveFile(
      initialDirectory: './Documents/csv_armor/schema_editor',
      dialogTitle: 'Save Validation Result',
      fileName: 'validation_errors.txt',
    );
    if (outputPath != null) {
      final file = File(outputPath);
      await file.writeAsString(validationErrors.join('\n'));
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Validation result saved.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Data Validator')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Schema File selector second
              Row(
                children: [
                  Expanded(
                    child: Text(schemaFilePath ?? 'No schema file selected'),
                  ),
                  ElevatedButton(
                    onPressed: pickSchemaFile,
                    child: const Text('Select Schema File'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Working Directory selector first
              Row(
                children: [
                  Expanded(
                    child: Text(
                        workingDirectory ?? 'No working directory selected'),
                  ),
                  ElevatedButton(
                    onPressed: pickWorkingDirectory,
                    child: const Text('Select Working Directory'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: (schemaFilePath != null &&
                            workingDirectory != null &&
                            !isValidating)
                        ? validateData
                        : null,
                    child: isValidating
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2))
                        : const Text('Start Validation'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: validationErrors.isNotEmpty
                        ? saveValidationResult
                        : null,
                    child: const Text('Save Validation Result'),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text('Validation Errors:'),
              Expanded(
                child: ListView.builder(
                  itemCount: validationErrors.length,
                  itemBuilder: (context, index) => ListTile(
                    leading: const Icon(Icons.error, color: Colors.red),
                    title: Text(validationErrors[index]),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



