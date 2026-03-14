import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:paperless_mobile/api/models/data_type_enum.dart';
import 'package:paperless_mobile/helpers/custom_field_icon_mappings.dart';

/// A form field for editing a float custom field value.
class FloatFormField extends StatefulWidget {
  final String labelText;
  final Object? value;
  final bool enabled;
  final ValueChanged<Object?> onChanged;
  final String? errorText;

  const FloatFormField({
    super.key,
    required this.labelText,
    required this.value,
    required this.enabled,
    required this.onChanged,
    this.errorText,
  });

  @override
  State<FloatFormField> createState() => _FloatFormFieldState();
}

class _FloatFormFieldState extends State<FloatFormField> {
  late final TextEditingController _controller;
  late String _decimalSeparator;

  String _formatValue(Object? value) {
    if (value == null) return '';
    final str = '$value';
    return str.replaceAll('.', _decimalSeparator);
  }

  @override
  void initState() {
    super.initState();
    // Use a sensible default; the real locale value is set in didChangeDependencies.
    _decimalSeparator = '.';
    final initial = _formatValue(widget.value);
    _controller = TextEditingController(text: initial);
    _controller.addListener(_onTextChanged);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final oldSep = _decimalSeparator;
    _decimalSeparator = _resolveDecimalSeparator();
    if (oldSep != _decimalSeparator) {
      // Re-format the displayed text with the new separator.
      _controller.removeListener(_onTextChanged);
      _controller.text = _controller.text.replaceAll(oldSep, _decimalSeparator);
      _controller.addListener(_onTextChanged);
    }
  }

  String _resolveDecimalSeparator() {
    final locale = Localizations.localeOf(context);
    final format = NumberFormat.decimalPattern(locale.toString());
    return format.symbols.DECIMAL_SEP;
  }

  @override
  void didUpdateWidget(covariant FloatFormField oldWidget) {
    super.didUpdateWidget(oldWidget);
    final newText = _formatValue(widget.value);
    final oldText = _formatValue(oldWidget.value);
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
      return;
    }
    // Skip intermediate input states that aren't complete numbers yet.
    if (text == '-' || text.endsWith(_decimalSeparator)) {
      return;
    }
    // Normalize the locale decimal separator to '.' for parsing.
    final normalized = text.replaceAll(_decimalSeparator, '.');
    if (normalized.contains('.')) {
      final parsed = double.tryParse(normalized);
      if (parsed != null) {
        widget.onChanged(parsed);
      }
    } else {
      final parsed = int.tryParse(normalized);
      if (parsed != null) {
        widget.onChanged(parsed);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final escapedSep = RegExp.escape(_decimalSeparator);
    final pattern = RegExp('^-?\\d*$escapedSep?\\d*\$');
    return TextField(
      controller: _controller,
      enabled: widget.enabled,
      keyboardType: const TextInputType.numberWithOptions(
        signed: true,
        decimal: true,
      ),
      inputFormatters: [
        TextInputFormatter.withFunction((oldValue, newValue) {
          // Accept the new value only if it matches, otherwise keep the old one.
          if (newValue.text.isEmpty || pattern.hasMatch(newValue.text)) {
            return newValue;
          }
          return oldValue;
        }),
      ],
      decoration: InputDecoration(
        prefixIcon: Icon(getCustomFieldIcon(DataTypeEnum.float)),
        labelText: widget.labelText,
        errorText: widget.errorText,
        isDense: true,
      ),
    );
  }
}
