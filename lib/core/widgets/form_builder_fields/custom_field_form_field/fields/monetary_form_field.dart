import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:paperless_mobile/api/models/data_type_enum.dart';
import 'package:paperless_mobile/helpers/custom_field_icon_mappings.dart';

/// A form field for editing a monetary custom field value.
///
/// The value is stored as a string representation of a decimal number
/// (e.g. "19.99").
class MonetaryFormField extends StatefulWidget {
  final String labelText;
  final Object? value;
  final bool enabled;
  final ValueChanged<Object?> onChanged;
  final String? errorText;

  const MonetaryFormField({
    super.key,
    required this.labelText,
    required this.value,
    required this.enabled,
    required this.onChanged,
    this.errorText,
  });

  @override
  State<MonetaryFormField> createState() => _MonetaryFormFieldState();
}

class _MonetaryFormFieldState extends State<MonetaryFormField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final initial = widget.value != null ? '${widget.value}' : '';
    _controller = TextEditingController(text: initial);
    _controller.addListener(_onTextChanged);
  }

  @override
  void didUpdateWidget(covariant MonetaryFormField oldWidget) {
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
      // Store as string to preserve decimal precision.
      widget.onChanged(text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      enabled: widget.enabled,
      keyboardType: const TextInputType.numberWithOptions(
        signed: false,
        decimal: true,
      ),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
      ],
      decoration: InputDecoration(
        labelText: widget.labelText,
        errorText: widget.errorText,
        isDense: true,
        prefixIcon: Icon(getCustomFieldIcon(DataTypeEnum.monetary)),
      ),
    );
  }
}
