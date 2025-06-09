import 'package:flutter/material.dart';

import 'package:schema_editor/schema/schema.dart';

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

  void _editOrAddUniqueKey(
      BuildContext context, int tableIdx, String key) async {
    final columns =
        List<String>.from(tableConfigs[tableIdx].uniqueKey[key] ?? []);
    final availableColumnNames =
        tableConfigs[tableIdx].columns.map((col) => col.name).toList();

    await showDialog<void>(
      context: context,
      builder: (context) => EditUniqueKeyDialog(
        initialKeyName: key,
        initialColumns: columns,
        availableColumnNames: availableColumnNames,
        onSave: (newKey, newColumns) {
          final newConfigs = List<TableConfig>.from(tableConfigs);
          final uniqueKey =
              Map<String, List<String>>.from(newConfigs[tableIdx].uniqueKey);
          uniqueKey.remove(key);
          uniqueKey[newKey] = List<String>.from(newColumns);
          newConfigs[tableIdx] =
              newConfigs[tableIdx].copyWith(uniqueKey: uniqueKey);
          onTableConfigsChanged(newConfigs);
        },
      ),
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
              onPressed: () => _editOrAddUniqueKey(context, index, ''),
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
                            _editOrAddUniqueKey(context, index, e.key),
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

class EditUniqueKeyDialog extends StatefulWidget {
  final String initialKeyName;
  final List<String> initialColumns;
  final List<String> availableColumnNames;
  final void Function(String, List<String>) onSave;

  const EditUniqueKeyDialog({
    super.key,
    required this.initialKeyName,
    required this.initialColumns,
    required this.availableColumnNames,
    required this.onSave,
  });

  @override
  State<EditUniqueKeyDialog> createState() => _EditUniqueKeyDialogState();
}

class _EditUniqueKeyDialogState extends State<EditUniqueKeyDialog> {
  late TextEditingController nameController;
  late List<String> columns;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.initialKeyName);
    columns = List<String>.from(widget.initialColumns);
  }

  void addOrEditColumnDialog({int? columnIndex, String? currentColumnName}) {
    String? selectedColumn = currentColumnName;
    final isEdit = columnIndex != null;
    final dialogTitle =
        isEdit ? 'Edit Unique Key Column' : 'Add Unique Key Column';
    final buttonText = isEdit ? 'Save' : 'Add';

    showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(dialogTitle),
        content: DropdownButtonFormField<String>(
          decoration: const InputDecoration(labelText: 'Column Name'),
          value: (selectedColumn != null &&
                  widget.availableColumnNames
                      .where((name) =>
                          !columns.contains(name) ||
                          (isEdit && name == currentColumnName))
                      .contains(selectedColumn))
              ? selectedColumn
              : null,
          items: widget.availableColumnNames
              .where((name) =>
                  !columns.contains(name) ||
                  (isEdit && name == currentColumnName))
              .map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String? newValue) {
            selectedColumn = newValue;
          },
          validator: (value) => value == null ? 'Please select a column' : null,
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
            columns[columnIndex] = result;
          } else {
            columns.add(result);
          }
        });
      }
    });
  }

  void deleteColumn(int idx) {
    setState(() => columns.removeAt(idx));
  }

  @override
  Widget build(BuildContext context) {
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
                  onPressed: addOrEditColumnDialog,
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
                          columnIndex: entry.key,
                          currentColumnName: entry.value),
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
              widget.onSave(newKey, List<String>.from(columns));
              Navigator.pop(context);
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
