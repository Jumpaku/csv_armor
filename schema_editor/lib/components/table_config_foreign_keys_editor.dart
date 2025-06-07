import 'package:flutter/material.dart';

import '../models/schema.dart';

class TableConfigForeignKeysEditor extends StatelessWidget {
  final TableConfig config;
  final int index;
  final List<TableConfig> tableConfigs;
  final void Function(List<TableConfig>) onTableConfigsChanged;

  const TableConfigForeignKeysEditor({
    super.key,
    required this.config,
    required this.index,
    required this.tableConfigs,
    required this.onTableConfigsChanged,
  });

  void _editForeignKeyDialog(
      BuildContext context, int tableIdx, String key) async {
    final fk = tableConfigs[tableIdx].foreignKey[key]!;
    final columnsController =
        TextEditingController(text: fk.columns.join(', '));
    final refTableController = TextEditingController(text: fk.reference.table);
    final refKeyController =
        TextEditingController(text: fk.reference.uniqueKey.join(', '));
    final result = await showDialog<ForeignKey>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Foreign Key: $key'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: columnsController,
              decoration:
                  const InputDecoration(labelText: 'Columns (comma separated)'),
            ),
            TextField(
              controller: refTableController,
              decoration: const InputDecoration(labelText: 'Reference Table'),
            ),
            TextField(
              controller: refKeyController,
              decoration: const InputDecoration(
                  labelText: 'Reference Key (comma separated)'),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final columns = columnsController.text
                  .split(',')
                  .map((s) => s.trim())
                  .where((s) => s.isNotEmpty)
                  .toList();
              final refTable = refTableController.text.trim();
              final refKey = refKeyController.text
                  .split(',')
                  .map((s) => s.trim())
                  .where((s) => s.isNotEmpty)
                  .toList();
              if (columns.isNotEmpty &&
                  refTable.isNotEmpty &&
                  refKey.isNotEmpty) {
                Navigator.pop(
                    context,
                    ForeignKey(
                        columns: columns,
                        reference: ForeignKeyReference(
                            table: refTable, uniqueKey: refKey)));
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (result != null) {
      final newConfigs = List<TableConfig>.from(tableConfigs);
      final foreignKey =
          Map<String, ForeignKey>.from(newConfigs[tableIdx].foreignKey);
      foreignKey[key] = result;
      newConfigs[tableIdx] =
          newConfigs[tableIdx].copyWith(foreignKey: foreignKey);
      onTableConfigsChanged(newConfigs);
    }
  }

  void _deleteForeignKey(int tableIdx, String key) {
    final newConfigs = List<TableConfig>.from(tableConfigs);
    final foreignKey =
        Map<String, ForeignKey>.from(newConfigs[tableIdx].foreignKey);
    foreignKey.remove(key);
    newConfigs[tableIdx] =
        newConfigs[tableIdx].copyWith(foreignKey: foreignKey);
    onTableConfigsChanged(newConfigs);
  }

  void _addForeignKey(BuildContext context, int tableIdx) async {
    final nameController = TextEditingController();
    final columnsController = TextEditingController();
    final refTableController = TextEditingController();
    final refKeyController = TextEditingController();
    final result = await showDialog<MapEntry<String, ForeignKey>>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Foreign Key'),
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
            TextField(
              controller: refTableController,
              decoration: const InputDecoration(labelText: 'Reference Table'),
            ),
            TextField(
              controller: refKeyController,
              decoration: const InputDecoration(
                  labelText: 'Reference Key (comma separated)'),
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
              final refTable = refTableController.text.trim();
              final refKey = refKeyController.text
                  .split(',')
                  .map((s) => s.trim())
                  .where((s) => s.isNotEmpty)
                  .toList();
              if (name.isNotEmpty &&
                  columns.isNotEmpty &&
                  refTable.isNotEmpty &&
                  refKey.isNotEmpty) {
                Navigator.pop(
                    context,
                    MapEntry(
                        name,
                        ForeignKey(
                            columns: columns,
                            reference: ForeignKeyReference(
                                table: refTable, uniqueKey: refKey))));
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
    if (result != null) {
      final newConfigs = List<TableConfig>.from(tableConfigs);
      final foreignKey =
          Map<String, ForeignKey>.from(newConfigs[tableIdx].foreignKey);
      foreignKey[result.key] = result.value;
      newConfigs[tableIdx] =
          newConfigs[tableIdx].copyWith(foreignKey: foreignKey);
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
            const Text('Foreign Keys:'),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.add),
              tooltip: 'Add Foreign Key',
              onPressed: () => _addForeignKey(context, index),
            ),
          ],
        ),
        Column(
          children: config.foreignKey.entries
              .map((e) => Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 16.0, top: 2, bottom: 2),
                        child: Text(
                            '${e.key}(${e.value.columns.join(', ')}) and ${e.value.reference.table}(${e.value.reference.uniqueKey.join(', ')})'),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        tooltip: 'Edit Foreign Key',
                        onPressed: () =>
                            _editForeignKeyDialog(context, index, e.key),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        tooltip: 'Delete Foreign Key',
                        onPressed: () => _deleteForeignKey(index, e.key),
                      ),
                    ],
                  ))
              .toList(),
        ),
      ],
    );
  }
}
