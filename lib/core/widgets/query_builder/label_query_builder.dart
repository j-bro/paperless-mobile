import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:flutter/material.dart';
import 'package:paperless_mobile/api/paperless_api.dart';
import 'package:paperless_mobile/core/extensions/context_extensions.dart';
import 'package:paperless_mobile/core/extensions/label_list_extension.dart';
import 'package:provider/provider.dart';

class CombinedError {
  final dynamic correspondentError;
  final dynamic documentTypeError;
  final dynamic storagePathError;
  final dynamic tagError;

  CombinedError({
    required this.correspondentError,
    required this.documentTypeError,
    required this.storagePathError,
    required this.tagError,
  });
}

class LabelBuilderState {
  final bool isLoading;
  final bool isError;
  final LabelBuilderData data;

  LabelBuilderState({
    required this.isLoading,
    required this.isError,
    required this.data,
  });
}

class LabelBuilderData {
  final Map<int, Correspondent> correspondents;
  final Map<int, DocumentType> documentTypes;
  final Map<int, StoragePath> storagePaths;
  final Map<int, Tag> tags;

  LabelBuilderData({
    required this.correspondents,
    required this.documentTypes,
    required this.storagePaths,
    required this.tags,
  });
}

class LabelQueryBuilder extends StatelessWidget {
  final Widget Function(BuildContext, QueryStatus<LabelBuilderData>) builder;
  final Selector? buildWhen;
  const LabelQueryBuilder({super.key, required this.builder, this.buildWhen});

  @override
  Widget build(BuildContext context) {
    final correspondentRepository = context.correspondentRepository;
    final documentTypeRepository = context.documentTypeRepository;
    final storagePathRepository = context.storagePathRepository;
    final tagRepository = context.tagRepository;

    return QueryBuilder(
      query: correspondentRepository.getAllQuery(),
      builder: (_, correspondentState) => QueryBuilder(
        query: documentTypeRepository.getAllQuery(),
        builder: (_, documentTypeState) => QueryBuilder(
          query: storagePathRepository.getAllQuery(),
          builder: (_, storagePathState) => QueryBuilder(
            query: tagRepository.getAllQuery(),
            builder: (_, tagState) {
              final isError =
                  correspondentState.isError ||
                  documentTypeState.isError ||
                  storagePathState.isError ||
                  tagState.isError;

              final earliestTimeCreated = [
                correspondentState.timeCreated,
                documentTypeState.timeCreated,
                storagePathState.timeCreated,
                tagState.timeCreated,
              ].reduce((a, b) => a.isBefore(b) ? a : b);

              final data = LabelBuilderData(
                correspondents: correspondentState.data?.toIdMap() ?? {},
                documentTypes: documentTypeState.data?.toIdMap() ?? {},
                storagePaths: storagePathState.data?.toIdMap() ?? {},
                tags: tagState.data?.toIdMap() ?? {},
              );
              if (isError) {
                return builder(
                  context,
                  QueryStatus<LabelBuilderData>.error(
                    data: data,
                    error: CombinedError(
                      correspondentError: correspondentState.error,
                      documentTypeError: documentTypeState.error,
                      storagePathError: storagePathState.error,
                      tagError: tagState.error,
                    ),
                    stackTrace: StackTrace.empty,
                    timeCreated: earliestTimeCreated,
                  ),
                );
              }

              final loading =
                  correspondentState.isLoading ||
                  documentTypeState.isLoading ||
                  storagePathState.isLoading ||
                  tagState.isLoading;

              if (loading) {
                return builder(
                  context,
                  QueryStatus<LabelBuilderData>.loading(
                    data: data,
                    isInitialFetch:
                        correspondentState.isInitial ||
                        documentTypeState.isInitial ||
                        storagePathState.isInitial ||
                        tagState.isInitial,
                    isRefetching:
                        !(correspondentState.isInitial ||
                            documentTypeState.isInitial ||
                            storagePathState.isInitial ||
                            tagState.isInitial),
                    timeCreated: earliestTimeCreated,
                  ),
                );
              }

              return builder(
                context,
                QueryStatus<LabelBuilderData>.success(
                  data: data,
                  timeCreated: earliestTimeCreated,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
