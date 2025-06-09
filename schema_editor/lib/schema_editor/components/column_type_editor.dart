import 'package:flutter/material.dart';

class ColumnTypeEditor extends StatefulWidget {
  final Map<String, String> columnType;
  final void Function(Map<String, String> columnType)? onChanged;

  const ColumnTypeEditor({
    super.key,
    required this.columnType,
    this.onChanged,
  });

  @override
  State<ColumnTypeEditor> createState() => _ColumnTypeEditorState();
}

class _ColumnTypeEditorState extends State<ColumnTypeEditor> {
  late Map<String, String> _columnType;

  @override
  void initState() {
    super.initState();
    _columnType = Map<String, String>.from(widget.columnType);
  }

  @override
  void didUpdateWidget(covariant ColumnTypeEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.columnType != widget.columnType) {
      _columnType = Map<String, String>.from(widget.columnType);
      if (mounted) setState(() {});
    }
  }

  void _addOrEditColumnType(
      {String? initialName, String? initialPattern}) async {
    final nameController = TextEditingController(text: initialName ?? '');
    final patternController = TextEditingController(text: initialPattern ?? '');
    final isEdit = initialName != null;
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEdit ? 'Edit Column Type' : 'Add Column Type'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Type Name'),
            ),
            TextField(
              controller: patternController,
              decoration: const InputDecoration(labelText: 'Pattern (Regexp)'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final name = nameController.text.trim();
              final pattern = patternController.text.trim();
              if (name.isNotEmpty && pattern.isNotEmpty) {
                Navigator.pop(context, {name: pattern});
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (result != null && result.isNotEmpty) {
      setState(() {
        _columnType[result.keys.first] = result.values.first;
        widget.onChanged?.call(_columnType);
      });
    }
  }

  void _deleteColumnType(String name) {
    setState(() {
      _columnType.remove(name);
      widget.onChanged?.call(_columnType);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            const Text('Column Types'),
            const Spacer(),
            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Add'),
              onPressed: () => _addOrEditColumnType(),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Expanded(
          child: _columnType.isEmpty
              ? const Center(child: Text('No column types defined.'))
              : ListView.separated(
                  itemCount: _columnType.length,
                  separatorBuilder: (context, index) =>
                      const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final name = _columnType.keys.elementAt(index);
                    final pattern = _columnType[name]!;
                    return ListTile(
                      title: Row(
                        children: [
                          Text(name,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          const Text(' : '),
                          Expanded(
                            child: Text(
                              pattern,
                              style: const TextStyle(fontFamily: 'monospace'),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            tooltip: 'Edit',
                            onPressed: () => _addOrEditColumnType(
                                initialName: name, initialPattern: pattern),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            tooltip: 'Delete',
                            onPressed: () => _deleteColumnType(name),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
