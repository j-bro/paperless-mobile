import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperless_api/generated/lib/src/model/saved_view.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/extensions/context_extensions.dart';
import 'package:paperless_mobile/core/extensions/document_extensions.dart';
import 'package:paperless_mobile/core/extensions/flutter_extensions.dart';
import 'package:paperless_mobile/features/documents/cubit/documents_cubit.dart';
import 'package:paperless_mobile/features/documents/view/widgets/items/document_list_item.dart';
import 'package:paperless_mobile/features/landing/view/widgets/expansion_card.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';
import 'package:paperless_mobile/routing/routes/documents_route.dart';
import 'package:provider/provider.dart';

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
        savedView.toDocumentFilter().copyWith(pageSize: 5, page: 1),
      ),
      builder: (context, state) {
        return ExpansionCard(
          initiallyExpanded: expanded,
          title: Text(savedView.name),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Builder(
                builder: (context) {
                  if (state.isLoading) {
                    return const CircularProgressIndicator().paddedOnly(
                      top: 8,
                      bottom: 24,
                    );
                  }
                  if (state.isError) {
                    return Text(
                      S.of(context)!.couldNotLoadSavedViews,
                    ).padded(16);
                  }
                  final documents =
                      state.data?.pages.expand((e) => e.results) ?? [];

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
                              id: document.id,
                              thumbnailUrl: document.buildThumbnailUrl(context),
                            ).push(context);
                          },
                          onSelected: null,
                        ),
                    ],
                  );
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    icon: const Icon(Icons.open_in_new),
                    label: Text(S.of(context)!.showAll),
                    onPressed: () {
                      context.read<DocumentsCubit>().updateFilter(
                        filter: savedView.toDocumentFilter(),
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
}
