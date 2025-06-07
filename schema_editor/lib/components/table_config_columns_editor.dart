import 'package:flutter/material.dart';

import '../models/schema.dart';

class TableConfigColumnsEditor extends StatelessWidget {
  final TableConfig config;
  final int index;
  final List<TableConfig> tableConfigs;
  final void Function(List<TableConfig>) onTableConfigsChanged;

  const TableConfigColumnsEditor({
    super.key,
    required this.config,
    required this.index,
    required this.tableConfigs,
    required this.onTableConfigsChanged,
  });

  void _editColumnDialog(BuildContext context, int tableIdx, int colIdx) async {
    final controller = TextEditingController(
        text: tableConfigs[tableIdx].columns[colIdx].name);
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Column Name'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Column Name'),
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
      final columns = List<TableColumn>.from(newConfigs[tableIdx].columns);
      columns[colIdx] = columns[colIdx].copyWith(name: result);
      newConfigs[tableIdx] = newConfigs[tableIdx].copyWith(columns: columns);
      onTableConfigsChanged(newConfigs);
    }
  }

  void _deleteColumn(int tableIdx, int colIdx) {
    final newConfigs = List<TableConfig>.from(tableConfigs);
    final columns = List<TableColumn>.from(newConfigs[tableIdx].columns);
    columns.removeAt(colIdx);
    newConfigs[tableIdx] = newConfigs[tableIdx].copyWith(columns: columns);
    onTableConfigsChanged(newConfigs);
  }

  void _addColumn(BuildContext context, int tableIdx) async {
    final controller = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Column'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Column Name'),
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
      final columns = List<TableColumn>.from(newConfigs[tableIdx].columns);
      columns.add(TableColumn(name: result));
      newConfigs[tableIdx] = newConfigs[tableIdx].copyWith(columns: columns);
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
            const Text('Columns:'),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.add),
              tooltip: 'Add Column',
              onPressed: () => _addColumn(context, index),
            ),
          ],
        ),
        Column(
          children: List.generate(
            config.columns.length,
            (colIdx) => Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, top: 2, bottom: 2),
                  child: Text('name: ${config.columns[colIdx].name}'),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.edit),
                  tooltip: 'Edit Column',
                  onPressed: () => _editColumnDialog(context, index, colIdx),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  tooltip: 'Delete Column',
                  onPressed: () => _deleteColumn(index, colIdx),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
