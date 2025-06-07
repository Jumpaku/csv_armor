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

  void _editPrimaryKeyDialog(BuildContext context, int tableIdx) async {
    final pkList = List<String>.from(tableConfigs[tableIdx].primaryKey);
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
                  title: const Text('Add Primary Key Column'),
                  content: TextField(
                    controller: controller,
                    decoration: const InputDecoration(labelText: 'Primary Key'),
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
                  setState(() => pkList.add(result));
                }
              });
            }

            void editColumn(int idx) {
              final controller = TextEditingController(text: pkList[idx]);
              showDialog<String>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Edit Primary Key Column'),
                  content: TextField(
                    controller: controller,
                    decoration: const InputDecoration(labelText: 'Primary Key'),
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
                  setState(() => pkList[idx] = result);
                }
              });
            }

            void deleteColumn(int idx) {
              setState(() => pkList.removeAt(idx));
            }

            return AlertDialog(
              title: const Text('Edit Primary Key'),
              content: SizedBox(
                width: 400,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        const Text('Primary Key Columns'),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.add),
                          tooltip: 'Add Primary Key Column',
                          onPressed: addColumn,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ...pkList.asMap().entries.map((entry) => Row(
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
                    final newConfigs = List<TableConfig>.from(tableConfigs);
                    newConfigs[tableIdx] = newConfigs[tableIdx]
                        .copyWith(primaryKey: List<String>.from(pkList));
                    onTableConfigsChanged(newConfigs);
                    Navigator.pop(context);
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

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
             Text('Primary Key: [${config.primaryKey.join(', ')}]'),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.edit),
              tooltip: 'Edit Primary Key',
              onPressed: () => _editPrimaryKeyDialog(context, index),
            ),
          ],
        ),
      ],
    );
  }
}
