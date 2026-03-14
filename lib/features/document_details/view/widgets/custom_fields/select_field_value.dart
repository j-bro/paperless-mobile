import 'package:flutter/material.dart';

class SelectFieldValue extends StatelessWidget {
  final Object? value;
  final Object? extraData;
  final TextStyle? style;
  final Widget placeholder;

  const SelectFieldValue({
    super.key,
    required this.value,
    this.extraData,
    this.style,
    required this.placeholder,
  });

  @override
  Widget build(BuildContext context) {
    if (value == null) return placeholder;

    // extraData contains select options; try to resolve the label.
    final label = _resolveSelectLabel(value, extraData);
    return Text(label ?? '$value', style: style);
  }

  String? _resolveSelectLabel(Object? value, Object? extraData) {
    if (extraData is Map) {
      final options = extraData['select_options'];
      if (options is List) {
        for (final option in options) {
          if (option is Map && option['value'] == value) {
            return option['label']?.toString();
          }
        }
      }
    }
    // Fallback: return the raw value.
    return value?.toString();
  }
}
