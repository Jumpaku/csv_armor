import 'package:flutter/material.dart';

import '../schema/schema.dart';

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

  void _editOrAddForeignKeyDialog(BuildContext context, int tableIdx,
      [String? key]) async {
    final isEdit = key != null && key.isNotEmpty;
    final fk = isEdit ? tableConfigs[tableIdx].foreignKey[key]! : null;
    final nameController = TextEditingController(text: isEdit ? key : '');
    final columns = isEdit ? List<String>.from(fk!.columns) : <String>[];
    final refTableController =
        TextEditingController(text: isEdit ? fk!.reference.table : '');
    final refUniqueKeyController = TextEditingController(text: isEdit ? fk!.reference.uniqueKey ?? '' : '');
    await showDialog<void>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            void addOrEditColumnDialog(
                {required List<String> list,
                int? columnIndex,
                String? currentColumnName,
                required List<String> candidates,
                required String label}) {
              String? selectedColumn = currentColumnName;
              final isEdit = columnIndex != null;
              final dialogTitle = isEdit ? 'Edit $label' : 'Add $label';
              final buttonText = isEdit ? 'Save' : 'Add';
              showDialog<String>(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(dialogTitle),
                  content: DropdownButtonFormField<String>(
                    decoration: InputDecoration(labelText: label),
                    value: (selectedColumn != null &&
                            candidates.contains(selectedColumn))
                        ? selectedColumn
                        : null,
                    items: candidates
                        .where((name) =>
                            !list.contains(name) ||
                            (isEdit && name == currentColumnName))
                        .map((String value) => DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            ))
                        .toList(),
                    onChanged: (String? newValue) {
                      selectedColumn = newValue;
                    },
                    validator: (value) =>
                        value == null ? 'Please select a $label' : null,
                  ),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel')),
                    ElevatedButton(
                      onPressed: () {
                        if (selectedColumn != null) {
                          Navigator.pop(context, selectedColumn);
                        }
                      },
                      child: Text(buttonText),
                    ),
                  ],
                ),
              ).then((result) {
                if (result != null && result.isNotEmpty) {
                  setState(() {
                    if (isEdit) {
                      list[columnIndex] = result;
                    } else {
                      list.add(result);
                    }
                  });
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
                        decoration:
                            const InputDecoration(labelText: 'Key Name'),
                      ),
                      Row(
                        children: [
                          const Text('Columns'),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(Icons.add),
                            tooltip: 'Add Column',
                            onPressed: () => addOrEditColumnDialog(
                              list: columns,
                              candidates: tableConfigs[tableIdx]
                                  .columns
                                  .map((col) => col.name)
                                  .toList(),
                              label: 'Column Name',
                            ),
                          ),
                        ],
                      ),
                      ...columns.asMap().entries.map((entry) => Row(
                            children: [
                              Expanded(child: Text(entry.value)),
                              IconButton(
                                icon: const Icon(Icons.edit),
                                tooltip: 'Edit',
                                onPressed: () => addOrEditColumnDialog(
                                  list: columns,
                                  columnIndex: entry.key,
                                  currentColumnName: entry.value,
                                  candidates: tableConfigs[tableIdx]
                                      .columns
                                      .map((col) => col.name)
                                      .toList(),
                                  label: 'Column Name',
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                tooltip: 'Delete',
                                onPressed: () =>
                                    deleteColumn(columns, entry.key),
                              ),
                            ],
                          )),
                      DropdownButtonFormField<String>(
                        decoration:
                            const InputDecoration(labelText: 'Reference Table'),
                        value: (refTableController.text.isNotEmpty &&
                                tableConfigs.any(
                                    (t) => t.name == refTableController.text))
                            ? refTableController.text
                            : null,
                        items: tableConfigs
                            .map((t) => DropdownMenuItem<String>(
                                  value: t.name,
                                  child: Text(t.name),
                                ))
                            .toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            refTableController.text = newValue ?? '';
                            refUniqueKeyController.text = '';
                          });
                        },
                        validator: (value) => value == null
                            ? 'Please select a reference table'
                            : null,
                      ),
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(labelText: 'Reference Unique Key'),
                        value: (refUniqueKeyController.text.isNotEmpty ? refUniqueKeyController.text : null),
                        items: () {
                          final refTable = tableConfigs.firstWhere(
                            (t) => t.name == refTableController.text,
                            orElse: () => TableConfig(name: '', csvPath: ''),
                          );
                          final uniqueKeyNames = refTable.uniqueKey.keys.toList();
                          if (refTable.primaryKey.isNotEmpty) {
                            uniqueKeyNames.insert(0, '');
                          }
                          return uniqueKeyNames
                              .map((name) => DropdownMenuItem<String>(
                                    value: name,
                                    child: Text(name == '' ? '(PRIMARY KEY)' : name),
                                  ))
                              .toList();
                        }(),
                        onChanged: (String? newValue) {
                          setState(() {
                            refUniqueKeyController.text = newValue ?? '';
                          });
                        },
                        validator: (value) => value == null || value.isEmpty
                            ? 'Please select a unique key or primary key'
                            : null,
                      ),
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
                    final refUniqueKey = refUniqueKeyController.text.trim();
                    if (name.isNotEmpty && refTable.isNotEmpty) {
                      final newConfigs = List<TableConfig>.from(tableConfigs);
                      final foreignKey = Map<String, ForeignKey>.from(
                          newConfigs[tableIdx].foreignKey);
                      foreignKey.remove(key);
                      foreignKey[name] = ForeignKey(
                        columns: List<String>.from(columns),
                        reference: ForeignKeyReference(
                          table: refTable,
                          uniqueKey: refUniqueKey.isEmpty ? null : refUniqueKey,
                        ),
                      );
                      newConfigs[tableIdx] =
                          newConfigs[tableIdx].copyWith(foreignKey: foreignKey);
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
              onPressed: () => _editOrAddForeignKeyDialog(context, index),
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
                          '${e.key}: [${e.value.columns.join(', ')}] references ${e.value.reference.table} (${e.value.reference.uniqueKey ?? 'PRIMARY KEY'})',
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        tooltip: 'Edit Foreign Key',
                        onPressed: () =>
                            _editOrAddForeignKeyDialog(context, index, e.key),
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
