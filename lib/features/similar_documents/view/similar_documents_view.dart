import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:flutter/material.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/extensions/context_extensions.dart';
import 'package:paperless_mobile/core/extensions/document_extensions.dart';
import 'package:paperless_mobile/core/extensions/flutter_extensions.dart';
import 'package:paperless_mobile/core/translation/error_code_localization_mapper.dart';
import 'package:paperless_mobile/features/documents/view/widgets/adaptive_documents_view.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';
import 'package:paperless_mobile/routing/routes/documents_route.dart';

class SimilarDocumentsView extends StatefulWidget {
  final int documentId;
  final ScrollController pagingScrollController;

  const SimilarDocumentsView({
    super.key,
    required this.pagingScrollController,
    required this.documentId,
  });

  @override
  State<SimilarDocumentsView> createState() => _SimilarDocumentsViewState();
}

class _SimilarDocumentsViewState extends State<SimilarDocumentsView> {
  ScrollController get pagingScrollController => widget.pagingScrollController;

  @override
  Widget build(BuildContext context) {
    return QueryBuilder(
      query: context.documentRepository.getAllQuery(
        filter: DocumentFilter(moreLike: widget.documentId),
      ),
      builder: (context, state) {
        if (state.isError) {
          return SliverFillRemaining(
            child: Center(
              child: Text(
                translateError(context, state.error!),
                textAlign: TextAlign.center,
              ),
            ).padded(),
          );
        }
        if (state.isLoading) {
          return SliverFillRemaining(
            child: Center(child: CircularProgressIndicator()),
          );
        }
        final data = state.data?.pages.expand((e) => e.results).toList() ?? [];
        if (data.isEmpty) {
          return SliverToBoxAdapter(
            child: Center(child: Text(S.of(context)!.noItemsFound)),
          );
        }
        return SliverAdaptiveDocumentsView(
          documents: data,
          isLabelClickable: false,
          isLoading: state.isLoading,
          hasLoaded: data.isNotEmpty,
          enableHeroAnimation: false,
          onTap: (document) {
            DocumentDetailsRoute(
              title: document.title,
              id: document.id,
              thumbnailUrl: document.buildThumbnailUrl(context),
              isLabelClickable: false,
            ).push(context);
          },
        );
      },
    );
  }
}
