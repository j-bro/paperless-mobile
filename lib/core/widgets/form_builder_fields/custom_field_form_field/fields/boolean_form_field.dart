import 'package:flutter/material.dart';

/// A form field for editing a boolean custom field value.
class BooleanFormField extends StatelessWidget {
  final String labelText;
  final Object? value;
  final bool enabled;
  final ValueChanged<Object?> onChanged;
  final String? errorText;

  const BooleanFormField({
    super.key,
    required this.labelText,
    required this.value,
    required this.enabled,
    required this.onChanged,
    this.errorText,
  });

  bool _parseBool() {
    return value == true || value == 'true';
  }

  @override
  Widget build(BuildContext context) {
    final checked = value != null ? _parseBool() : false;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        CheckboxListTile(
          title: Text(labelText),
          value: checked,
          onChanged: enabled ? (newValue) => onChanged(newValue) : null,
          contentPadding: EdgeInsets.zero,
          dense: true,
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(left: 12, top: 4),
            child: Text(
              errorText!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          ),
      ],
    );
  }
}
