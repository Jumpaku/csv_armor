import 'package:flutter/material.dart';

import '../models/schema.dart';

class TableConfigUniqueKeysEditor extends StatelessWidget {
  final TableConfig config;
  final int index;
  final List<TableConfig> tableConfigs;
  final void Function(List<TableConfig>) onTableConfigsChanged;

  const TableConfigUniqueKeysEditor({
    super.key,
    required this.config,
    required this.index,
    required this.tableConfigs,
    required this.onTableConfigsChanged,
  });

  void _editUniqueKeyDialog(
      BuildContext context, int tableIdx, String key) async {
    final controller = TextEditingController(
        text: tableConfigs[tableIdx].uniqueKey[key]?.join(', ') ?? '');
    final result = await showDialog<List<String>>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Unique Key: $key'),
        content: TextField(
          controller: controller,
          decoration:
              const InputDecoration(labelText: 'Columns (comma separated)'),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () => Navigator.pop(
                context,
                controller.text
                    .split(',')
                    .map((s) => s.trim())
                    .where((s) => s.isNotEmpty)
                    .toList()),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (result != null) {
      final newConfigs = List<TableConfig>.from(tableConfigs);
      final uniqueKey =
          Map<String, List<String>>.from(newConfigs[tableIdx].uniqueKey);
      uniqueKey[key] = result;
      newConfigs[tableIdx] =
          newConfigs[tableIdx].copyWith(uniqueKey: uniqueKey);
      onTableConfigsChanged(newConfigs);
    }
  }

  void _deleteUniqueKey(int tableIdx, String key) {
    final newConfigs = List<TableConfig>.from(tableConfigs);
    final uniqueKey =
        Map<String, List<String>>.from(newConfigs[tableIdx].uniqueKey);
    uniqueKey.remove(key);
    newConfigs[tableIdx] = newConfigs[tableIdx].copyWith(uniqueKey: uniqueKey);
    onTableConfigsChanged(newConfigs);
  }

  void _addUniqueKey(BuildContext context, int tableIdx) async {
    final nameController = TextEditingController();
    final columnsController = TextEditingController();
    final result = await showDialog<MapEntry<String, List<String>>>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Unique Key'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Key Name'),
            ),
            TextField(
              controller: columnsController,
              decoration:
                  const InputDecoration(labelText: 'Columns (comma separated)'),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final name = nameController.text.trim();
              final columns = columnsController.text
                  .split(',')
                  .map((s) => s.trim())
                  .where((s) => s.isNotEmpty)
                  .toList();
              if (name.isNotEmpty && columns.isNotEmpty) {
                Navigator.pop(context, MapEntry(name, columns));
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
    if (result != null) {
      final newConfigs = List<TableConfig>.from(tableConfigs);
      final uniqueKey =
          Map<String, List<String>>.from(newConfigs[tableIdx].uniqueKey);
      uniqueKey[result.key] = result.value;
      newConfigs[tableIdx] =
          newConfigs[tableIdx].copyWith(uniqueKey: uniqueKey);
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
            const Text('Unique Keys:'),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.add),
              tooltip: 'Add Unique Key',
              onPressed: () => _addUniqueKey(context, index),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: config.uniqueKey.entries
              .map((e) => Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 16.0, top: 2, bottom: 2),
                        child: Text('${e.key}(${e.value.join(', ')})'),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        tooltip: 'Edit Unique Key',
                        onPressed: () =>
                            _editUniqueKeyDialog(context, index, e.key),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        tooltip: 'Delete Unique Key',
                        onPressed: () => _deleteUniqueKey(index, e.key),
                      ),
                    ],
                  ))
              .toList(),
        ),
      ],
    );
  }
}
