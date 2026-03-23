import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperless_mobile/api/paperless_api.dart';
import 'package:paperless_mobile/core/bloc/connectivity_cubit.dart';
import 'package:paperless_mobile/core/extensions/document_extensions.dart';
import 'package:paperless_mobile/core/repository/document_repository.dart';
import 'package:paperless_mobile/features/documents/view/widgets/adaptive_documents_view.dart';
import 'package:paperless_mobile/features/documents/view/widgets/selection/view_type_selection_widget.dart';
import 'package:paperless_mobile/features/settings/model/view_type.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';
import 'package:paperless_mobile/routing/routes/documents_route.dart';

class LinkedDocumentsPage extends StatefulWidget {
  final DocumentFilter filter;
  const LinkedDocumentsPage({super.key, required this.filter});

  @override
  State<LinkedDocumentsPage> createState() => _LinkedDocumentsPageState();
}

class _LinkedDocumentsPageState extends State<LinkedDocumentsPage> {
  final pagingScrollController = ScrollController();
  ViewType _viewType = ViewType.list;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context)!.linkedDocuments),
        actions: [
          ViewTypeSelectionWidget(
            viewType: _viewType,
            onChanged: (viewType) {
              setState(() {
                _viewType = viewType;
              });
            },
          ),
        ],
      ),
      body: QueryBuilder(
        query: context.read<DocumentRepository>().getAllQuery(
          filter: widget.filter,
        ),
        builder: (context, state) {
          return BlocBuilder<ConnectivityCubit, ConnectivityState>(
            builder: (context, connectivity) {
              return CustomScrollView(
                controller: pagingScrollController,
                slivers: [
                  SliverAdaptiveDocumentsView(
                    viewType: _viewType,
                    documents:
                        state.data?.pages.expand((e) => e.results).toList() ??
                        [],
                    isLabelClickable: false,
                    isLoading: state.isLoading,
                    hasLoaded: state.data != null,
                    onTap: (document) {
                      DocumentDetailsRoute(
                        title: document.title,
                        documentId: document.id,
                        isLabelClickable: false,
                        thumbnailUrl: document.buildThumbnailUrl(context),
                        heroTagPrefix: 'linked_document',
                      ).push(context);
                    },
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
