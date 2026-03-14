import 'package:flutter/material.dart';

class BooleanFieldValue extends StatelessWidget {
  final Object? value;
  final TextStyle? style;
  final Widget placeholder;

  const BooleanFieldValue({
    super.key,
    required this.value,
    this.style,
    required this.placeholder,
  });

  @override
  Widget build(BuildContext context) {
    if (value == null) return placeholder;
    final checked = value == true || value == 'true';
    return Icon(
      checked ? Icons.check_box : Icons.check_box_outline_blank_rounded,
      color: checked
          ? Theme.of(context).colorScheme.primary
          : Theme.of(context).colorScheme.outline,
      size: 24,
    );
  }
}
