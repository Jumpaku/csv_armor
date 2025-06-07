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

  void _editForeignKeyDialog(BuildContext context, int tableIdx, [String? key]) async {
    final isEdit = key != null && key.isNotEmpty;
    final fk = isEdit ? tableConfigs[tableIdx].foreignKey[key]! : null;
    final nameController = TextEditingController(text: isEdit ? key : '');
    final columns = isEdit ? List<String>.from(fk!.columns) : <String>[];
    final refTableController = TextEditingController(text: isEdit ? fk!.reference.table : '');
    final refColumns = isEdit ? List<String>.from(fk!.reference.uniqueKey) : <String>[];
    await showDialog<void>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            void addColumn(List<String> list) {
              final controller = TextEditingController();
              showDialog<String>(
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
              ).then((result) {
                if (result != null && result.isNotEmpty) {
                  setState(() => list.add(result));
                }
              });
            }
            void editColumn(List<String> list, int idx) {
              final controller = TextEditingController(text: list[idx]);
              showDialog<String>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Edit Column'),
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
              ).then((result) {
                if (result != null && result.isNotEmpty) {
                  setState(() => list[idx] = result);
                }
              });
            }
            void deleteColumn(List<String> list, int idx) {
              setState(() => list.removeAt(idx));
            }
            return AlertDialog(
              title: Text(isEdit ? 'Edit Foreign Key' : 'Add Foreign Key'),
              content: SizedBox(
                width: 400,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: nameController,
                        decoration: const InputDecoration(labelText: 'Key Name'),
                      ),
                      Row(
                        children: [
                          const Text('Columns'),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(Icons.add),
                            tooltip: 'Add Column',
                            onPressed: () => addColumn(columns),
                          ),
                        ],
                      ),
                      ...columns.asMap().entries.map((entry) => Row(
                            children: [
                              Expanded(child: Text(entry.value)),
                              IconButton(
                                icon: const Icon(Icons.edit),
                                tooltip: 'Edit',
                                onPressed: () => editColumn(columns, entry.key),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                tooltip: 'Delete',
                                onPressed: () => deleteColumn(columns, entry.key),
                              ),
                            ],
                          )),
                      TextField(
                        controller: refTableController,
                        decoration: const InputDecoration(labelText: 'Reference Table'),
                      ),
                      Row(
                        children: [
                          const Text('Reference Columns'),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(Icons.add),
                            tooltip: 'Add Reference Column',
                            onPressed: () => addColumn(refColumns),
                          ),
                        ],
                      ),
                      ...refColumns.asMap().entries.map((entry) => Row(
                            children: [
                              Expanded(child: Text(entry.value)),
                              IconButton(
                                icon: const Icon(Icons.edit),
                                tooltip: 'Edit',
                                onPressed: () => editColumn(refColumns, entry.key),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                tooltip: 'Delete',
                                onPressed: () => deleteColumn(refColumns, entry.key),
                              ),
                            ],
                          )),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final name = nameController.text.trim();
                    final refTable = refTableController.text.trim();
                    if (name.isNotEmpty && columns.isNotEmpty && refTable.isNotEmpty && refColumns.isNotEmpty) {
                      final newConfigs = List<TableConfig>.from(tableConfigs);
                      final foreignKey = Map<String, ForeignKey>.from(newConfigs[tableIdx].foreignKey);
                      foreignKey.remove(key);
                      foreignKey[name] = ForeignKey(
                        columns: List<String>.from(columns),
                        reference: ForeignKeyReference(
                          table: refTable,
                          uniqueKey: List<String>.from(refColumns),
                        ),
                      );
                      newConfigs[tableIdx] = newConfigs[tableIdx].copyWith(foreignKey: foreignKey);
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

  void _deleteForeignKey(int tableIdx, String key) {
    final newConfigs = List<TableConfig>.from(tableConfigs);
    final foreignKey =
        Map<String, ForeignKey>.from(newConfigs[tableIdx].foreignKey);
    foreignKey.remove(key);
    newConfigs[tableIdx] =
        newConfigs[tableIdx].copyWith(foreignKey: foreignKey);
    onTableConfigsChanged(newConfigs);
  }

  void _addForeignKey(BuildContext context, int tableIdx) {
    _editForeignKeyDialog(context, tableIdx);
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
                          '${e.key}: [${e.value.columns.join(', ')}] references ${e.value.reference.table} [${e.value.reference.uniqueKey.join(', ')}]',
                        ),
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
