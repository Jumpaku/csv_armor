import 'package:flutter/material.dart';

import '../models/schema.dart';

class ValidationEditor extends StatefulWidget {
  final List<Validation> validations;
  final void Function(List<Validation> validations)? onChanged;

  const ValidationEditor({
    super.key,
    required this.validations,
    this.onChanged,
  });

  @override
  State<ValidationEditor> createState() => _ValidationEditorState();
}

class _ValidationEditorState extends State<ValidationEditor> {
  late List<Validation> _validations;

  @override
  void initState() {
    super.initState();
    _validations = List<Validation>.from(widget.validations);
  }

  @override
  void didUpdateWidget(covariant ValidationEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.validations != widget.validations) {
      _validations = List<Validation>.from(widget.validations);
      if (mounted) setState(() {});
    }
  }

  void _addOrEditValidation({Validation? initialValidation, int? index}) async {
    final messageController =
        TextEditingController(text: initialValidation?.message ?? '');
    final queryErrorController =
        TextEditingController(text: initialValidation?.queryError ?? '');
    final isEdit = initialValidation != null;
    final result = await showDialog<Validation>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEdit ? 'Edit Validation' : 'Add Validation'),
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8, // Make dialog wider
          height: MediaQuery.of(context).size.height * 0.5, // Make dialog taller
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: messageController,
                  decoration: const InputDecoration(labelText: 'Message'),
                ),
                TextField(
                  controller: queryErrorController,
                  decoration:
                      const InputDecoration(labelText: 'Query Error (SQL)'),
                  maxLines: null, // Allow arbitrary number of lines
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
              if (messageController.text.trim().isNotEmpty &&
                  queryErrorController.text.trim().isNotEmpty) {
                Navigator.pop(
                    context,
                    Validation(
                      message: messageController.text.trim(),
                      queryError: queryErrorController.text.trim(),
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
        if (isEdit && index != null) {
          _validations[index] = result;
        } else {
          _validations.add(result);
        }
        widget.onChanged?.call(_validations);
      });
    }
  }

  void _deleteValidation(int index) {
    setState(() {
      _validations.removeAt(index);
      widget.onChanged?.call(_validations);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            const Text('Validation'),
            const Spacer(),
            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Add'),
              onPressed: () => _addOrEditValidation(),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Expanded(
          child: _validations.isEmpty
              ? const Center(child: Text('No validations defined.'))
              : ListView.separated(
                  itemCount: _validations.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    final validation = _validations[index];
                    return ListTile(
                      title: Text(
                        validation.message,
                      ),
                      subtitle: Text(
                        validation.queryError,
                        maxLines: 2,
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            tooltip: 'Edit',
                            onPressed: () => _addOrEditValidation(
                                initialValidation: validation, index: index),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            tooltip: 'Delete',
                            onPressed: () => _deleteValidation(index),
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
