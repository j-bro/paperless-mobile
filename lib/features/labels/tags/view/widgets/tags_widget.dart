import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:flutter/material.dart';
import 'package:paperless_mobile/core/extensions/label_list_extension.dart';
import 'package:paperless_mobile/core/repository/tag_repository.dart';
import 'package:paperless_mobile/features/documents/view/widgets/placeholder/tags_placeholder.dart';
import 'package:paperless_mobile/features/labels/tags/view/widgets/tag_widget.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class TagsWidget extends StatelessWidget {
  final void Function(int tagId)? onTagSelected;
  final List<int> tagIds;
  final bool isClickable;
  final bool showShortNames;
  final bool dense;

  const TagsWidget({
    super.key,
    required this.tagIds,
    this.onTagSelected,
    this.isClickable = true,
    this.showShortNames = false,
    this.dense = true,
  });

  const factory TagsWidget.multiLine({
    Key? key,
    required void Function(int tagId)? onTagSelected,
    required bool isClickable,
    required bool showShortNames,
    required bool dense,
    required List<int> tagIds,
  }) = _MultiLineTagsWidget;

  const factory TagsWidget.sliver({
    Key? key,
    void Function(int tagId)? onTagSelected,
    bool isClickable,
    bool showShortNames,
    bool dense,
    required List<int> tagIds,
  }) = _SliverTagsWidget;

  @override
  Widget build(BuildContext context) {
    return QueryBuilder(
      query: context.read<TagRepository>().getAllQuery(),
      builder: (context, state) {
        if (state.isLoading) {
          return Skeletonizer(
            child: TagsPlaceholder(count: tagIds.length, dense: dense),
          );
        }

        final tags = state.data?.toIdMap() ?? {};
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (final tag in tagIds)
                if (tags.containsKey(tag))
                  TagWidget(
                    tag: tags[tag]!,
                    isClickable: isClickable,
                    onSelected: () => onTagSelected?.call(tag),
                    showShortName: showShortNames,
                    dense: dense,
                  ),
            ],
          ),
        );
      },
    );
  }
}

class _MultiLineTagsWidget extends TagsWidget {
  const _MultiLineTagsWidget({
    super.key,
    required super.tagIds,
    super.onTagSelected,
    super.isClickable,
    super.showShortNames,
    super.dense,
  });

  @override
  Widget build(BuildContext context) {
    return QueryBuilder(
      query: context.read<TagRepository>().getAllQuery(),
      builder: (context, state) {
        if (state.isLoading) {
          return TagsPlaceholder(
            count: tagIds.length,
            dense: dense,
            wrap: true,
          );
        }
        final tags = state.data?.toIdMap() ?? {};
        return Wrap(
          runAlignment: WrapAlignment.start,
          runSpacing: 4,
          spacing: 4,
          children: [
            for (final tag in tagIds)
              if (tags.containsKey(tag))
                TagWidget(
                  tag: tags[tag]!,
                  isClickable: isClickable,
                  onSelected: () => onTagSelected?.call(tag),
                  showShortName: showShortNames,
                  dense: dense,
                ),
          ],
        );
      },
    );
  }
}

class _SliverTagsWidget extends TagsWidget {
  const _SliverTagsWidget({
    super.key,
    required super.tagIds,
    super.isClickable,
    super.showShortNames,
    super.dense,
    super.onTagSelected,
  });

  @override
  Widget build(BuildContext context) {
    return QueryBuilder(
      query: context.read<TagRepository>().getAllQuery(),
      builder: (context, state) {
        if (state.isLoading) {
          return SliverList.list(
            children: List.generate(
              tagIds.length,
              (index) => TagPlaceholder(lengthIndex: index),
            ),
          );
        }
        final tags = state.data?.toIdMap() ?? {};
        return SliverList.list(
          children: [
            for (final tag in tagIds)
              if (tags.containsKey(tag))
                TagWidget(
                  tag: tags[tag]!,
                  isClickable: isClickable,
                  onSelected: () => onTagSelected?.call(tag),
                  showShortName: showShortNames,
                  dense: dense,
                ),
          ],
        );
      },
    );
  }
}
