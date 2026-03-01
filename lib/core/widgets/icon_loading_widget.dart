import 'package:flutter/material.dart';

class IconLoadingWidget extends StatelessWidget {
  final double? progress;
  const IconLoadingWidget({super.key, this.progress});

  @override
  Widget build(BuildContext context) {
    final iconSize = (Theme.of(context).iconTheme.size ?? 24) * 0.8;
    return SizedBox(
      width: iconSize,
      height: iconSize,
      child: CircularProgressIndicator(strokeWidth: 2, value: progress),
    );
  }
}
