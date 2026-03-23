import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:paperless_mobile/api/paperless_api.dart';
import 'package:paperless_mobile/core/repository/change_notifier_mixin.dart';
import 'package:paperless_mobile/core/repository/document_repository.dart';
import 'package:paperless_mobile/core/repository/tag_repository.dart';
import 'package:paperless_mobile/features/logging/data/logger.dart';

class InboxData {
  final InfiniteQueryData<PaginatedResultList<Document>, int> documents;
  final List<Tag> inboxTags;

  List<Document> get flattened =>
      documents.pages.expand((page) => page.results).toList();
  InboxData({required this.documents, required this.inboxTags});
}

class InboxRepository {
  static const List<String> inboxQueryKeys = [
    'inbox_documents',
    'tags_inbox',
    'inbox',
    'inbox_count',
  ];

  final PaperlessDocumentsApi _documentsApi;
  final PaperlessTagsApi _tagsApi;
  final DocumentRepository _documentsRepo;
  final TagRepository _tagsRepo;

  InboxRepository(
    this._documentsApi,
    this._tagsApi,
    this._documentsRepo,
    this._tagsRepo,
  ) {
    _tagsRepo.addOnChangeListener(_onTagsChanged);
    _documentsRepo.addOnChangeListener(_onDocumentsChanged);
  }

  /// Call when this repository is no longer needed (e.g. on logout).
  void dispose() {
    _tagsRepo.removeOnChangeListener(_onTagsChanged);
    _documentsRepo.removeOnChangeListener(_onDocumentsChanged);
  }

  void _onTagsChanged(ChangeType _) {
    _invalidateAllInboxQueries();
  }

  void _onDocumentsChanged(ChangeType _) {
    _invalidateAllInboxQueries();
  }

  void _invalidateAllInboxQueries() {
    for (final key in inboxQueryKeys) {
      CachedQuery.instance.invalidateCache(key: key);
    }
  }

  Query<List<Tag>> get inboxTagsQuery {
    return Query<List<Tag>>(
      key: 'tags_inbox',
      queryFn: () async {
        final tags = await _tagsApi.getAll();
        return tags.where((tag) => tag.isInboxTag).toList();
      },
    );
  }

  Future<void> reload() async {
    await CachedQuery.instance.refetchQueries(
      keys: InboxRepository.inboxQueryKeys,
    );
  }

  InfiniteQuery<PaginatedResultList<Document>, int> get inboxDocumentsQuery {
    return InfiniteQuery(
      key: 'inbox',
      queryFn: (page) async {
        final inboxTags = await inboxTagsQuery.fetch();
        if (inboxTags.data?.isEmpty ?? true) {
          return PaginatedResultList(count: 0, results: []);
        }
        final filter = DocumentFilter(
          page: page,
          tags: AnyAssignedTagsQuery(
            tagIds: inboxTags.data!.map((e) => e.id).toList(),
          ),
        );
        return await _documentsApi.getAll(filter);
      },
      getNextArg: (state) {
        if (state == null) return 1;
        final currentCount = state.args.length * DocumentFilter().pageSize;
        final totalCount = state.lastPage?.count ?? 0;
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
        final result = await _documentsApi.getAll(filter);
        return result.count;
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
        final inboxTags = await inboxTagsQuery.fetch().then(
          (state) => state.data ?? <Tag>[],
        );
        if (inboxTags.isEmpty) {
          logger.fw(
            'No inbox tags found, skipping clear inbox mutation',
            className: runtimeType.toString(),
            methodName: 'clearInboxMutation',
          );
          return BulkEditDocumentsResult(result: '');
        }
        final allDocuments = await _documentsApi.getAll(
          DocumentFilter(
            fields: ['id', 'tags'],
            tags: AnyAssignedTagsQuery(
              tagIds: inboxTags.map((e) => e.id).toList(),
            ),
          ),
        );
        final documentIds = allDocuments.all ?? [];
        final request = BulkEditRequest(
          documents: documentIds,
          method: MethodEnum.modifyTags,
          parameters: {
            'remove_tags': inboxTags.map((e) => e.id).toList(),
            'add_tags': [],
          },
        );
        return await _documentsApi.bulkEditDocuments(request);
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

        await _documentsApi.bulkEditDocuments(
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
            .getQuery<InfiniteQuery<PaginatedResultList<Document>, int>>(
              'inbox_documents',
            );
        if (query?.state.data == null) {
          return;
        }
        query!.update((oldData) {
          return InfiniteQueryData<PaginatedResultList<Document>, int>(
            args: oldData!.args,
            pages: oldData.pages
                .map(
                  (page) => PaginatedResultList<Document>(
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
        await _documentsApi.patch(
          doc.id,
          PatchedDocumentRequest(
            tags: PatchedValue(<int>{...doc.tags, ...removedTags}.toList()),
          ),
        );
      },
      refetchQueries: ['inbox_documents', 'inbox', 'inbox_count'],
    );
  }
}
