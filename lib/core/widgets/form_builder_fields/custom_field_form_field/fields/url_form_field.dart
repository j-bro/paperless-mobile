import 'package:flutter/material.dart';
import 'package:paperless_mobile/api/models/data_type_enum.dart';
import 'package:paperless_mobile/helpers/custom_field_icon_mappings.dart';

/// A form field for editing a URL custom field value.
class UrlFormField extends StatefulWidget {
  final Object? value;
  final bool enabled;
  final ValueChanged<Object?> onChanged;
  final String labelText;
  final String? errorText;

  const UrlFormField({
    super.key,
    required this.value,
    required this.enabled,
    required this.onChanged,
    required this.labelText,
    this.errorText,
  });

  @override
  State<UrlFormField> createState() => _UrlFormFieldState();
}

class _UrlFormFieldState extends State<UrlFormField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value?.toString() ?? '');
    _controller.addListener(_onTextChanged);
  }

  @override
  void didUpdateWidget(covariant UrlFormField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value?.toString() != oldWidget.value?.toString()) {
      _controller.removeListener(_onTextChanged);
      _controller.text = widget.value?.toString() ?? '';
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
    widget.onChanged(text.isEmpty ? null : text);
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      enabled: widget.enabled,
      keyboardType: TextInputType.url,
      decoration: InputDecoration(
        labelText: widget.labelText,
        errorText: widget.errorText,
        isDense: true,
        prefixIcon: Icon(getCustomFieldIcon(DataTypeEnum.string)),
      ),
    );
  }
}
