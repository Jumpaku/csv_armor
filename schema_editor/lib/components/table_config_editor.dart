import 'package:flutter/material.dart';

import '../models/schema.dart';
import 'table_config_details_editor.dart';

class TableConfigEditor extends StatefulWidget {
  final List<TableConfig> tableConfigs;
  final void Function(List<TableConfig> tableConfigs)? onChanged;

  const TableConfigEditor({
    super.key,
    required this.tableConfigs,
    this.onChanged,
  });

  @override
  State<TableConfigEditor> createState() => _TableConfigEditorState();
}

class _TableConfigEditorState extends State<TableConfigEditor> {
  late List<TableConfig> _tableConfigs;
  int? _selectedIndex;

  @override
  void initState() {
    super.initState();
    _tableConfigs = List<TableConfig>.from(widget.tableConfigs);
  }

  @override
  void didUpdateWidget(covariant TableConfigEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.tableConfigs != widget.tableConfigs) {
      _tableConfigs = List<TableConfig>.from(widget.tableConfigs);
      if (mounted) setState(() {});
    }
  }

  void _updateTableConfigs(List<TableConfig> newConfigs) {
    setState(() {
      _tableConfigs = newConfigs;
      widget.onChanged?.call(_tableConfigs);
    });
  }

  void _addTableConfigDialog() async {
    final nameController = TextEditingController();
    final csvPathController = TextEditingController();
    final result = await showDialog<TableConfig>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Table Config'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Table Name'),
              ),
              TextField(
                controller: csvPathController,
                decoration: const InputDecoration(labelText: 'CSV Path'),
              ),
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
              if (nameController.text.trim().isNotEmpty &&
                  csvPathController.text.trim().isNotEmpty) {
                Navigator.pop(
                    context,
                    TableConfig(
                      name: nameController.text.trim(),
                      csvPath: csvPathController.text.trim(),
                    ));
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (result != null) {
      setState(() {
        _tableConfigs.add(result);
        widget.onChanged?.call(_tableConfigs);
      });
    }
  }

  void _deleteTableConfig(int index) {
    setState(() {
      _tableConfigs.removeAt(index);
      widget.onChanged?.call(_tableConfigs);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  const Text('Table Config'),
                  const Spacer(),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('Add'),
                    onPressed: _addTableConfigDialog,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Expanded(
                child: _tableConfigs.isEmpty
                    ? const Center(child: Text('No table configs defined.'))
                    : ListView.separated(
                        itemCount: _tableConfigs.length,
                        separatorBuilder: (context, index) =>
                            const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final config = _tableConfigs[index];
                          return ListTile(
                            selected: _selectedIndex == index,
                            title: Text(
                              config.name,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            ),
                            onTap: () {
                              setState(() {
                                _selectedIndex = index;
                              });
                            },
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.info_outline),
                                  tooltip: 'Show Details',
                                  onPressed: () {
                                    setState(() {
                                      _selectedIndex = index;
                                    });
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  tooltip: 'Delete',
                                  onPressed: () => _deleteTableConfig(index),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
        const VerticalDivider(thickness: 1, width: 1),
        Expanded(
          flex: 3,
          child: _selectedIndex != null &&
                  _selectedIndex! >= 0 &&
                  _selectedIndex! < _tableConfigs.length
              ? TableConfigDetailsEditor(
                  config: _tableConfigs[_selectedIndex!],
                  index: _selectedIndex!,
                  tableConfigs: _tableConfigs,
                  onTableConfigsChanged: _updateTableConfigs,
                )
              : const Center(
                  child: Text('Select a table config to see details.')),
        ),
      ],
    );
  }
}
