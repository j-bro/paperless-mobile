import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:collection/collection.dart';
import 'package:defer_pointer/defer_pointer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart' show Option;
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/extensions/context_extensions.dart';
import 'package:paperless_mobile/core/extensions/document_extensions.dart';
import 'package:paperless_mobile/core/extensions/flutter_extensions.dart';
import 'package:paperless_mobile/core/store/bloc/current_user_app_state_builder.dart';
import 'package:paperless_mobile/features/app_drawer/view/app_drawer.dart';
import 'package:paperless_mobile/features/document_search/view/sliver_search_bar.dart';
import 'package:paperless_mobile/features/documents/view/widgets/adaptive_documents_view.dart';
import 'package:paperless_mobile/features/documents/view/widgets/documents_empty_state.dart';
import 'package:paperless_mobile/features/documents/view/widgets/saved_views/saved_view_changed_dialog.dart';
import 'package:paperless_mobile/features/documents/view/widgets/saved_views/saved_views_widget.dart';
import 'package:paperless_mobile/features/documents/view/widgets/search/document_filter_panel.dart';
import 'package:paperless_mobile/features/documents/view/widgets/selection/confirm_delete_saved_view_dialog.dart';
import 'package:paperless_mobile/features/documents/view/widgets/selection/document_selection_sliver_app_bar.dart';
import 'package:paperless_mobile/features/documents/view/widgets/selection/view_type_selection_widget.dart';
import 'package:paperless_mobile/features/documents/view/widgets/sort_documents_button.dart';
import 'package:paperless_mobile/features/logging/data/logger.dart';
import 'package:paperless_mobile/features/tasks/model/pending_tasks_notifier.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';
import 'package:paperless_mobile/helpers/message_helpers.dart';
import 'package:paperless_mobile/routing/routes/documents_route.dart';
import 'package:sliver_tools/sliver_tools.dart';

class DocumentFilterIntent {
  final DocumentFilter? filter;
  final bool shouldReset;

  DocumentFilterIntent({this.filter, this.shouldReset = false});
}

class DocumentsPage extends StatefulWidget {
  const DocumentsPage({super.key});

  @override
  State<DocumentsPage> createState() => _DocumentsPageState();
}

class _DocumentsPageState extends State<DocumentsPage> {
  final SliverOverlapAbsorberHandle searchBarHandle =
      SliverOverlapAbsorberHandle();

  final SliverOverlapAbsorberHandle savedViewsHandle =
      SliverOverlapAbsorberHandle();

  final _nestedScrollViewKey = GlobalKey<NestedScrollViewState>();

  final _savedViewsExpansionController = ExpansibleController();
  bool _showExtendedFab = true;
  final List<Document> _selection = [];

  @override
  void initState() {
    super.initState();
    context.read<PendingTasksNotifier>().addListener(_onTasksChanged);
    context.documentRepository
        .getAllQuery(filter: context.currentDocumentFilter)
        .refetch();
    context.refetchLabels();
    context.savedViewRepository.getAllQuery().refetch();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _nestedScrollViewKey.currentState!.innerController.addListener(
        _scrollExtentChangedListener,
      );
    });
  }

  void _onTasksChanged() {
    final notifier = context.read<PendingTasksNotifier>();
    final tasks = notifier.value;
    final finishedTasks = tasks.values.where(
      (element) => element.status == StatusEnum.SUCCESS,
    );
    if (finishedTasks.isNotEmpty) {
      showSnackBar(
        context,
        S.of(context)!.newDocumentAvailable,
        action: SnackBarActionConfig(
          label: S.of(context)!.reload,
          onPressed: () {
            // finishedTasks.forEach((task) {
            //   notifier.acknowledgeTasks([finishedTasks]);
            // });
            CachedQuery.instance.refetchQueries(
              keys: [
                context.documentRepository.queryKeyForFilter(
                  context.currentDocumentFilter,
                ),
              ],
            );
          },
        ),
        duration: const Duration(seconds: 10),
      );
    }
  }

  Future<void> _reloadData() async {
    final currentFilter =
        context.loggedInUserData.appState?.currentDocumentFilter;
    CachedQuery.instance.refetchQueries(
      keys: [
        context.savedViewRepository.queryKey,
        context.correspondentRepository.queryKey,
        context.tagRepository.queryKey,
        context.documentTypeRepository.queryKey,
        context.storagePathRepository.queryKey,
        context.customFieldRepository.queryKey,
        context.documentRepository.queryKeyForFilter(currentFilter),
      ],
    );
  }

  void _scrollExtentChangedListener() {
    const threshold = kToolbarHeight * 2;
    final offset =
        _nestedScrollViewKey.currentState!.innerController.position.pixels;
    if (offset < threshold && _showExtendedFab == false) {
      setState(() {
        _showExtendedFab = true;
      });
    } else if (offset >= threshold && _showExtendedFab == true) {
      setState(() {
        _showExtendedFab = false;
      });
    }
  }

  @override
  void dispose() {
    _nestedScrollViewKey.currentState?.innerController.removeListener(
      _scrollExtentChangedListener,
    );
    // context.read<PendingTasksNotifier>().removeListener(_onTasksChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Scaffold(
        drawer: const AppDrawer(),
        floatingActionButton: _selection.isNotEmpty
            ? CurrentUserAppStateBuilder(
                builder: (context, appState) {
                  return _buildFilterButton(
                    context,
                    appState.currentDocumentFilter.appliedFiltersCount > 0,
                  );
                },
              )
            : null,
        resizeToAvoidBottomInset: true,
        body: PopScope(
          onPopInvokedWithResult: (didPop, result) async {
            if (didPop) return;

            if (_selection.isNotEmpty) {
              setState(() {
                _selection.clear();
              });
              return;
            }
            if (context.currentDocumentFilter.appliedFiltersCount > 0 ||
                context.currentDocumentFilter.selectedView != null) {
              await _onResetFilter();
              return;
            }
            Navigator.of(context).pop();
          },
          child: NestedScrollView(
            key: _nestedScrollViewKey,
            floatHeaderSlivers: true,
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverOverlapAbsorber(
                handle: searchBarHandle,
                sliver: Builder(
                  builder: (context) {
                    if (_selection.isEmpty) {
                      return SliverSearchBar(
                        titleText: S.of(context)!.documents,
                      );
                    } else {
                      return DocumentSelectionSliverAppBar(
                        selection: _selection,
                        onResetSelection: () => setState(_selection.clear),
                      );
                    }
                  },
                ),
              ),
              SliverOverlapAbsorber(
                handle: savedViewsHandle,
                sliver: SliverPinnedHeader(
                  child: Material(elevation: 2, child: _buildViewActions()),
                ),
              ),
            ],
            body: _buildDocumentsTab(context),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterButton(BuildContext context, bool canResetFilter) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        DeferredPointerHandler(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              FloatingActionButton.extended(
                extendedPadding: _showExtendedFab
                    ? null
                    : const EdgeInsets.symmetric(horizontal: 16),
                heroTag: "fab_documents_page_filter",
                label: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 150),
                  transitionBuilder: (child, animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: SizeTransition(
                        sizeFactor: animation,
                        axis: Axis.horizontal,
                        child: child,
                      ),
                    );
                  },
                  child: _showExtendedFab
                      ? Row(
                          children: [
                            const Icon(Icons.filter_alt_outlined),
                            const SizedBox(width: 8),
                            Text(S.of(context)!.filterDocuments),
                          ],
                        )
                      : const Icon(Icons.filter_alt_outlined),
                ),
                onPressed: _openDocumentFilter,
              ),
              if (canResetFilter)
                Positioned(
                  top: -20,
                  right: -8,
                  child: DeferPointer(
                    paintOnTop: true,
                    child: Material(
                      color: Theme.of(context).colorScheme.error,
                      borderRadius: BorderRadius.circular(8),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: () {
                          HapticFeedback.mediumImpact();
                          _onResetFilter();
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (_showExtendedFab)
                              Text(
                                "Reset (${context.currentDocumentFilter$.appliedFiltersCount})", //TODO: INTL
                                style: Theme.of(context).textTheme.labelLarge
                                    ?.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onError,
                                    ),
                              ).padded()
                            else
                              Icon(
                                Icons.replay,
                                color: Theme.of(context).colorScheme.onError,
                              ).padded(4),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDocumentsTab(BuildContext context) {
    final currentFilter =
        context.loggedInUserData$.appState?.currentDocumentFilter;
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        // Listen for scroll notifications to load new data.
        // Scroll controller does not work here due to nestedscrollview limitations.
        final offset = notification.metrics.pixels;
        try {
          if (offset > 128 && _savedViewsExpansionController.isExpanded) {
            _savedViewsExpansionController.collapse();
          }
          // Workaround for https://github.com/astubenbord/paperless-mobile/issues/341 probably caused by https://github.com/flutter/flutter/issues/138153
        } on TypeError catch (error) {
          logger.fw(
            "An exception was thrown, but this message can probably be ignored. See issue #341 for more details.",
            error: error,
            className: runtimeType.toString(),
            methodName: "_buildDocumentsTab",
          );
        }

        final max = notification.metrics.maxScrollExtent;
        final query = context.documentRepository.getAllQuery(
          filter: context.currentDocumentFilter,
        );
        final isLastPageLoaded =
            query.state.data?.pages.fold(
              0,
              (value, element) => value + element.results.length,
            ) ==
            (query.state.data?.firstPage?.count ?? 0);

        if (max == 0 || query.state.isLoading || isLastPageLoaded) {
          return false;
        }

        if (offset >= max * 0.7) {
          query.getNextPage().onError<PaperlessApiException>((
            error,
            stackTrace,
          ) {
            if (context.mounted) showErrorMessage(context, error, stackTrace);
            return null;
          });
          return true;
        }
        return false;
      },
      child: RefreshIndicator(
        edgeOffset: kTextTabBarHeight + 2,
        onRefresh: _reloadData,
        child: CustomScrollView(
          key: const PageStorageKey<String>("documents"),
          slivers: <Widget>[
            SliverOverlapInjector(handle: searchBarHandle),
            SliverOverlapInjector(handle: savedViewsHandle),
            SliverToBoxAdapter(
              child: CurrentUserAppStateBuilder(
                builder: (context, appState) {
                  if (!context.loggedInUser$.paperlessUser.canViewSavedViews) {
                    return const SizedBox.shrink();
                  }
                  return SavedViewsWidget(
                    controller: _savedViewsExpansionController,
                    onViewSelected: (view) {
                      if (context.currentDocumentFilter.selectedView ==
                          view.id) {
                        _onResetFilter();
                      } else {
                        context.localStore.updateLoggedInUserAppState(
                          (appState) => appState.copyWith(
                            currentDocumentFilter: view.toDocumentFilter(),
                          ),
                        );
                      }
                    },
                    onUpdateView: (view) async {
                      await context.savedViewRepository
                          .patchMutation(view.id)
                          .mutate(
                            PatchedSavedViewRequest(
                              filterRules: Option.of(
                                currentFilter?.toFilterRules().toRequest(),
                              ),
                            ),
                          );
                      if (context.mounted) {
                        showSnackBar(
                          context,
                          S.of(context)!.savedViewSuccessfullyUpdated,
                        );
                      }
                    },
                    onDeleteView: (view) async {
                      HapticFeedback.mediumImpact();
                      final shouldRemove = await showDialog(
                        context: context,
                        builder: (context) =>
                            ConfirmDeleteSavedViewDialog(view: view),
                      );
                      if (shouldRemove && context.mounted) {
                        await context.savedViewRepository
                            .deleteMutation(view.id)
                            .mutate(null);
                        if (currentFilter?.selectedView != null &&
                            currentFilter!.selectedView == view.id) {
                          _onResetFilter();
                        }
                      }
                    },
                    filter: appState.currentDocumentFilter,
                  );
                },
              ),
            ),
            CurrentUserAppStateBuilder(
              builder: (context, appState) {
                return QueryBuilder(
                  query: context.documentRepository.getAllQuery(
                    filter: appState.currentDocumentFilter,
                  ),
                  builder: (context, state) {
                    if (state.data != null &&
                        (state.data?.firstPage?.count ?? 0) == 0) {
                      return SliverToBoxAdapter(
                        child: DocumentsEmptyState(
                          filter: context.currentDocumentFilter$,
                          onReset: _onResetFilter,
                        ),
                      );
                    }
                    final documents =
                        state.data?.pages.expand((p) => p.results).toList() ??
                        [];
                    final allowToggleFilter = _selection.isEmpty;
                    return CurrentUserAppStateBuilder(
                      builder: (context, appState) {
                        final viewType = appState.documentsPageViewType;
                        return SliverAdaptiveDocumentsView(
                          viewType: viewType,
                          onTap: (document) {
                            DocumentDetailsRoute(
                              documentId: document.id,
                              title: document.title,
                              thumbnailUrl: document.buildThumbnailUrl(context),
                            ).push(context);
                          },
                          onSelected: (document) {
                            setState(() {
                              _selection.add(document);
                            });
                          },
                          onTagSelected: allowToggleFilter
                              ? _toggleTagInFilter
                              : null,
                          onCorrespondentSelected: allowToggleFilter
                              ? _addCorrespondentToFilter
                              : null,
                          onDocumentTypeSelected: allowToggleFilter
                              ? _addDocumentTypeToFilter
                              : null,
                          onStoragePathSelected: allowToggleFilter
                              ? _addStoragePathToFilter
                              : null,
                          documents: documents,
                          hasLoaded: state.isSuccess,
                          isLabelClickable: true,
                          isLoading: switch (state) {
                            InfiniteQueryInitial() => true,
                            InfiniteQueryLoading(
                              :final isRefetching,
                              :final isLoading,
                            ) =>
                              isLoading && !isRefetching,
                            _ => false,
                          },
                          selectedDocumentIds: _selection.ids,
                        );
                      },
                    );
                  },
                );
              },
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 96)),
          ],
        ),
      ),
    );
  }

  Widget _buildViewActions() {
    return Container(
      padding: const EdgeInsets.all(4),
      color: Theme.of(context).colorScheme.surface,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SortDocumentsButton(enabled: _selection.isEmpty),
          CurrentUserAppStateBuilder(
            builder: (context, appState) {
              final viewType = appState.documentsPageViewType;
              return ViewTypeSelectionWidget(
                viewType: viewType,
                onChanged: (viewType) {
                  context.localStore.updateLoggedInUserAppState(
                    (appState) =>
                        appState.copyWith(documentsPageViewType: viewType),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  void _openDocumentFilter() async {
    final draggableSheetController = DraggableScrollableController();
    final filterIntent = await showModalBottomSheet<DocumentFilterIntent>(
      useSafeArea: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      isScrollControlled: true,
      builder: (_) => DraggableScrollableSheet(
        controller: draggableSheetController,
        expand: false,
        snap: true,
        snapSizes: const [0.9, 1],
        initialChildSize: .9,
        maxChildSize: 1,
        builder: (context, controller) => DocumentFilterPanel(
          initialFilter: context.currentDocumentFilter,
          scrollController: controller,
          draggableSheetController: draggableSheetController,
        ),
      ),
    );
    if (filterIntent != null) {
      try {
        if (filterIntent.shouldReset) {
          await _onResetFilter();
        } else {
          if (mounted) {
            context.localStore.updateLoggedInUserAppState(
              (appState) => appState.copyWith(
                currentDocumentFilter: filterIntent.filter!,
              ),
            );
          }
        }
      } on PaperlessApiException catch (error, stackTrace) {
        if (mounted) showErrorMessage(context, error, stackTrace);
      }
    }
  }

  void _toggleTagInFilter(int tagId) {
    var updatedFilter = context.currentDocumentFilter;
    try {
      switch (context.currentDocumentFilter.tags) {
        case IdsTagsQuery state:
          if (state.include.contains(tagId)) {
            updatedFilter = updatedFilter.copyWith(
              tags: state.copyWith(
                include: state.include.whereNot((e) => e == tagId).toList(),
              ),
            );
          } else if (state.exclude.contains(tagId)) {
            updatedFilter = updatedFilter.copyWith(
              tags: state.copyWith(
                include: state.exclude.whereNot((e) => e == tagId).toList(),
              ),
            );
          } else {
            updatedFilter = updatedFilter.copyWith(
              tags: state.copyWith(include: [...state.include, tagId]),
            );
          }
          break;
        default:
          updatedFilter = updatedFilter.copyWith(
            tags: IdsTagsQuery(include: [tagId]),
          );
          break;
      }
      context.localStore.updateCurrentDocumentFilter((_) => updatedFilter);
    } on PaperlessApiException catch (error, stackTrace) {
      showErrorMessage(context, error, stackTrace);
    }
  }

  void _addCorrespondentToFilter(int? correspondentId) {
    if (correspondentId == null) return;
    try {
      switch (context.currentDocumentFilter.correspondent) {
        case SetIdQueryParameter(id: var id):
          if (id == correspondentId) {
            context.localStore.updateCurrentDocumentFilter(
              (filter) =>
                  filter.copyWith(correspondent: const UnsetIdQueryParameter()),
            );
          } else {
            context.localStore.updateCurrentDocumentFilter(
              (filter) => filter.copyWith(
                correspondent: SetIdQueryParameter(id: correspondentId),
              ),
            );
          }
          break;
        default:
          context.localStore.updateCurrentDocumentFilter(
            (filter) => filter.copyWith(
              correspondent: SetIdQueryParameter(id: correspondentId),
            ),
          );
          break;
      }
    } on PaperlessApiException catch (error, stackTrace) {
      showErrorMessage(context, error, stackTrace);
    }
  }

  void _addDocumentTypeToFilter(int? documentTypeId) {
    if (documentTypeId == null) return;

    try {
      switch (context.currentDocumentFilter.documentType) {
        case SetIdQueryParameter(id: var id):
          if (id == documentTypeId) {
            context.localStore.updateCurrentDocumentFilter(
              (filter) =>
                  filter.copyWith(documentType: const UnsetIdQueryParameter()),
            );
          } else {
            context.localStore.updateCurrentDocumentFilter(
              (filter) => filter.copyWith(
                documentType: SetIdQueryParameter(id: documentTypeId),
              ),
            );
          }
          break;
        default:
          context.localStore.updateCurrentDocumentFilter(
            (filter) => filter.copyWith(
              documentType: SetIdQueryParameter(id: documentTypeId),
            ),
          );
          break;
      }
    } on PaperlessApiException catch (error, stackTrace) {
      showErrorMessage(context, error, stackTrace);
    }
  }

  void _addStoragePathToFilter(int? pathId) {
    if (pathId == null) return;

    try {
      switch (context.currentDocumentFilter.storagePath) {
        case SetIdQueryParameter(id: var id):
          if (id == pathId) {
            context.localStore.updateCurrentDocumentFilter(
              (filter) =>
                  filter.copyWith(storagePath: const UnsetIdQueryParameter()),
            );
          } else {
            context.localStore.updateCurrentDocumentFilter(
              (filter) =>
                  filter.copyWith(storagePath: SetIdQueryParameter(id: pathId)),
            );
          }
          break;
        default:
          context.localStore.updateCurrentDocumentFilter(
            (filter) =>
                filter.copyWith(storagePath: SetIdQueryParameter(id: pathId)),
          );
          break;
      }
    } on PaperlessApiException catch (error, stackTrace) {
      showErrorMessage(context, error, stackTrace);
    }
  }

  ///
  /// Resets the current filter and scrolls all the way to the top of the view.
  /// If a saved view is currently selected and the filter has changed,
  /// the user will be shown a dialog informing them about the changes.
  /// The user can then decide whether to abort the reset or to continue and discard the changes.
  Future<void> _onResetFilter() async {
    void toTop() async {
      await _nestedScrollViewKey.currentState?.outerController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }

    final activeView = context.savedViewRepository
        .getAllQuery()
        .state
        .data
        ?.firstWhere(
          (view) => view.id == context.currentDocumentFilter.selectedView,
        );

    void reset() {
      context.localStore.updateLoggedInUserAppState(
        (data) => data.copyWith(currentDocumentFilter: DocumentFilter()),
      );
    }

    final viewHasChanged =
        activeView != null &&
        activeView.toDocumentFilter() != context.currentDocumentFilter;
    if (viewHasChanged) {
      final discardChanges =
          await showDialog<bool>(
            context: context,
            builder: (context) => const SavedViewChangedDialog(),
          ) ??
          false;
      if (!discardChanges) {
        return;
      }
    }
    reset();
    toTop();
  }
}
