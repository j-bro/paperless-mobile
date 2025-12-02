import 'package:flutter/material.dart';
import 'package:paperless_mobile/core/extensions/flutter_extensions.dart';
import 'package:skeletonizer/skeletonizer.dart';

class TagPlaceholder extends StatelessWidget {
  static const _lengths = <double>[90, 70, 130];
  final int lengthIndex;
  const TagPlaceholder({super.key, required this.lengthIndex});

  @override
  Widget build(BuildContext context) {
    return Skeleton.shade(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        width: _lengths[lengthIndex % _lengths.length],
        height: 32,
      ).paddedOnly(right: 4),
    );
  }
}

class TagsPlaceholder extends StatelessWidget {
  final int count;
  final bool dense;
  final bool wrap;
  const TagsPlaceholder({
    super.key,
    required this.count,
    this.dense = true,
    this.wrap = false,
  });

  @override
  Widget build(BuildContext context) {
    final children = [
      for (int i = 0; i < count; i++) TagPlaceholder(lengthIndex: i),
    ];

    final child = wrap
        ? Wrap(
            spacing: 4,
            runSpacing: 4,
            runAlignment: WrapAlignment.start,
            children: children,
          )
        : Row(children: children);
    return SizedBox(
      height: wrap ? null : 32,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        child: child,
      ),
    );
  }
}
