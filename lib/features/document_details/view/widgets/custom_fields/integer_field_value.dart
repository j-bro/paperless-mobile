import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class IntegerFieldValue extends StatelessWidget {
  final Object? value;
  final TextStyle? style;
  final Widget placeholder;

  const IntegerFieldValue({
    super.key,
    required this.value,
    this.style,
    required this.placeholder,
  });

  @override
  Widget build(BuildContext context) {
    if (value == null) return placeholder;
    final locale = Localizations.localeOf(context).toString();
    final parsed = int.tryParse('$value');
    if (parsed != null) {
      return Text(
        NumberFormat.decimalPattern(locale).format(parsed),
        style: style,
      );
    }
    return Text('$value', style: style);
  }
}
