import 'package:flutter/material.dart';
import 'package:schema_editor/schema/schema.dart';

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
    await showDialog<void>(
      context: context,
      builder: (context) => EditForeignKeyDialog(
        initialKeyName: isEdit ? key : null,
        initialColumns: isEdit ? List<String>.from(fk!.columns) : <String>[],
        initialReferenceTable: isEdit ? fk!.reference.table : null,
        initialReferenceUniqueKey:
            isEdit ? fk!.reference.uniqueKey ?? '' : null,
        initialIgnoreEmpty: isEdit ? fk!.ignoreEmpty : false,
        tableConfigs: tableConfigs,
        tableIdx: tableIdx,
        onSave: (name, columns, refTable, refUniqueKey, ignoreEmpty) {
          final newConfigs = List<TableConfig>.from(tableConfigs);
          final foreignKey =
              Map<String, ForeignKey>.from(newConfigs[tableIdx].foreignKey);
          foreignKey.remove(key);
          foreignKey[name] = ForeignKey(
            columns: List<String>.from(columns),
            reference: ForeignKeyReference(
              table: refTable,
              uniqueKey: refUniqueKey,
            ),
            ignoreEmpty: ignoreEmpty,
          );
          newConfigs[tableIdx] =
              newConfigs[tableIdx].copyWith(foreignKey: foreignKey);
          onTableConfigsChanged(newConfigs);
        },
      ),
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
              .map(
                (e) => Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16.0, top: 2, bottom: 2),
                        child: Text(
                          '${e.key}: [${e.value.columns.join(', ')}] references ${e.value.reference.table} (${e.value.reference.uniqueKey ?? 'PRIMARY KEY'})',
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                        ),
                      ),
                    ),
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
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class EditForeignKeyDialog extends StatefulWidget {
  final String? initialKeyName;
  final List<String> initialColumns;
  final String? initialReferenceTable;
  final String? initialReferenceUniqueKey;
  final List<TableConfig> tableConfigs;
  final int tableIdx;
  final void Function(String, List<String>, String, String?, bool) onSave;
  final bool initialIgnoreEmpty;

  const EditForeignKeyDialog({
    super.key,
    required this.initialKeyName,
    required this.initialColumns,
    required this.initialReferenceTable,
    required this.initialReferenceUniqueKey,
    required this.tableConfigs,
    required this.tableIdx,
    required this.onSave,
    required this.initialIgnoreEmpty,
  });

  @override
  State<EditForeignKeyDialog> createState() => _EditForeignKeyDialogState();
}

class _EditForeignKeyDialogState extends State<EditForeignKeyDialog> {
  late TextEditingController nameController;
  late List<String> columns;
  late TextEditingController refTableController;
  late TextEditingController refUniqueKeyController;
  bool ignoreEmpty = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.initialKeyName ?? '');
    columns = List<String>.from(widget.initialColumns);
    refTableController =
        TextEditingController(text: widget.initialReferenceTable ?? '');
    refUniqueKeyController =
        TextEditingController(text: widget.initialReferenceUniqueKey ?? '');
    ignoreEmpty = widget.initialIgnoreEmpty;
  }

  void addOrEditColumnDialog({int? columnIndex, String? currentColumnName}) {
    String? selectedColumn = currentColumnName;
    final isEdit = columnIndex != null;
    final dialogTitle = isEdit ? 'Edit Column' : 'Add Column';
    final buttonText = isEdit ? 'Save' : 'Add';
    final candidates = widget.tableConfigs[widget.tableIdx].columns
        .map((col) => col.name)
        .toList();
    showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(dialogTitle),
        content: DropdownButtonFormField<String>(
          decoration: const InputDecoration(labelText: 'Column Name'),
          value: (selectedColumn != null && candidates.contains(selectedColumn))
              ? selectedColumn
              : null,
          items: candidates
              .where((name) =>
                  !columns.contains(name) ||
                  (isEdit && name == currentColumnName))
              .map((String value) => DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  ))
              .toList(),
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
      title: Text(
          widget.initialKeyName != null && widget.initialKeyName!.isNotEmpty
              ? 'Edit Foreign Key'
              : 'Add Foreign Key'),
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
                          currentColumnName: entry.value,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        tooltip: 'Delete',
                        onPressed: () => deleteColumn(entry.key),
                      ),
                    ],
                  )),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Reference Table'),
                value: (refTableController.text.isNotEmpty &&
                        widget.tableConfigs
                            .any((t) => t.name == refTableController.text))
                    ? refTableController.text
                    : null,
                items: widget.tableConfigs
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
                validator: (value) =>
                    value == null ? 'Please select a reference table' : null,
              ),
              DropdownButtonFormField<String>(
                decoration:
                    const InputDecoration(labelText: 'Reference Unique Key'),
                value: (refUniqueKeyController.text.isNotEmpty
                    ? refUniqueKeyController.text
                    : null),
                items: () {
                  final refTable = widget.tableConfigs.firstWhere(
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
              Row(
                children: [
                  Checkbox(
                    value: ignoreEmpty,
                    onChanged: (value) {
                      setState(() {
                        ignoreEmpty = value ?? false;
                      });
                    },
                  ),
                  const Text('Ignore Empty'),
                ],
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
              widget.onSave(name, List<String>.from(columns), refTable,
                  refUniqueKey.isEmpty ? null : refUniqueKey, ignoreEmpty);
              Navigator.pop(context);
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
