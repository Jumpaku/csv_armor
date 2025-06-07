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
    final nameController = TextEditingController(text: key);
    final columns =
        List<String>.from(tableConfigs[tableIdx].uniqueKey[key] ?? []);
    await showDialog<void>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            void addColumn() {
              final controller = TextEditingController();
              showDialog<String>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Add Unique Key Column'),
                  content: TextField(
                    controller: controller,
                    decoration: const InputDecoration(labelText: 'Column Name'),
                  ),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel')),
                    ElevatedButton(
                      onPressed: () =>
                          Navigator.pop(context, controller.text.trim()),
                      child: const Text('Add'),
                    ),
                  ],
                ),
              ).then((result) {
                if (result != null && result.isNotEmpty) {
                  setState(() => columns.add(result));
                }
              });
            }

            void editColumn(int idx) {
              final controller = TextEditingController(text: columns[idx]);
              showDialog<String>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Edit Unique Key Column'),
                  content: TextField(
                    controller: controller,
                    decoration: const InputDecoration(labelText: 'Column Name'),
                  ),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel')),
                    ElevatedButton(
                      onPressed: () =>
                          Navigator.pop(context, controller.text.trim()),
                      child: const Text('Save'),
                    ),
                  ],
                ),
              ).then((result) {
                if (result != null && result.isNotEmpty) {
                  setState(() => columns[idx] = result);
                }
              });
            }

            void deleteColumn(int idx) {
              setState(() => columns.removeAt(idx));
            }

            return AlertDialog(
              title: const Text('Edit Unique Key'),
              content: SizedBox(
                width: 400,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: 'Name'),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Text('Columns'),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.add),
                          tooltip: 'Add Unique Key Column',
                          onPressed: addColumn,
                        ),
                      ],
                    ),
                    ...columns.asMap().entries.map((entry) => Row(
                          children: [
                            Expanded(child: Text(entry.value)),
                            IconButton(
                              icon: const Icon(Icons.edit),
                              tooltip: 'Edit',
                              onPressed: () => editColumn(entry.key),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              tooltip: 'Delete',
                              onPressed: () => deleteColumn(entry.key),
                            ),
                          ],
                        )),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final newKey = nameController.text.trim();
                    if (newKey.isNotEmpty && columns.isNotEmpty) {
                      final newConfigs = List<TableConfig>.from(tableConfigs);
                      final uniqueKey = Map<String, List<String>>.from(
                          newConfigs[tableIdx].uniqueKey);
                      uniqueKey.remove(key);
                      uniqueKey[newKey] = List<String>.from(columns);
                      newConfigs[tableIdx] =
                          newConfigs[tableIdx].copyWith(uniqueKey: uniqueKey);
                      onTableConfigsChanged(newConfigs);
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _deleteUniqueKey(int tableIdx, String key) {
    final newConfigs = List<TableConfig>.from(tableConfigs);
    final uniqueKey =
        Map<String, List<String>>.from(newConfigs[tableIdx].uniqueKey);
    uniqueKey.remove(key);
    newConfigs[tableIdx] = newConfigs[tableIdx].copyWith(uniqueKey: uniqueKey);
    onTableConfigsChanged(newConfigs);
  }

  void _addUniqueKey(BuildContext context, int tableIdx) {
    _editUniqueKeyDialog(context, tableIdx, '');
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
                        child: Text('${e.key}: [${e.value.join(', ')}]'),
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
