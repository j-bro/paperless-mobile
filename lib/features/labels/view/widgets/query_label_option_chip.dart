import 'package:flutter/material.dart';
import 'package:paperless_mobile/core/workarounds/colored_chip.dart';

class LabelQueryOptionChip extends StatelessWidget {
  final VoidCallback onDeleted;
  final VoidCallback? onSelected;
  final bool exclude;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final String labelText;

  const LabelQueryOptionChip({
    super.key,
    required this.onDeleted,
    this.onSelected,
    required this.exclude,
    this.backgroundColor,
    this.foregroundColor,
    required this.labelText,
  });

  @override
  Widget build(BuildContext context) {
    return ColoredChipWrapper(
      child: InputChip(
        labelPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        padding: const EdgeInsets.all(4),
        selectedColor: backgroundColor,
        visualDensity: const VisualDensity(vertical: -2),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        label: Text(
          labelText,
          style: TextStyle(
            color: foregroundColor,
            decorationColor: foregroundColor,
            decoration: exclude ? TextDecoration.lineThrough : null,
          ),
        ),
        onDeleted: onDeleted,
        onPressed: onSelected,
        deleteIconColor: foregroundColor,
        checkmarkColor: foregroundColor,
        backgroundColor: backgroundColor,
        side: BorderSide.none,
      ),
    );
  }
}
