import 'package:flutter/material.dart';

import '../models/schema.dart';

class TableConfigPrimaryKeysEditor extends StatelessWidget {
  final TableConfig config;
  final int index;
  final List<TableConfig> tableConfigs;
  final void Function(List<TableConfig>) onTableConfigsChanged;

  const TableConfigPrimaryKeysEditor({
    super.key,
    required this.config,
    required this.index,
    required this.tableConfigs,
    required this.onTableConfigsChanged,
  });

  void _editPrimaryKeyDialog(
      BuildContext context, int tableIdx, int pkIdx) async {
    final controller =
        TextEditingController(text: tableConfigs[tableIdx].primaryKey[pkIdx]);
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Primary Key'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Primary Key'),
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
      final newConfigs = List<TableConfig>.from(tableConfigs);
      final pk = List<String>.from(newConfigs[tableIdx].primaryKey);
      pk[pkIdx] = result;
      newConfigs[tableIdx] = newConfigs[tableIdx].copyWith(primaryKey: pk);
      onTableConfigsChanged(newConfigs);
    }
  }

  void _deletePrimaryKey(int tableIdx, int pkIdx) {
    final newConfigs = List<TableConfig>.from(tableConfigs);
    final pk = List<String>.from(newConfigs[tableIdx].primaryKey);
    pk.removeAt(pkIdx);
    newConfigs[tableIdx] = newConfigs[tableIdx].copyWith(primaryKey: pk);
    onTableConfigsChanged(newConfigs);
  }

  void _addPrimaryKey(BuildContext context, int tableIdx) async {
    final controller = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Primary Key'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Primary Key'),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: const Text('Add'),
          ),
        ],
      ),
    );
    if (result != null && result.isNotEmpty) {
      final newConfigs = List<TableConfig>.from(tableConfigs);
      final pk = List<String>.from(newConfigs[tableIdx].primaryKey);
      pk.add(result);
      newConfigs[tableIdx] = newConfigs[tableIdx].copyWith(primaryKey: pk);
      onTableConfigsChanged(newConfigs);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text('Primary Key:'),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.add),
              tooltip: 'Add Primary Key',
              onPressed: () => _addPrimaryKey(context, index),
            ),
          ],
        ),
        Column(
          children: config.primaryKey.indexed
              .map(
                (entry) => Row(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 16.0, top: 2, bottom: 2),
                      child: Text(entry.$2),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.edit),
                      tooltip: 'Edit Primary Key',
                      onPressed: () =>
                          _editPrimaryKeyDialog(context, index, entry.$1),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      tooltip: 'Delete Primary Key',
                      onPressed: () => _deletePrimaryKey(index, entry.$1),
                    ),
                  ],
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
