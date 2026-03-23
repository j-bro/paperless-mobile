import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:paperless_mobile/api/paperless_api.dart';
import 'package:paperless_mobile/core/extensions/context_extensions.dart';
import 'package:paperless_mobile/core/extensions/flutter_extensions.dart';
import 'package:paperless_mobile/features/documents/view/widgets/document_preview.dart';
import 'package:paperless_mobile/features/documents/view/widgets/items/document_item.dart';
import 'package:paperless_mobile/features/labels/correspondent/view/widgets/correspondent_widget.dart';
import 'package:paperless_mobile/features/labels/document_type/view/widgets/document_type_widget.dart';
import 'package:paperless_mobile/features/labels/tags/view/widgets/tags_widget.dart';

class DocumentGridItem extends DocumentItem {
  const DocumentGridItem({
    super.key,
    required super.document,
    required super.isSelected,
    required super.isSelectionActive,
    required super.isLabelClickable,
    super.onCorrespondentSelected,
    super.onDocumentTypeSelected,
    super.onSelected,
    super.onStoragePathSelected,
    super.onTagSelected,
    super.onTap,
    super.heroTagPrefix,
    super.isEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: isEnabled ? 1.0 : 0.38,
      child: IgnorePointer(
        ignoring: !isEnabled,
        child: Stack(
          children: [
            Card(
              color: isSelected
                  ? Theme.of(context).colorScheme.inversePrimary
                  : null,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: _onTap,
                onLongPress: onSelected != null
                    ? () => onSelected!(document)
                    : null,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: DocumentPreview(
                                documentId: document.id,
                                borderRadius: 12.0,
                                heroTagPrefix: heroTagPrefix,
                                title: document.title,
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: SizedBox(
                                height: kMinInteractiveDimension,
                                child: NotificationListener<ScrollNotification>(
                                  // Prevents ancestor notification listeners to be notified when this widget scrolls
                                  onNotification: (notification) => true,
                                  child: TagsWidget(
                                    tagIds: document.tags,
                                    onTagSelected: onTagSelected,
                                  ).padded(),
                                  // child: CustomScrollView(
                                  //   scrollDirection: Axis.horizontal,
                                  //   slivers: [
                                  //     const SliverToBoxAdapter(
                                  //       child: SizedBox(width: 8),
                                  //     ),
                                  //     if (currentUser.canViewTags)
                                  //       TagsWidget.sliver(
                                  //         tagIds: document.tags,
                                  //         onTagSelected: onTagSelected,
                                  //       ),
                                  //     const SliverToBoxAdapter(
                                  //       child: SizedBox(width: 8),
                                  //     ),
                                  //   ],
                                  // ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (context.uiSettings$.canViewCorrespondents)
                              CorrespondentWidget(
                                id: document.correspondent,
                                onSelected: onCorrespondentSelected,
                              ),
                            if (context.uiSettings$.canViewDocumentTypes)
                              DocumentTypeWidget(
                                id: document.documentType,
                                onSelected: onDocumentTypeSelected,
                              ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Text(
                                document.title ?? '-',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                            const Spacer(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                if (document.created != null)
                                  Text(
                                    DateFormat.yMMMMd(
                                      Localizations.localeOf(
                                        context,
                                      ).toString(),
                                    ).format(document.created!),
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall,
                                  ),
                                if (document.archiveSerialNumber != null)
                                  Text(
                                    '#${document.archiveSerialNumber!}',
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.onSurface,
                                        ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onTap() {
    if (isSelectionActive || isSelected) {
      onSelected?.call(document);
    } else {
      onTap?.call(document);
    }
  }
}
