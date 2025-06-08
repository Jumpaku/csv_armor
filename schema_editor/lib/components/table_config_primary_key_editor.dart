import 'package:flutter/material.dart';

import '../models/schema.dart';

class TableConfigPrimaryKeyEditor extends StatelessWidget {
  final TableConfig config;
  final int index;
  final List<TableConfig> tableConfigs;
  final void Function(List<TableConfig>) onTableConfigsChanged;

  const TableConfigPrimaryKeyEditor({
    super.key,
    required this.config,
    required this.index,
    required this.tableConfigs,
    required this.onTableConfigsChanged,
  });

  void _editPrimaryKeyDialog(BuildContext context, int tableIdx) async {
    final pkList = List<String>.from(tableConfigs[tableIdx].primaryKey);
    final availableColumnNames =
        tableConfigs[tableIdx].columns.map((col) => col.name).toList();

    await showDialog<void>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            void addOrEditColumn({int? idx, String? currentColumnName}) {
              String? selectedColumn = currentColumnName;
              final isEdit = idx != null;
              final dialogTitle =
                  isEdit ? 'Edit Primary Key Column' : 'Add Primary Key Column';
              final buttonText = isEdit ? 'Save' : 'Add';

              showDialog<String>(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(dialogTitle),
                  content: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'Column Name'),
                    value: selectedColumn,
                    items: availableColumnNames
                        .where((name) =>
                            !pkList.contains(name) || name == currentColumnName)
                        .map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      selectedColumn = newValue;
                    },
                    validator: (value) =>
                        value == null ? 'Please select a column' : null,
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
                      pkList[idx] = result;
                    } else {
                      pkList.add(result);
                    }
                  });
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
                          onPressed: addOrEditColumn, // Changed
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
                              onPressed: () => addOrEditColumn(
                                  idx: entry.key,
                                  currentColumnName: entry.value), // Changed
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
