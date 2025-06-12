import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:schema_editor/schema_editor/components/column_type_editor.dart';
import 'package:schema_editor/schema_editor/components/table_config_editor.dart';
import 'package:schema_editor/schema_editor/components/validation_editor.dart';
import 'package:schema_editor/schema/json_schema.dart';
import 'package:schema_editor/schema/schema.dart';
import 'package:schema_editor/schema/validate.dart';

class SchemaEditorApp extends StatelessWidget {
  const SchemaEditorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CSV Armor Schema Editor',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SchemaEditorHomePage(),
    );
  }
}

class SchemaEditorHomePage extends StatefulWidget {
  const SchemaEditorHomePage({super.key});

  @override
  State<SchemaEditorHomePage> createState() => _SchemaEditorHomePageState();
}

class _SchemaEditorHomePageState extends State<SchemaEditorHomePage> {
  late Schema _schema;
  late TextEditingController _filePathController;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _schema = Schema(columnType: {});
    _filePathController = TextEditingController();
  }

  @override
  void dispose() {
    _filePathController.dispose();
    super.dispose();
  }

  void _loadJson() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['json']);
    if (result != null && result.files.single.path != null) {
      final file = File(result.files.single.path!);
      final content = await file.readAsString();
      final schema = Schema.fromJson(jsonDecode(content));
      if (!mounted) return;
      setState(() {
        _schema = schema;
        _filePathController.text = result.files.single.path!;
      });
    }
    // Notify TableConfigEditor to update its state after loading new schema
    // This is handled by passing initialTableConfigs: _schema.tableConfig,
    // and TableConfigEditor should update when this changes.
  }

  void _saveJson() async {
    String? output = await FilePicker.platform.saveFile(
      dialogTitle: 'Save Schema As',
      fileName: 'schema.json',
      type: FileType.custom,
      allowedExtensions: ['json'],
    );
    if (output != null) {
      final file = File(output);
      await file.writeAsString(
          const JsonEncoder.withIndent('  ').convert(_schema.toJson()));
      setState(() {
        _filePathController.text = output;
      });
      if (!context.mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Schema saved!')));
    }
  }

  void _checkErrors() {
    final result = validateByJsonSchema(_schema)
      ..merge(validateSchema(_schema));
    if (result.errors.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("No errors found in schema!"),
      ));
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(MaterialLocalizations.of(context).alertDialogLabel),
            content: SizedBox(
              width: 500,
              child: ListView(
                shrinkWrap: true,
                children: result.errors
                    .map((e) => ListTile(
                          title: Text(e.message),
                          subtitle: Text(e.path.map((p) => '/$p').join()),
                        ))
                    .toList(),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  final errorText = const JsonEncoder.withIndent('  ')
                      .convert(result.toJson());
                  final filePath = await FilePicker.platform.saveFile(
                    dialogTitle: 'Save Validation Errors',
                    fileName: 'validation_errors.json',
                    type: FileType.custom,
                  );
                  if (filePath != null) {
                    final file = File(filePath);
                    await file.writeAsString(errorText);
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Validation errors saved!')),
                    );
                  }
                },
                child: const Text('Save as File'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(MaterialLocalizations.of(context).closeButtonLabel),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget mainContent;
    switch (_selectedIndex) {
      case 0:
        mainContent = TableConfigEditor(
          tableConfigs: _schema.tableConfig,
          onChanged: (tableConfigs) {
            setState(() {
              _schema = _schema.copyWith(
                  tableConfig: List<TableConfig>.from(tableConfigs));
            });
          },
          columnTypes: _schema.columnType, // Added
        );
        break;
      case 1:
        mainContent = ColumnTypeEditor(
          columnType: _schema.columnType,
          onChanged: (columnType) {
            setState(() {
              _schema = _schema.copyWith(
                  columnType: Map<String, String>.from(columnType));
            });
          },
        );
        break;
      case 2:
        mainContent = ValidationEditor(
          validations: _schema.validation,
          onChanged: (validations) {
            setState(() {
              _schema = _schema.copyWith(
                  validation: List<Validation>.from(validations));
            });
          },
        );
        break;
      default:
        mainContent =
            const Center(child: Text('Select an item from the sidebar'));
    }
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Text('CSV Armor Schema Editor'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.error),
            tooltip: 'Check Errors',
            onPressed: _checkErrors,
          ),
          IconButton(
            icon: const Icon(Icons.folder_open),
            tooltip: 'Open',
            onPressed: _loadJson,
          ),
          IconButton(
            icon: const Icon(Icons.save),
            tooltip: 'Save',
            onPressed: _saveJson,
          ),
        ],
      ),
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            labelType: NavigationRailLabelType.all,
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.table_view),
                label: Text('Table Config'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.format_list_bulleted),
                label: Text('Column Type'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.rule),
                label: Text('Validation'),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: mainContent,
          ),
        ],
      ),
    );
  }
}
