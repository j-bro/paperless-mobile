import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:paperless_mobile/api/paperless_api.dart';
import 'package:paperless_mobile/core/extensions/context_extensions.dart';
import 'package:paperless_mobile/core/extensions/flutter_extensions.dart';
import 'package:paperless_mobile/core/widgets/highlighted_text.dart';
import 'package:paperless_mobile/features/document_details/view/widgets/details_item.dart';
import 'package:paperless_mobile/features/labels/tags/view/widgets/tags_widget.dart';
import 'package:paperless_mobile/features/labels/view/widgets/label_text.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';

class DocumentOverviewWidget extends StatelessWidget {
  final Document document;
  final String? queryString;
  final double itemSpacing;

  const DocumentOverviewWidget({
    super.key,
    required this.document,
    this.queryString,
    required this.itemSpacing,
  });

  @override
  Widget build(BuildContext context) {
    final user = context.loggedInUser$.paperlessUser;
    return SliverList.list(
      children: [
        if (document.title?.isNotEmpty ?? false)
          DetailsItem(
            label: S.of(context)!.title,
            content: HighlightedText(
              text: document.title!,
              highlights: queryString?.split(" ") ?? [],
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        DetailsItem.text(
          document.created != null
              ? DateFormat.yMMMMd(
                  Localizations.localeOf(context).toString(),
                ).format(document.created!)
              : null,
          context: context,
          label: S.of(context)!.createdAt,
        ),
        if (document.documentType != null && user.canViewDocumentTypes)
          QueryBuilder(
            query: context.documentTypeRepository.getAllQuery(),
            builder: (context, state) {
              if (state.isLoading && state.data == null) {
                return DetailsItemSkeleton(label: S.of(context)!.documentType);
              }
              if (state.isError) {
                return SizedBox.shrink();
              }
              final documentType = state.data?.firstWhere(
                (dt) => dt.id == document.documentType,
              );
              return DetailsItem(
                label: S.of(context)!.documentType,
                content: LabelText(
                  style: Theme.of(context).textTheme.bodyLarge,
                  label: documentType,
                ),
              );
            },
          )
        else
          DetailsItem(
            label: S.of(context)!.documentType,
            content: LabelText(
              style: Theme.of(context).textTheme.bodyLarge,
              label: null,
            ),
          ),
        if (document.correspondent != null && user.canViewCorrespondents)
          QueryBuilder(
            query: context.correspondentRepository.getAllQuery(),
            builder: (context, state) {
              if (state.isLoading && state.data == null) {
                return DetailsItemSkeleton(label: S.of(context)!.documentType);
              }
              if (state.isError) {
                return SizedBox.shrink();
              }
              final correspondent = state.data?.firstWhere(
                (c) => c.id == document.correspondent,
              );
              return DetailsItem(
                label: S.of(context)!.correspondent,
                content: LabelText(
                  style: Theme.of(context).textTheme.bodyLarge,
                  label: correspondent,
                ),
              );
            },
          )
        else
          DetailsItem(
            label: S.of(context)!.correspondent,
            content: LabelText(
              style: Theme.of(context).textTheme.bodyLarge,
              label: null,
            ),
          ),
        if (document.storagePath != null && user.canViewStoragePaths)
          QueryBuilder(
            query: context.storagePathRepository.getAllQuery(),
            builder: (context, state) {
              if (state.isLoading && state.data == null) {
                return DetailsItemSkeleton(label: S.of(context)!.storagePath);
              }
              if (state.isError) {
                return SizedBox.shrink();
              }

              final storagePath = state.data?.firstWhere(
                (s) => s.id == document.storagePath,
              );
              return DetailsItem(
                label: S.of(context)!.storagePath,
                content: LabelText(
                  style: Theme.of(context).textTheme.bodyLarge,
                  label: storagePath,
                ),
              );
            },
          )
        else
          DetailsItem(
            label: S.of(context)!.storagePath,
            content: LabelText(
              style: Theme.of(context).textTheme.bodyLarge,
              label: null,
            ),
          ),
        if (document.tags.isNotEmpty && user.canViewTags)
          DetailsItem(
            label: S.of(context)!.tags,
            content: TagsWidget(isClickable: false, tagIds: document.tags),
          )
        else
          DetailsItem(
            label: S.of(context)!.tags,
            content: LabelText(
              style: Theme.of(context).textTheme.bodyLarge,
              label: null,
            ),
          ),
      ].map((e) => e.paddedOnly(bottom: itemSpacing)).toList(),
    );
  }
}
