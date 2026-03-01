import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/repository/document_repository.dart';
import 'package:paperless_mobile/core/repository/tag_repository.dart';
import 'package:paperless_mobile/features/logging/data/logger.dart';

class InboxData {
  final InfiniteQueryData<PaginatedDocumentList, int> documents;
  final List<Tag> inboxTags;

  List<Document> get flattened =>
      documents.pages.expand((page) => page.results).toList();
  InboxData({required this.documents, required this.inboxTags});
}

class InboxRepository {
  static const List<String> inboxQueryKeys = ['inbox_documents', 'tags'];

  final DocumentRepository _documentsRepo;
  final TagRepository _tagsRepo;

  InboxRepository(this._documentsRepo, this._tagsRepo) {
    _documentsRepo.registerQueryKeyForInvalidation('inbox');
  }

  Query<List<Tag>> get inboxTagsQuery {
    return Query<List<Tag>>(
      key: 'tags_inbox',
      queryFn: () async {
        final tags = await _tagsRepo.getAllQuery().fetch();
        return tags.data?.where((tag) => tag.isInboxTag).toList() ?? [];
      },
    );
  }

  Future<DocumentFilter> buildInboxFilter([int page = 1]) async {
    final inboxTags = await inboxTagsQuery.fetch().then(
      (state) => state.data ?? <Tag>[],
    );

    return DocumentFilter(
      page: page,
      tags: AnyAssignedTagsQuery(tagIds: inboxTags.map((e) => e.id).toList()),
    );
  }

  Future<void> reload() async {
    await CachedQuery.instance.refetchQueries(
      keys: InboxRepository.inboxQueryKeys,
    );
    await inboxDocumentsQuery.refetch();
  }

  InfiniteQuery<PaginatedDocumentList, int> get inboxDocumentsQuery {
    return InfiniteQuery(
      key: 'inbox',
      queryFn: (page) async {
        final filter = await buildInboxFilter(page);
        final response = await _documentsRepo
            .getAllQuery(filter: filter, overrideKey: 'inbox_documents')
            .fetch();
        return response.data!.lastPage!;
      },
      getNextArg: (state) {
        if (state == null) return 1;
        final currentCount = state.args.length * DocumentFilter().pageSize;
        final totalCount = state.lastPage?.results.length ?? 0;
        if (currentCount >= totalCount) {
          return null;
        }
        return state.args.last + 1;
      },
    );
  }

  Query<int> get inboxDocumentCountQuery {
    return Query(
      config: QueryConfig(staleDuration: Duration(seconds: 30)),
      key: 'inbox_count',
      queryFn: () async {
        final tagsResult = await inboxTagsQuery.fetch();
        if (tagsResult.isError) {
          throw tagsResult.error!;
        }
        final inboxTags = tagsResult.data!.map((e) => e.id);
        final filter = DocumentFilter(
          fields: ['id', 'tags'],
          tags: AnyAssignedTagsQuery(tagIds: inboxTags.toList()),
        );
        final documentsResult = await _documentsRepo
            .getAllQuery(filter: filter, overrideKey: 'inbox_documents_count')
            .fetch();
        if (documentsResult.isError) {
          throw documentsResult.error!;
        }
        return documentsResult.data!.pages.first.count;
      },
    );
  }

  ///
  /// Marks all documents in the inbox as seen.
  ///
  Mutation<BulkEditDocumentsResult, void> get clearInboxMutation {
    return Mutation(
      key: 'clear_inbox',
      mutationFn: (_) async {
        final allDocuments = await _documentsRepo
            .getAllQuery(filter: await buildInboxFilter())
            .fetch();
        final inboxTags = await inboxTagsQuery.fetch().then(
          (state) => state.data ?? <Tag>[],
        );
        final documentIds = allDocuments.data?.firstPage?.all ?? [];
        final request = BulkEditRequest(
          documents: documentIds,
          method: MethodEnum.modifyTags,
          parameters: {
            'remove_tags': inboxTags.map((e) => e.id).toList(),
            'add_tags': [],
          },
        );
        final result = await _documentsRepo.bulkEditDocumentsMutation().mutate(
          request,
        );
        return result.data!;
      },
      refetchQueries: ['inbox'],
      invalidateQueries: ['inbox_documents', 'inbox_count'],
    );
  }

  Mutation<List<int>, void> markAsSeenMutation(Document document) {
    return Mutation(
      key: 'inbox_mark_as_seen_${document.id}',
      mutationFn: (_) async {
        final inboxTagIds = await inboxTagsQuery
            .fetch()
            .then((state) => state.data ?? <Tag>[])
            .then((inboxTags) => inboxTags.map((e) => e.id).toList());

        final removeTags = inboxTagIds.toSet().intersection(
          document.tags.toSet(),
        );

        await _documentsRepo.bulkEditDocumentsMutation().mutate(
          BulkEditRequest(
            documents: [document.id],
            method: MethodEnum.modifyTags,
            parameters: {'remove_tags': removeTags.toList(), 'add_tags': []},
          ),
        );
        return removeTags.toList();
      },
      onSuccess: (res, arg) {
        final query = CachedQuery.instance
            .getQuery<InfiniteQuery<PaginatedDocumentList, int>>(
              'inbox_documents',
            );
        if (query?.state.data == null) {
          return;
        }
        query!.update((oldData) {
          return InfiniteQueryData<PaginatedDocumentList, int>(
            args: oldData!.args,
            pages: oldData.pages
                .map(
                  (page) => PaginatedDocumentList(
                    count: page.count - 1,
                    next: page.next,
                    previous: page.previous,
                    results: page.results
                        .where((doc) => doc.id != document.id)
                        .toList(),
                  ),
                )
                .toList(),
          );
        });
      },
      invalidateQueries: ['document/${document.id}'],
      refetchQueries: ['inbox_documents', 'inbox', 'inbox_count'],
    );
  }

  Mutation<void, List<int>> undoMarkAsSeenMutation(Document doc) {
    return Mutation<void, List<int>>(
      key: 'inbox_undo_mark_as_seen_${doc.id}',
      mutationFn: (removedTags) async {
        debugPrint(removedTags.join(','));
        if (removedTags.isEmpty) {
          logger.fw(
            'No tags to re-add for undo',
            className: runtimeType.toString(),
            methodName: 'undoMarkAsSeenMutation',
          );
          return;
        }
        await _documentsRepo
            .patchDocumentMutation(doc.id)
            .mutate(
              PatchedDocumentRequest(
                tags: PatchedValue(<int>{...doc.tags, ...removedTags}.toList()),
              ),
            );
      },
      refetchQueries: ['inbox_documents', 'inbox', 'inbox_count'],
    );
  }
}
