import 'package:flutter/material.dart';

import '../models/schema.dart';
import 'table_config_columns_editor.dart';
import 'table_config_foreign_keys_editor.dart';
import 'table_config_primary_keys_editor.dart';
import 'table_config_unique_keys_editor.dart';

class TableConfigDetailsEditor extends StatefulWidget {
  final TableConfig config;
  final int index;
  final List<TableConfig> tableConfigs;
  final void Function(List<TableConfig>) onTableConfigsChanged;
  final Map<String, String> columnTypes; // Added

  const TableConfigDetailsEditor({
    super.key,
    required this.config,
    required this.index,
    required this.tableConfigs,
    required this.onTableConfigsChanged,
    required this.columnTypes, // Added
  });

  @override
  State<TableConfigDetailsEditor> createState() =>
      _TableConfigDetailsEditorState();
}

class _TableConfigDetailsEditorState extends State<TableConfigDetailsEditor> {
  void _editNameDialog(int index) async {
    final controller =
        TextEditingController(text: widget.tableConfigs[index].name);
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Table Name'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Table Name'),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (result != null && result.isNotEmpty) {
      final newConfigs = List<TableConfig>.from(widget.tableConfigs);
      newConfigs[index] = newConfigs[index].copyWith(name: result);
      widget.onTableConfigsChanged(newConfigs);
    }
  }

  void _editCsvPathDialog(int index) async {
    final controller =
        TextEditingController(text: widget.tableConfigs[index].csvPath);
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit CSV Path'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'CSV Path'),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (result != null && result.isNotEmpty) {
      final newConfigs = List<TableConfig>.from(widget.tableConfigs);
      newConfigs[index] = newConfigs[index].copyWith(csvPath: result);
      widget.onTableConfigsChanged(newConfigs);
    }
  }

  @override
  Widget build(BuildContext context) {
    final config = widget.config;
    final index = widget.index;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Name: ${config.name}'),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.edit),
                tooltip: 'Edit Name',
                onPressed: () => _editNameDialog(index),
              ),
            ],
          ),
          const Divider(),
          Row(
            children: [
              Text('CSV Path: ${config.csvPath}'),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.edit),
                tooltip: 'Edit CSV Path',
                onPressed: () => _editCsvPathDialog(index),
              ),
            ],
          ),
          const Divider(),
          TableConfigColumnsEditor(
            config: config,
            index: index,
            tableConfigs: widget.tableConfigs,
            onTableConfigsChanged: widget.onTableConfigsChanged,
            columnTypes: widget.columnTypes, // Added
          ),
          const Divider(),
          TableConfigPrimaryKeysEditor(
            config: config,
            index: index,
            tableConfigs: widget.tableConfigs,
            onTableConfigsChanged: widget.onTableConfigsChanged,
          ),
          const Divider(),
          TableConfigUniqueKeysEditor(
            config: config,
            index: index,
            tableConfigs: widget.tableConfigs,
            onTableConfigsChanged: widget.onTableConfigsChanged,
          ),
          const Divider(),
          TableConfigForeignKeysEditor(
            config: config,
            index: index,
            tableConfigs: widget.tableConfigs,
            onTableConfigsChanged: widget.onTableConfigsChanged,
          ),
        ],
      ),
    );
  }
}
