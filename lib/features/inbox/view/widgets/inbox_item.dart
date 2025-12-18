import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart' show Option;
import 'package:intl/intl.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/extensions/context_extensions.dart';
import 'package:paperless_mobile/core/extensions/dart_extensions.dart';
import 'package:paperless_mobile/core/extensions/document_extensions.dart';
import 'package:paperless_mobile/core/extensions/flutter_extensions.dart';
import 'package:paperless_mobile/core/extensions/label_list_extension.dart';
import 'package:paperless_mobile/core/repository/document_repository.dart';
import 'package:paperless_mobile/core/widgets/icon_loading_widget.dart';
import 'package:paperless_mobile/core/widgets/shimmer_placeholder.dart';
import 'package:paperless_mobile/core/workarounds/colored_chip.dart';
import 'package:paperless_mobile/features/documents/view/widgets/delete_document_confirmation_dialog.dart';
import 'package:paperless_mobile/features/documents/view/widgets/document_preview.dart';
import 'package:paperless_mobile/features/documents/view/widgets/placeholder/tags_placeholder.dart';
import 'package:paperless_mobile/features/documents/view/widgets/placeholder/text_placeholder.dart';
import 'package:paperless_mobile/features/labels/tags/view/widgets/tags_widget.dart';
import 'package:paperless_mobile/features/labels/view/widgets/label_text.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';
import 'package:paperless_mobile/helpers/connectivity_aware_action_wrapper.dart';
import 'package:paperless_mobile/helpers/message_helpers.dart';
import 'package:paperless_mobile/routing/routes/documents_route.dart';

class InboxItemPlaceholder extends StatelessWidget {
  const InboxItemPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerPlaceholder(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TextPlaceholder(length: 150, fontSize: 12),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 150,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 120,
                        width: 90,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: const ColoredBox(color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Spacer(),
                            TextPlaceholder(length: 200, fontSize: 14),
                            Spacer(),
                            TextPlaceholder(length: 120, fontSize: 14),
                            SizedBox(height: 8),
                            TextPlaceholder(length: 170, fontSize: 14),
                            Spacer(),
                            TagsPlaceholder(count: 3, dense: true),
                            Spacer(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 50,
                  child: IntrinsicHeight(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const NeverScrollableScrollPhysics(),
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 50,
                            height: 40,
                            child: ColoredBox(color: Colors.white),
                          ).padded(),
                          const VerticalDivider(indent: 12, endIndent: 12),
                          SizedBox(
                            height: 40,
                            child: Row(
                              children: [
                                Container(
                                  width: 150,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Container(
                                  width: 200,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class InboxItem extends StatefulWidget {
  static const a4AspectRatio = 1 / 1.4142;
  final Document document;
  const InboxItem({super.key, required this.document});

  @override
  State<InboxItem> createState() => _InboxItemState();
}

class _InboxItemState extends State<InboxItem> {
  //TODO: This may be removed if a skip-like option is added to QueryBuilder
  /// Suggestions are initially disabled to avoid unnecessary API calls
  /// and enabled (and therefore also subscribed to changes) when the user requests suggestions.
  late bool _suggestionsEnabled = false;

  @override
  Widget build(BuildContext context) {
    return ChipTheme(
      data: Theme.of(context).chipTheme.copyWith(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
      ),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          DocumentDetailsRoute(
            title: widget.document.title,
            documentId: widget.document.id,
            thumbnailUrl: widget.document.buildThumbnailUrl(context),
            isLabelClickable: false,
          ).push(context);
        },
        child: SizedBox(
          height: 200,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: Row(
                  children: [
                    AspectRatio(
                      aspectRatio: InboxItem.a4AspectRatio,
                      child: DocumentPreview(
                        documentId: widget.document.id,
                        title: widget.document.title,
                        fit: BoxFit.cover,
                        alignment: Alignment.topCenter,
                        enableHero: false,
                      ),
                    ).padded(),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.document.title ?? '-',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: Theme.of(context).textTheme.titleSmall,
                          ).paddedOnly(left: 8, right: 8, top: 8),
                          const Spacer(),
                          _buildTextWithLeadingIcon(
                            Icon(
                              Icons.person_outline,
                              size: Theme.of(
                                context,
                              ).textTheme.bodyMedium?.fontSize,
                            ),
                            QueryBuilder(
                              query: context.correspondentRepository
                                  .getAllQuery(),
                              builder: (context, state) {
                                return LabelText(
                                  label:
                                      state.data?.toIdMap()[widget
                                          .document
                                          .correspondent],
                                  style: Theme.of(context).textTheme.bodyMedium,
                                  placeholder: " - ",
                                );
                              },
                            ),
                          ).paddedSymmetrically(horizontal: 8),
                          _buildTextWithLeadingIcon(
                            Icon(
                              Icons.description_outlined,
                              size: Theme.of(
                                context,
                              ).textTheme.bodyMedium?.fontSize,
                            ),
                            QueryBuilder(
                              query: context.documentTypeRepository
                                  .getAllQuery(),
                              builder: (context, state) {
                                return LabelText<DocumentType>(
                                  label: state.data
                                      ?.toIdMap()[widget.document.documentType],
                                  style: Theme.of(context).textTheme.bodyMedium,
                                  placeholder: " - ",
                                );
                              },
                            ),
                          ).paddedSymmetrically(horizontal: 8),
                          const Spacer(),
                          TagsWidget(
                            tagIds: widget.document.tags,
                            isClickable: false,
                            showShortNames: true,
                          ).paddedOnly(left: 8, bottom: 8),
                          const Spacer(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              LimitedBox(
                maxHeight: 56,
                child: ConnectivityAwareActionWrapper(
                  child: _buildActions(context),
                ),
              ),
            ],
          ).paddedOnly(left: 8, top: 8, bottom: 8),
        ),
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    final currentUser = context.loggedInUser$.paperlessUser;
    final canEdit = currentUser.canEditDocuments;
    final canDelete = currentUser.canDeleteDocuments;
    final actions = [
      if (canEdit) _buildAssignAsnAction(context),
      if (canEdit && canDelete) const SizedBox(width: 8.0),
      if (canDelete)
        ColoredChipWrapper(
          child: ActionChip(
            avatar: const Icon(Icons.delete_outline),
            label: Text(S.of(context)!.deleteDocument),
            onPressed: () async {
              final shouldDelete =
                  await showDialog<bool>(
                    context: context,
                    builder: (context) => DeleteDocumentConfirmationDialog(
                      document: widget.document,
                    ),
                  ) ??
                  false;
              if (shouldDelete && context.mounted) {
                await context.documentRepository
                    .deleteDocumentMutation(widget.document.id)
                    .mutate();
              }
            },
          ),
        ),
    ].map((a) => SliverToBoxAdapter(child: a)).toList();

    if (actions.isEmpty) {
      return SliverToBoxAdapter(child: const SizedBox.shrink());
    }

    return CustomScrollView(
      scrollDirection: Axis.horizontal,
      slivers: [
        SliverToBoxAdapter(
          child: QueryConsumer(
            listenWhen: (oldState, newState) =>
                newState.timeCreated != oldState.timeCreated &&
                newState.isSuccess,
            listener: (state) {
              if (state.data != null &&
                  !(state.data?.hasSuggestions ?? false)) {
                showSnackBar(
                  context,
                  S.of(context)!.noSuggestionsForThisDocument,
                );
              }
            },
            query: context.documentRepository.getFieldSuggestionsQuery(
              widget.document.id,
            ),
            enabled: _suggestionsEnabled,
            builder: (context, state) {
              if (state.data != null) {
                return ActionChip(
                  avatar: state.isLoading
                      ? IconLoadingWidget()
                      : const Icon(Icons.refresh),
                  label: Text('Reload suggestions'),
                  onPressed: () {
                    setState(() {
                      _suggestionsEnabled = true;
                    });
                    context.documentRepository
                        .getFieldSuggestionsQuery(widget.document.id)
                        .refetch();
                  },
                );
              }
              return ActionChip(
                avatar: state.isLoading
                    ? IconLoadingWidget()
                    : const Icon(Icons.auto_awesome),
                onPressed: () {
                  setState(() {
                    _suggestionsEnabled = true;
                  });
                  context.documentRepository
                      .getFieldSuggestionsQuery(widget.document.id)
                      .fetch();
                },
                label: Text(S.of(context)!.loadInboxItemSuggestions),
              );
            },
          ),
        ),
        _buildSuggestionChips(context),
        SliverToBoxAdapter(child: const SizedBox(width: 4.0)),
        ...actions,
      ],
    );
  }

  Widget _buildAssignAsnAction(BuildContext context) {
    final hasAsn = widget.document.archiveSerialNumber != null;
    if (hasAsn) {
      return SizedBox.shrink();
    }
    return MutationBuilder(
      mutation: context.documentRepository.assignAsnMutation(
        widget.document.id,
      ),
      builder: (context, state, mutate) {
        return ActionChip(
          avatar: Builder(
            builder: (context) {
              if (state.isLoading) {
                return const IconLoadingWidget();
              }
              return SizedBox.shrink();
            },
          ),
          label: hasAsn
              ? Text(
                  '${S.of(context)!.asn} #${widget.document.archiveSerialNumber}',
                )
              : Text(S.of(context)!.assignAsn),
          onPressed: !hasAsn
              ? () => mutate(AssignAsnRequest(auto: true))
              : null,
        );
      },
    );
  }

  Row _buildTextWithLeadingIcon(Icon icon, Widget child) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        icon,
        const SizedBox(width: 2),
        Flexible(child: child),
      ],
    );
  }

  Widget _buildSuggestionChips(BuildContext context) {
    return QueryBuilder(
      query: context.documentRepository.getFieldSuggestionsQuery(
        widget.document.id,
      ),
      enabled: _suggestionsEnabled,
      builder: (context, state) {
        if (state.isInitial || state.isLoading && state.data == null) {
          return SliverToBoxAdapter(child: Center(child: SizedBox.shrink()));
        }
        if (state.isError) {
          return SliverToBoxAdapter(
            child: Center(child: Text(S.of(context)!.couldNotLoadSuggestions)),
          );
        }
        final suggestions = state.data!;
        return SliverList.list(
          children:
              [
                    ...suggestions.correspondents
                        .whereNot((e) => widget.document.correspondent == e)
                        .map(
                          (e) => QueryBuilder(
                            query: context.correspondentRepository
                                .getAllQuery(),
                            builder: (context, state) {
                              final correspondents = state.data?.toIdMap();
                              return SliverToBoxAdapter(
                                child: ActionChip(
                                  avatar: const Icon(Icons.person_outline),
                                  label: Text(correspondents?[e]?.name ?? ''),
                                  onPressed: () async {
                                    await context.documentRepository
                                        .patchDocumentMutation(
                                          widget.document.id,
                                        )
                                        .mutate(
                                          PatchedDocumentRequest(
                                            correspondent: Option.of(e),
                                          ),
                                        );
                                    if (context.mounted) {
                                      showSnackBar(
                                        context,
                                        S
                                            .of(context)!
                                            .suggestionSuccessfullyApplied,
                                      );
                                    }
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                    ...suggestions.documentTypes
                        .whereNot((e) => widget.document.documentType == e)
                        .map(
                          (e) => QueryBuilder(
                            query: context.documentTypeRepository.getAllQuery(),
                            builder: (context, state) {
                              final documentTypes = state.data?.toIdMap();
                              return SliverToBoxAdapter(
                                child: ActionChip(
                                  avatar: const Icon(
                                    Icons.description_outlined,
                                  ),
                                  label: Text(documentTypes?[e]?.name ?? ''),
                                  onPressed: () async {
                                    await context.documentRepository
                                        .patchDocumentMutation(
                                          widget.document.id,
                                        )
                                        .mutate(
                                          PatchedDocumentRequest(
                                            documentType: Option.of(e),
                                          ),
                                        );
                                    if (context.mounted) {
                                      showSnackBar(
                                        context,
                                        S
                                            .of(context)!
                                            .suggestionSuccessfullyApplied,
                                      );
                                    }
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                    ...suggestions.tags
                        .whereNot((e) => widget.document.tags.contains(e))
                        .map(
                          (e) => QueryBuilder(
                            query: context.tagRepository.getAllQuery(),
                            builder: (context, state) {
                              final tags = state.data?.toIdMap();
                              return ActionChip(
                                avatar: const Icon(Icons.label_outline),
                                label: Text(tags?[e]?.name ?? ''),
                                onPressed: () async {
                                  await context.documentRepository
                                      .patchDocumentMutation(widget.document.id)
                                      .mutate(
                                        PatchedDocumentRequest(
                                          tags: Option.of(
                                            {
                                              ...widget.document.tags,
                                              e,
                                            }.toList(),
                                          ),
                                        ),
                                      );
                                  if (context.mounted) {
                                    showSnackBar(
                                      context,
                                      S
                                          .of(context)!
                                          .suggestionSuccessfullyApplied,
                                    );
                                  }
                                },
                              );
                            },
                          ),
                        ),

                    ...suggestions.storagePaths
                        .whereNot((e) => widget.document.storagePath == e)
                        .map(
                          (e) => QueryBuilder(
                            query: context.storagePathRepository.getAllQuery(),
                            builder: (context, state) {
                              final storagePaths = state.data?.toIdMap();
                              return SliverToBoxAdapter(
                                child: ActionChip(
                                  avatar: const Icon(Icons.label_outline),
                                  label: Text(storagePaths?[e]?.name ?? ''),
                                  onPressed: () async {
                                    await context.documentRepository
                                        .patchDocumentMutation(
                                          widget.document.id,
                                        )
                                        .mutate(
                                          PatchedDocumentRequest(
                                            storagePath: Option.of(e),
                                          ),
                                        );
                                    if (context.mounted) {
                                      showSnackBar(
                                        context,
                                        S
                                            .of(context)!
                                            .suggestionSuccessfullyApplied,
                                      );
                                    }
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                    ...suggestions.dates
                        .map(DateTime.parse)
                        .whereNot(
                          (e) =>
                              widget.document.created?.isOnSameDayAs(e) ??
                              false,
                        )
                        .map(
                          (e) => SliverToBoxAdapter(
                            child: ActionChip(
                              avatar: const Icon(Icons.calendar_today_outlined),
                              label: Text(
                                "${S.of(context)!.createdAt}: ${DateFormat.yMd().format(e)}",
                              ),
                              onPressed: () async {
                                await context.documentRepository
                                    .patchDocumentMutation(widget.document.id)
                                    .mutate(
                                      PatchedDocumentRequest(
                                        created: Option.of(e),
                                      ),
                                    );
                                if (context.mounted) {
                                  showSnackBar(
                                    context,
                                    S
                                        .of(context)!
                                        .suggestionSuccessfullyApplied,
                                  );
                                }
                              },
                            ),
                          ),
                        ),
                  ]
                  .expand(
                    (element) => [
                      element,
                      SliverToBoxAdapter(child: const SizedBox(width: 4)),
                    ],
                  )
                  .toList(),
        );
      },
    );
  }
}
