import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class DetailsItem extends StatelessWidget {
  final String label;
  final String fallback;
  final Widget content;

  const DetailsItem({
    super.key,
    required this.label,
    required this.content,
    this.fallback = '-',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodySmall),
        content,
      ],
    );
  }

  DetailsItem.text(
    String? text, {
    super.key,
    required this.label,
    required BuildContext context,
    this.fallback = '-',
  }) : content = Text(
         text ?? fallback,
         style: Theme.of(context).textTheme.bodyLarge,
       );
}

class DetailsItemSkeleton extends StatelessWidget {
  final String label;
  const DetailsItemSkeleton({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Skeleton.keep(
            child: Text(label, style: Theme.of(context).textTheme.bodySmall),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            height: 16,
            color: Colors.grey.shade300,
          ),
        ],
      ),
    );
  }
}
