import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:flutter/material.dart';
import 'package:paperless_mobile/api/paperless_api.dart';
import 'package:paperless_mobile/core/extensions/context_extensions.dart';
import 'package:paperless_mobile/core/extensions/document_extensions.dart';
import 'package:paperless_mobile/core/extensions/flutter_extensions.dart';
import 'package:paperless_mobile/features/documents/view/widgets/items/document_list_item.dart';
import 'package:paperless_mobile/features/landing/view/widgets/expansion_card.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';
import 'package:paperless_mobile/routing/routes/documents_route.dart';

class SavedViewPreview extends StatelessWidget {
  final SavedView savedView;
  final bool expanded;

  const SavedViewPreview({
    super.key,
    required this.savedView,
    required this.expanded,
  });

  @override
  Widget build(BuildContext context) {
    return QueryBuilder(
      query: context.documentRepository.getAllQuery(
        filter: savedView.toDocumentFilter().copyWith(pageSize: 5, page: 1),
      ),
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          ).paddedOnly(top: 8, bottom: 24);
        }
        if (state.isError) {
          return Text(S.of(context)!.couldNotLoadSavedViews).padded(16);
        }
        final savedViews = state.data?.pages.flattened;
        return ExpansionCard(
          initiallyExpanded: expanded,
          title: Text(savedView.name),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildLoaded(context, savedViews ?? []),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    icon: const Icon(Icons.open_in_new),
                    label: Text(S.of(context)!.showAll),
                    onPressed: () {
                      context.localStore.updateCurrentDocumentFilter(
                        (_) => savedView.toDocumentFilter(),
                      );
                      DocumentsRoute().go(context);
                    },
                  ).paddedOnly(bottom: 8),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLoaded(BuildContext context, List<Document> documents) {
    if (documents.isEmpty) {
      return Text(S.of(context)!.noDocumentsFound).padded();
    }
    return Column(
      children: [
        for (final document in documents)
          DocumentListItem(
            document: document,
            isLabelClickable: false,
            isSelected: false,
            isSelectionActive: false,
            onTap: (document) {
              DocumentDetailsRoute(
                title: document.title,
                documentId: document.id,
                thumbnailUrl: document.buildThumbnailUrl(context),
              ).push(context);
            },
            onSelected: null,
          ),
      ],
    );
  }
}
