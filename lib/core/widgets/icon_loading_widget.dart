import 'package:flutter/material.dart';

class IconLoadingWidget extends StatelessWidget {
  const IconLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final iconSize = Theme.of(context).iconTheme.size ?? 24;
    return SizedBox(
      width: iconSize,
      height: iconSize,
      child: const CircularProgressIndicator(strokeWidth: 2),
    );
  }
}
