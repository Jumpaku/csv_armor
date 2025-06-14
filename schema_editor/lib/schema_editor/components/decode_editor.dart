import 'package:flutter/material.dart';
import 'package:schema_editor/schema/schema.dart';

class DecodeEditor extends StatefulWidget {
  final DecodeConfig? decode;
  final ValueChanged<DecodeConfig?> onChanged;

  const DecodeEditor({
    super.key,
    required this.decode,
    required this.onChanged,
  });

  @override
  State<DecodeEditor> createState() => _DecodeEditorState();
}

class _DecodeEditorState extends State<DecodeEditor> {
  late TextEditingController _headerLinesController;
  late String? _recordSeparator;
  late TextEditingController _fieldSeparatorController;
  late TextEditingController _leftController;
  late TextEditingController _leftEscapeController;
  late TextEditingController _rightController;
  late TextEditingController _rightEscapeController;

  @override
  void initState() {
    super.initState();
    final decode = widget.decode;
    _headerLinesController =
        TextEditingController(text: decode?.headerLines?.toString() ?? '');
    _recordSeparator = decode?.recordSeparator?.name;
    _fieldSeparatorController =
        TextEditingController(text: decode?.fieldSeparator ?? '');
    _leftController =
        TextEditingController(text: decode?.fieldQuote?.left ?? '');
    _leftEscapeController =
        TextEditingController(text: decode?.fieldQuote?.leftEscape ?? '');
    _rightController =
        TextEditingController(text: decode?.fieldQuote?.right ?? '');
    _rightEscapeController =
        TextEditingController(text: decode?.fieldQuote?.rightEscape ?? '');
  }

  void _notifyChange() {
    final headerLines = int.tryParse(_headerLinesController.text);
    final decodeConfig = DecodeConfig(
      headerLines: headerLines,
      recordSeparator: _recordSeparator != null
          ? RecordSeparator.values.firstWhere((e) => e.name == _recordSeparator)
          : null,
      fieldSeparator: _fieldSeparatorController.text.isNotEmpty
          ? _fieldSeparatorController.text
          : null,
      fieldQuote: (_leftController.text.isNotEmpty ||
              _leftEscapeController.text.isNotEmpty ||
              _rightController.text.isNotEmpty ||
              _rightEscapeController.text.isNotEmpty)
          ? FieldQuote(
              left:
                  _leftController.text.isNotEmpty ? _leftController.text : null,
              leftEscape: _leftEscapeController.text.isNotEmpty
                  ? _leftEscapeController.text
                  : null,
              right: _rightController.text.isNotEmpty
                  ? _rightController.text
                  : null,
              rightEscape: _rightEscapeController.text.isNotEmpty
                  ? _rightEscapeController.text
                  : null,
            )
          : null,
    );
    widget.onChanged(decodeConfig);
  }

  void _showEditDialog({
    required String title,
    required Widget content,
    required VoidCallback onSave,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: content,
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              onSave();
              Navigator.of(context).pop();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const Text('Decode Configuration'),
        const SizedBox(height: 8),
        _propertyRow(
          label: 'Header Lines',
          value: _headerLinesController.text,
          onEdit: () {
            final controller =
                TextEditingController(text: _headerLinesController.text);
            _showEditDialog(
              title: 'Edit Header Lines',
              content: TextField(
                controller: controller,
                decoration:
                    const InputDecoration(labelText: 'Header Lines (int)'),
                keyboardType: TextInputType.number,
              ),
              onSave: () {
                setState(() {
                  _headerLinesController.text = controller.text;
                });
                _notifyChange();
              },
            );
          },
        ),
        _propertyRow(
          label: 'Record Separator',
          value: _recordSeparator ?? '',
          onEdit: () {
            String? selected = _recordSeparator;
            _showEditDialog(
              title: 'Edit Record Separator',
              content: DropdownButtonFormField<String>(
                value: selected,
                items: RecordSeparator.values
                    .map((e) =>
                        DropdownMenuItem(value: e.name, child: Text(e.name)))
                    .toList(),
                onChanged: (v) => selected = v,
                isExpanded: true,
              ),
              onSave: () {
                setState(() {
                  _recordSeparator = selected;
                });
                _notifyChange();
              },
            );
          },
        ),
        _propertyRow(
          label: 'Field Separator',
          value: _fieldSeparatorController.text == '\t'
              ? 'Tab (\\t)'
              : _fieldSeparatorController.text,
          onEdit: () {
            final controller =
                TextEditingController(text: _fieldSeparatorController.text);
            _showEditDialog(
              title: 'Edit Field Separator',
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: controller,
                          decoration: const InputDecoration(
                              labelText: 'Field Separator'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          controller.text = '\t';
                        },
                        child: const Text('Tab'),
                      ),
                    ],
                  ),
                  if (controller.text == '\\t' || controller.text == '\t')
                    const Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: Text(
                          'Tab character (\\t) is selected as field separator',
                          style: TextStyle(color: Colors.green)),
                    ),
                ],
              ),
              onSave: () {
                setState(() {
                  _fieldSeparatorController.text = controller.text;
                });
                _notifyChange();
              },
            );
          },
          actions: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _fieldSeparatorController.text = '\t';
                });
                _notifyChange();
              },
              child: const Text('Tab'),
            ),
          ],
        ),
        _propertyRow(
          label: 'Field Quote',
          value: _fieldQuoteSummary(),
          onEdit: () {
            final left = TextEditingController(text: _leftController.text);
            final leftEscape =
                TextEditingController(text: _leftEscapeController.text);
            final right = TextEditingController(text: _rightController.text);
            final rightEscape =
                TextEditingController(text: _rightEscapeController.text);
            _showEditDialog(
              title: 'Edit Field Quote',
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          left.text = '"';
                          leftEscape.text = '""';
                          right.text = '"';
                          rightEscape.text = '""';
                        },
                        child: const Text('Double Quote'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          left.text = '';
                          leftEscape.text = '';
                          right.text = '';
                          rightEscape.text = '';
                        },
                        child: const Text('No Quote'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          right.text = left.text;
                          rightEscape.text = leftEscape.text;
                        },
                        child: const Text('Same as Left Quote'),
                      ),
                    ],
                  ),
                  TextField(
                    controller: left,
                    decoration: const InputDecoration(labelText: 'Left Quote'),
                  ),
                  TextField(
                    controller: leftEscape,
                    decoration: const InputDecoration(labelText: 'Left Escape'),
                  ),
                  TextField(
                    controller: right,
                    decoration: const InputDecoration(labelText: 'Right Quote'),
                  ),
                  TextField(
                    controller: rightEscape,
                    decoration:
                        const InputDecoration(labelText: 'Right Escape'),
                  ),
                ],
              ),
              onSave: () {
                setState(() {
                  _leftController.text = left.text;
                  _leftEscapeController.text = leftEscape.text;
                  _rightController.text = right.text;
                  _rightEscapeController.text = rightEscape.text;
                });
                _notifyChange();
              },
            );
          },
          actions: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _leftController.text = '"';
                  _leftEscapeController.text = '""';
                  _rightController.text = '"';
                  _rightEscapeController.text = '""';
                });
                _notifyChange();
              },
              child: const Text('Double Quote'),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _leftController.text = '';
                  _leftEscapeController.text = '';
                  _rightController.text = '';
                  _rightEscapeController.text = '';
                });
                _notifyChange();
              },
              child: const Text('No Quote'),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 32.0, top: 4, bottom: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Left Quote: ${_leftController.text}'),
              const SizedBox(height: 16),
              Text('Left Escape: ${_leftEscapeController.text}'),
              const SizedBox(height: 16),
              Text('Right Quote: ${_rightController.text}'),
              const SizedBox(height: 16),
              Text('Right Escape: ${_rightEscapeController.text}'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _propertyRow(
      {required String label,
      required String value,
      required VoidCallback onEdit,
      List<Widget>? actions}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Row(
        children: [
          Expanded(child: Text('$label: $value')),
          if (actions != null) ...actions,
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: onEdit,
            tooltip: 'Edit $label',
          ),
        ],
      ),
    );
  }

  String _fieldQuoteSummary() {
    final l = _leftController.text;
    final le = _leftEscapeController.text;
    final r = _rightController.text;
    final re = _rightEscapeController.text;
    if (l.isEmpty && r.isEmpty) return '(No Quote)';
    if (l == '"' && le == '""' && r == '"' && re == '""') {
      return '(Double Quote)';
    }
    return '';
  }

  @override
  void dispose() {
    _headerLinesController.dispose();
    _fieldSeparatorController.dispose();
    _leftController.dispose();
    _leftEscapeController.dispose();
    _rightController.dispose();
    _rightEscapeController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant DecodeEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.decode != oldWidget.decode) {
      final decode = widget.decode;
      _headerLinesController.text = decode?.headerLines?.toString() ?? '';
      _recordSeparator = decode?.recordSeparator?.name;
      _fieldSeparatorController.text = decode?.fieldSeparator ?? '';
      _leftController.text = decode?.fieldQuote?.left ?? '';
      _leftEscapeController.text = decode?.fieldQuote?.leftEscape ?? '';
      _rightController.text = decode?.fieldQuote?.right ?? '';
      _rightEscapeController.text = decode?.fieldQuote?.rightEscape ?? '';
      setState(() {});
    }
  }
}
