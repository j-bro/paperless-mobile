import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:paperless_mobile/api/models/data_type_enum.dart';
import 'package:paperless_mobile/helpers/custom_field_icon_mappings.dart';

/// A form field for editing an integer custom field value.
class IntegerFormField extends StatefulWidget {
  final String labelText;
  final Object? value;
  final bool enabled;
  final ValueChanged<Object?> onChanged;
  final String? errorText;

  const IntegerFormField({
    super.key,
    required this.labelText,
    required this.value,
    required this.enabled,
    required this.onChanged,
    this.errorText,
  });

  @override
  State<IntegerFormField> createState() => _IntegerFormFieldState();
}

class _IntegerFormFieldState extends State<IntegerFormField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final initial = widget.value != null ? '${widget.value}' : '';
    _controller = TextEditingController(text: initial);
    _controller.addListener(_onTextChanged);
  }

  @override
  void didUpdateWidget(covariant IntegerFormField oldWidget) {
    super.didUpdateWidget(oldWidget);
    final newText = widget.value != null ? '${widget.value}' : '';
    final oldText = oldWidget.value != null ? '${oldWidget.value}' : '';
    if (newText != oldText) {
      _controller.removeListener(_onTextChanged);
      _controller.text = newText;
      _controller.addListener(_onTextChanged);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    final text = _controller.text;
    if (text.isEmpty) {
      widget.onChanged(null);
    } else {
      final parsed = int.tryParse(text);
      widget.onChanged(parsed ?? text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      enabled: widget.enabled,
      keyboardType: const TextInputType.numberWithOptions(
        signed: true,
        decimal: false,
      ),
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^-?\d*'))],
      decoration: InputDecoration(
        prefixIcon: Icon(getCustomFieldIcon(DataTypeEnum.integer)),
        labelText: widget.labelText,
        errorText: widget.errorText,
        isDense: true,
      ),
    );
  }
}
