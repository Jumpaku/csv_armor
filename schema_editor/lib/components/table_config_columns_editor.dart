import 'package:flutter/material.dart';

import '../schema/schema.dart';

class TableConfigColumnsEditor extends StatelessWidget {
  final TableConfig config;
  final int index;
  final List<TableConfig> tableConfigs;
  final void Function(List<TableConfig>) onTableConfigsChanged;
  final Map<String, String> columnTypes; // Added to receive available column types

  const TableConfigColumnsEditor({
    super.key,
    required this.config,
    required this.index,
    required this.tableConfigs,
    required this.onTableConfigsChanged,
    required this.columnTypes, // Added
  });

  void _editColumnDialog(BuildContext context, int tableIdx, int colIdx) async {
    final column = tableConfigs[tableIdx].columns[colIdx];
    final result = await showDialog<TableColumn>(
      context: context,
      builder: (context) => _ColumnDialog(
        initial: column,
        availableColumnTypes: columnTypes.keys.toList(), // Pass available types
      ),
    );
    if (result != null) {
      final newConfigs = List<TableConfig>.from(tableConfigs);
      final columns = List<TableColumn>.from(newConfigs[tableIdx].columns);
      columns[colIdx] = result;
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
    final result = await showDialog<TableColumn>(
      context: context,
      builder: (context) => _ColumnDialog(
        availableColumnTypes: columnTypes.keys.toList(), // Pass available types
      ),
    );
    if (result != null) {
      final newConfigs = List<TableConfig>.from(tableConfigs);
      final columns = List<TableColumn>.from(newConfigs[tableIdx].columns);
      columns.add(result);
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
                  child: Text(config.columns[colIdx].name),
                ),
                const Text(': '),
                Text(
                    '${config.columns[colIdx].type ?? ''}${config.columns[colIdx].allowEmpty ? ' (allow empty)' : ''}'),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.info_outline),
                  tooltip: config.columns[colIdx].description ?? 'No description',
                  onPressed: () => {},
                ),
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

class _ColumnDialog extends StatefulWidget {
  final TableColumn? initial;
  final List<String> availableColumnTypes; // Added

  const _ColumnDialog({
    Key? key,
    this.initial,
    required this.availableColumnTypes, // Added
  }) : super(key: key);

  @override
  State<_ColumnDialog> createState() => _ColumnDialogState();
}

class _ColumnDialogState extends State<_ColumnDialog> {
  late final TextEditingController nameController;
  late final TextEditingController descriptionController;
  late final ValueNotifier<bool> allowEmptyController;
  // late final TextEditingController typeController; // Removed
  String? selectedType; // Added for dropdown
  late final TextEditingController regexpController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.initial?.name ?? '');
    descriptionController =
        TextEditingController(text: widget.initial?.description ?? '');
    allowEmptyController =
        ValueNotifier<bool>(widget.initial?.allowEmpty ?? false);
    // typeController = TextEditingController(text: widget.initial?.type ?? ''); // Removed
    selectedType = widget.initial?.type; // Initialize selectedType
    // Ensure selectedType is one of the available types, or null if not
    if (selectedType != null && !widget.availableColumnTypes.contains(selectedType)) {
      selectedType = null;
    }
    regexpController =
        TextEditingController(text: widget.initial?.regexp ?? '');
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    allowEmptyController.dispose();
    // typeController.dispose(); // Removed
    regexpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.initial != null;
    return AlertDialog(
      title: Text(isEdit ? 'Edit Column' : 'Add Column'),
      content: SizedBox(
        width: 400,
        child: SingleChildScrollView( // Added SingleChildScrollView for scrollability
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              ValueListenableBuilder<bool>(
                valueListenable: allowEmptyController,
                builder: (context, value, child) => CheckboxListTile(
                  title: const Text('Allow Empty'),
                  value: value,
                  onChanged: (v) => allowEmptyController.value = v ?? false,
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              // TextField( // Removed TextField for type
              //   controller: typeController,
              //   decoration: const InputDecoration(labelText: 'Type'),
              // ),
              DropdownButtonFormField<String>( // Added DropdownButtonFormField for type
                decoration: const InputDecoration(labelText: 'Type'),
                value: selectedType,
                hint: const Text('Select type'),
                items: widget.availableColumnTypes
                    .map((String value) => DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        ))
                    .toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedType = newValue;
                  });
                },
              ),
              TextField(
                controller: regexpController,
                decoration: const InputDecoration(labelText: 'Regexp'),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () {
            final name = nameController.text.trim();
            if (name.isNotEmpty) {
              Navigator.pop(
                context,
                TableColumn(
                  name: name,
                  description: descriptionController.text.trim().isEmpty
                      ? null
                      : descriptionController.text.trim(),
                  allowEmpty: allowEmptyController.value,
                  // type: typeController.text.trim().isEmpty // Removed
                  //     ? null
                  //     : typeController.text.trim(),
                  type: selectedType, // Use selectedType
                  regexp: regexpController.text.trim().isEmpty
                      ? null
                      : regexpController.text.trim(),
                ),
              );
            }
          },
          child: Text(isEdit ? 'Save' : 'Add'),
        ),
      ],
    );
  }
}
