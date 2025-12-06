import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:flutter/material.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/extensions/context_extensions.dart';
import 'package:paperless_mobile/core/repository/tag_repository.dart';
import 'package:paperless_mobile/features/labels/tags/view/widgets/tag_widget.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class TagsWidget extends StatelessWidget {
  final void Function(int tagId)? onTagSelected;
  final List<int>? tagIds;
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
    required List<int>? tagIds,
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
      query: context.tagRepository.getAllQuery(),
      builder: (context, state) {
        if (state.isError) {
          return Text(
            'Could not load tags. ${state.error}',
          ); // TODO: INTL/error handling
        }
        final mockTags = _generateMockTags(tagIds ?? [1, 2, 3]);
        final tags = state.data ?? mockTags;
        final mappedTags = (tagIds ?? [1, 2, 3])
            .map((id) => tags.firstWhere((tag) => tag.id == id))
            .toList();
        final isLoading =
            state.isLoading && state.data == null || tagIds == null;

        debugPrint('TagsWidget build: isLoading=$isLoading');
        return Skeletonizer(
          enabled: isLoading,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final tag in mappedTags)
                  Skeleton.shade(
                    child: TagWidget(
                      tag: tag,
                      isClickable: isClickable,
                      onSelected: () {
                        if (state.isSuccess) {
                          // We can be sure that we operate on actual data here.
                          onTagSelected?.call(tag.id);
                        }
                      },
                      showShortName: showShortNames,
                      dense: dense,
                    ),
                  ),
              ],
            ),
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
        if (state.isError) {
          return Text('Could not load tags.'); // TODO: INTL/error handling
        }
        final mockTags = _generateMockTags(tagIds ?? [1, 2, 3]);
        final tags = state.data ?? mockTags;
        final mappedTags = (tagIds ?? [1, 2, 3])
            .map((id) => tags.firstWhere((tag) => tag.id == id))
            .toList();
        return Skeletonizer(
          child: Wrap(
            runAlignment: WrapAlignment.start,
            runSpacing: 4,
            spacing: 4,
            children: [
              for (final tag in mappedTags)
                TagWidget(
                  tag: tag,
                  isClickable: isClickable,
                  onSelected: () {
                    if (state.isSuccess) {
                      // We can be sure that we operate on actual data here.
                      onTagSelected?.call(tag.id);
                    }
                  },
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
        final mockTags = _generateMockTags(tagIds ?? [1, 2, 3]);
        final tags = state.data ?? mockTags;
        final mappedTags = (tagIds ?? [1, 2, 3])
            .map((id) => tags.firstWhere((tag) => tag.id == id))
            .toList();
        return Skeletonizer.sliver(
          child: SliverList.list(
            children: [
              for (final tag in mappedTags)
                TagWidget(
                  tag: tag,
                  isClickable: isClickable,
                  onSelected: () {
                    if (state.isSuccess) {
                      // We can be sure that we operate on actual data here.
                      onTagSelected?.call(tag.id);
                    }
                  },
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

List<Tag> _generateMockTags(List<int> ids) {
  return List<Tag>.generate(
    ids.length,
    (index) => Tag(
      id: ids[index],
      name: BoneMock.words(1),
      documentCount: 0,
      slug: BoneMock.words(1),
      userCanChange: false,
    ),
  );
}
