import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateFieldValue extends StatelessWidget {
  final Object? value;
  final TextStyle? style;
  final Widget placeholder;

  const DateFieldValue({
    super.key,
    required this.value,
    this.style,
    required this.placeholder,
  });

  @override
  Widget build(BuildContext context) {
    if (value == null) return placeholder;
    final locale = Localizations.localeOf(context).toString();
    try {
      final date = DateTime.parse('$value');
      return Text(DateFormat.yMMMMd(locale).format(date), style: style);
    } catch (_) {
      return Text('$value', style: style);
    }
  }
}
