import 'package:flutter/material.dart';

import '../models/schema.dart';
import 'table_config_columns_editor.dart';
import 'table_config_primary_keys_editor.dart';
import 'table_config_unique_keys_editor.dart';
import 'table_config_foreign_keys_editor.dart';

class TableConfigDetailsEditor extends StatefulWidget {
  final TableConfig config;
  final int index;
  final List<TableConfig> tableConfigs;
  final void Function(List<TableConfig>) onTableConfigsChanged;

  const TableConfigDetailsEditor({
    super.key,
    required this.config,
    required this.index,
    required this.tableConfigs,
    required this.onTableConfigsChanged,
  });

  @override
  State<TableConfigDetailsEditor> createState() =>
      _TableConfigDetailsEditorState();
}

class _TableConfigDetailsEditorState extends State<TableConfigDetailsEditor> {
  void _editNameDialog(int index) async {
    final controller =
        TextEditingController(text: widget.tableConfigs[index].name);
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Table Name'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Table Name'),
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
      final newConfigs = List<TableConfig>.from(widget.tableConfigs);
      newConfigs[index] = newConfigs[index].copyWith(name: result);
      widget.onTableConfigsChanged(newConfigs);
    }
  }

  void _editCsvPathDialog(int index) async {
    final controller =
        TextEditingController(text: widget.tableConfigs[index].csvPath);
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit CSV Path'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'CSV Path'),
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
      final newConfigs = List<TableConfig>.from(widget.tableConfigs);
      newConfigs[index] = newConfigs[index].copyWith(csvPath: result);
      widget.onTableConfigsChanged(newConfigs);
    }
  }

  void _editColumnDialog(int tableIdx, int colIdx) async {
    final controller = TextEditingController(
        text: widget.tableConfigs[tableIdx].columns[colIdx].name);
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
      final newConfigs = List<TableConfig>.from(widget.tableConfigs);
      final columns = List<TableColumn>.from(newConfigs[tableIdx].columns);
      columns[colIdx] = columns[colIdx].copyWith(name: result);
      newConfigs[tableIdx] = newConfigs[tableIdx].copyWith(columns: columns);
      widget.onTableConfigsChanged(newConfigs);
    }
  }

  void _deleteColumn(int tableIdx, int colIdx) {
    final newConfigs = List<TableConfig>.from(widget.tableConfigs);
    final columns = List<TableColumn>.from(newConfigs[tableIdx].columns);
    columns.removeAt(colIdx);
    newConfigs[tableIdx] = newConfigs[tableIdx].copyWith(columns: columns);
    widget.onTableConfigsChanged(newConfigs);
  }

  void _addColumn(int tableIdx) async {
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
      final newConfigs = List<TableConfig>.from(widget.tableConfigs);
      final columns = List<TableColumn>.from(newConfigs[tableIdx].columns);
      columns.add(TableColumn(name: result));
      newConfigs[tableIdx] = newConfigs[tableIdx].copyWith(columns: columns);
      widget.onTableConfigsChanged(newConfigs);
    }
  }

  void _editPrimaryKeyDialog(int tableIdx, int pkIdx) async {
    final controller = TextEditingController(text: widget.tableConfigs[tableIdx].primaryKey[pkIdx]);
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Primary Key'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Primary Key'),
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
      final newConfigs = List<TableConfig>.from(widget.tableConfigs);
      final pk = List<String>.from(newConfigs[tableIdx].primaryKey);
      pk[pkIdx] = result;
      newConfigs[tableIdx] = newConfigs[tableIdx].copyWith(primaryKey: pk);
      widget.onTableConfigsChanged(newConfigs);
    }
  }

  void _deletePrimaryKey(int tableIdx, int pkIdx) {
    final newConfigs = List<TableConfig>.from(widget.tableConfigs);
    final pk = List<String>.from(newConfigs[tableIdx].primaryKey);
    pk.removeAt(pkIdx);
    newConfigs[tableIdx] = newConfigs[tableIdx].copyWith(primaryKey: pk);
    widget.onTableConfigsChanged(newConfigs);
  }

  void _addPrimaryKey(int tableIdx) async {
    final controller = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Primary Key'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Primary Key'),
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
      final newConfigs = List<TableConfig>.from(widget.tableConfigs);
      final pk = List<String>.from(newConfigs[tableIdx].primaryKey);
      pk.add(result);
      newConfigs[tableIdx] = newConfigs[tableIdx].copyWith(primaryKey: pk);
      widget.onTableConfigsChanged(newConfigs);
    }
  }

  void _editUniqueKeyDialog(int tableIdx, String key) async {
    final controller = TextEditingController(
        text: widget.tableConfigs[tableIdx].uniqueKey[key]?.join(', ') ?? '');
    final result = await showDialog<List<String>>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Unique Key: $key'),
        content: TextField(
          controller: controller,
          decoration:
              const InputDecoration(labelText: 'Columns (comma separated)'),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () => Navigator.pop(
                context,
                controller.text
                    .split(',')
                    .map((s) => s.trim())
                    .where((s) => s.isNotEmpty)
                    .toList()),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (result != null) {
      final newConfigs = List<TableConfig>.from(widget.tableConfigs);
      final uniqueKey = Map<String, List<String>>.from(newConfigs[tableIdx].uniqueKey);
      uniqueKey[key] = result;
      newConfigs[tableIdx] = newConfigs[tableIdx].copyWith(uniqueKey: uniqueKey);
      widget.onTableConfigsChanged(newConfigs);
    }
  }

  void _deleteUniqueKey(int tableIdx, String key) {
    final newConfigs = List<TableConfig>.from(widget.tableConfigs);
    final uniqueKey = Map<String, List<String>>.from(newConfigs[tableIdx].uniqueKey);
    uniqueKey.remove(key);
    newConfigs[tableIdx] = newConfigs[tableIdx].copyWith(uniqueKey: uniqueKey);
    widget.onTableConfigsChanged(newConfigs);
  }

  void _addUniqueKey(int tableIdx) async {
    final nameController = TextEditingController();
    final columnsController = TextEditingController();
    final result = await showDialog<MapEntry<String, List<String>>>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Unique Key'),
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
              if (name.isNotEmpty && columns.isNotEmpty) {
                Navigator.pop(context, MapEntry(name, columns));
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
    if (result != null) {
      final newConfigs = List<TableConfig>.from(widget.tableConfigs);
      final uniqueKey = Map<String, List<String>>.from(newConfigs[tableIdx].uniqueKey);
      uniqueKey[result.key] = result.value;
      newConfigs[tableIdx] = newConfigs[tableIdx].copyWith(uniqueKey: uniqueKey);
      widget.onTableConfigsChanged(newConfigs);
    }
  }

  void _editForeignKeyDialog(int tableIdx, String key) async {
    final fk = widget.tableConfigs[tableIdx].foreignKey[key]!;
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
      final newConfigs = List<TableConfig>.from(widget.tableConfigs);
      final foreignKey = Map<String, ForeignKey>.from(newConfigs[tableIdx].foreignKey);
      foreignKey[key] = result;
      newConfigs[tableIdx] = newConfigs[tableIdx].copyWith(foreignKey: foreignKey);
      widget.onTableConfigsChanged(newConfigs);
    }
  }

  void _deleteForeignKey(int tableIdx, String key) {
    final newConfigs = List<TableConfig>.from(widget.tableConfigs);
    final foreignKey = Map<String, ForeignKey>.from(newConfigs[tableIdx].foreignKey);
    foreignKey.remove(key);
    newConfigs[tableIdx] = newConfigs[tableIdx].copyWith(foreignKey: foreignKey);
    widget.onTableConfigsChanged(newConfigs);
  }

  void _addForeignKey(int tableIdx) async {
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
      final newConfigs = List<TableConfig>.from(widget.tableConfigs);
      final foreignKey = Map<String, ForeignKey>.from(newConfigs[tableIdx].foreignKey);
      foreignKey[result.key] = result.value;
      newConfigs[tableIdx] = newConfigs[tableIdx].copyWith(foreignKey: foreignKey);
      widget.onTableConfigsChanged(newConfigs);
    }
  }

  @override
  Widget build(BuildContext context) {
    final config = widget.config;
    final index = widget.index;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('Name: ${config.name}',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.edit),
                  tooltip: 'Edit Name',
                  onPressed: () => _editNameDialog(index),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text('CSV Path: ${config.csvPath}'),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.edit),
                  tooltip: 'Edit CSV Path',
                  onPressed: () => _editCsvPathDialog(index),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text('Columns:'),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.add),
                  tooltip: 'Add Column',
                  onPressed: () => _addColumn(index),
                ),
              ],
            ),
            Column(
              children: List.generate(
                config.columns.length,
                (colIdx) => Row(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 16.0, top: 2, bottom: 2),
                      child: Text('name: ${config.columns[colIdx].name}'),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.edit),
                      tooltip: 'Edit Column',
                      onPressed: () => _editColumnDialog(index, colIdx),
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
            const SizedBox(height: 8),
            Row(
              children: [
                const Text('Primary Key:'),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.add),
                  tooltip: 'Add Primary Key',
                  onPressed: () => _addPrimaryKey(index),
                ),
              ],
            ),
            Column(
              children: config.primaryKey.indexed
                  .map(
                    (entry) => Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 16.0, top: 2, bottom: 2),
                          child: Text(entry.$2),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.edit),
                          tooltip: 'Edit Primary Key',
                          onPressed: () => _editPrimaryKeyDialog(index, entry.$1),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          tooltip: 'Delete Primary Key',
                          onPressed: () => _deletePrimaryKey(index, entry.$1),
                        ),
                      ],
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text('Unique Keys:'),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.add),
                  tooltip: 'Add Unique Key',
                  onPressed: () => _addUniqueKey(index),
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
                            child: Text('${e.key}(${e.value.join(', ')})'),
                          ),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(Icons.edit),
                            tooltip: 'Edit Unique Key',
                            onPressed: () => _editUniqueKeyDialog(index, e.key),
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
            const SizedBox(height: 8),
            Row(
              children: [
                const Text('Foreign Keys:'),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.add),
                  tooltip: 'Add Foreign Key',
                  onPressed: () => _addForeignKey(index),
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
                            onPressed: () => _editForeignKeyDialog(index, e.key),
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
        ),
      ),
    );
  }
}
