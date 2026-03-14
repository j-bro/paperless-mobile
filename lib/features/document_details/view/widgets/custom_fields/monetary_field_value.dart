import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MonetaryFieldValue extends StatelessWidget {
  final Object? value;
  final TextStyle? style;
  final Widget placeholder;

  const MonetaryFieldValue({
    super.key,
    required this.value,
    this.style,
    required this.placeholder,
  });

  @override
  Widget build(BuildContext context) {
    if (value == null) return placeholder;
    final parsed = double.tryParse('$value');
    if (parsed != null) {
      return Text(NumberFormat.simpleCurrency().format(parsed), style: style);
    }
    return Text('$value', style: style);
  }
}
