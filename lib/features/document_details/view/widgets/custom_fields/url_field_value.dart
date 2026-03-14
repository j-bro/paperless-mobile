import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class UrlFieldValue extends StatelessWidget {
  final Object? value;
  final TextStyle? style;
  final Widget placeholder;

  const UrlFieldValue({
    super.key,
    required this.value,
    this.style,
    required this.placeholder,
  });

  @override
  Widget build(BuildContext context) {
    if (value == null) return placeholder;
    final url = '$value';
    return GestureDetector(
      onTap: () => launchUrlString(url, mode: LaunchMode.externalApplication),
      child: Text(
        url,
        style: style?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          decoration: TextDecoration.underline,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
