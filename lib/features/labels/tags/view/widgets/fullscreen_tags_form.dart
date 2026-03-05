import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:flutter/material.dart';
import 'package:paperless_mobile/api/paperless_api.dart';
import 'package:paperless_mobile/core/extensions/context_extensions.dart';
import 'package:paperless_mobile/core/extensions/flutter_extensions.dart';
import 'package:paperless_mobile/core/extensions/label_list_extension.dart';
import 'package:paperless_mobile/features/labels/view/widgets/multi_label_form.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';
import 'package:paperless_mobile/routing/routes/labels_route.dart';

/// A fullscreen form for selecting multiple tags.
///
/// This form follows the same mechanics as [MultiLabelForm], using a single
/// [SelectionType] and a list of selected IDs. The -1 sentinel represents
/// the "any assigned" / "not assigned" special option.
class FullscreenTagsForm extends StatefulWidget {
  final TagsQuery? initialValue;
  final void Function({TagsQuery? returnValue}) onSubmit;
  final bool allowCreation;
  final bool allowExclude;
  final bool autofocus;

  const FullscreenTagsForm({
    super.key,
    this.initialValue,
    required this.onSubmit,
    required this.allowCreation,
    required this.allowExclude,
    this.autofocus = true,
  });

  @override
  State<FullscreenTagsForm> createState() => _FullscreenTagsFormState();
}

class _FullscreenTagsFormState extends State<FullscreenTagsForm> {
  bool _showClearIcon = false;
  final _textEditingController = TextEditingController();
  final _focusNode = FocusNode();
  late SelectionType _selectionType;
  late List<int> _selectedIds;

  @override
  void initState() {
    super.initState();
    _textEditingController.addListener(() {
      setState(() => _showClearIcon = _textEditingController.text.isNotEmpty);
    });
    _selectionType = switch (widget.initialValue) {
      IdsTagsQuery(include: final inc, exclude: final exc)
          when inc.isEmpty && exc.isNotEmpty =>
        SelectionType.exclude,
      NotAssignedTagsQuery() => SelectionType.exclude,
      _ => SelectionType.include,
    };
    _selectedIds = switch (widget.initialValue) {
      IdsTagsQuery(include: final inc, exclude: final exc) =>
        inc.isNotEmpty ? [...inc] : [...exc],
      AnyAssignedTagsQuery() || NotAssignedTagsQuery() => [-1],
      _ => [],
    };
    if (widget.autofocus) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        // Delay keyboard popup to ensure open animation is finished before.
        Future.delayed(
          const Duration(milliseconds: 200),
          () => _focusNode.requestFocus(),
        );
      });
    }
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final showFab = MediaQuery.viewInsetsOf(context).bottom == 0;
    final theme = Theme.of(context);

    return QueryBuilder(
      query: context.tagRepository.getAllQuery(),
      builder: (context, state) {
        final options = state.data?.toIdMap() ?? {};
        final filteredOptions = _filterOptionsByQuery(
          _textEditingController.text,
          options,
        );

        return Scaffold(
          floatingActionButton: widget.allowCreation && showFab
              ? FloatingActionButton(
                  heroTag: "fab_tags_form",
                  onPressed: _onAddTag,
                  child: const Icon(Icons.add),
                )
              : null,
          appBar: AppBar(
            backgroundColor: theme.colorScheme.surface,
            toolbarHeight: 72,
            leading: BackButton(color: theme.colorScheme.onSurface),
            title: TextFormField(
              focusNode: _focusNode,
              controller: _textEditingController,
              autofocus: true,
              style: theme.textTheme.bodyLarge?.apply(
                color: theme.colorScheme.onSurface,
              ),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.zero,
                hintStyle: theme.textTheme.bodyLarge?.apply(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                icon: const Icon(Icons.label_outline),
                hintText: _buildHintText(),
                border: InputBorder.none,
              ),
              textInputAction: TextInputAction.done,
            ),
            actions: [
              if (_showClearIcon)
                IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _textEditingController.clear();
                  },
                ),
              IconButton(
                icon: const Icon(Icons.done),
                onPressed: _onSubmitSelection,
              ),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1),
              child: Divider(color: theme.colorScheme.outline),
            ),
          ),
          body: Builder(
            builder: (context) {
              return Column(
                children: [
                  if (widget.allowExclude) _buildIncludeExcludeButtonGroup(),
                  if (filteredOptions.where((id) => id != -1).isEmpty)
                    Center(
                      child: Column(
                        children: [
                          Text(S.of(context)!.noItemsFound).padded(),
                          if (widget.allowCreation)
                            TextButton(
                              onPressed: _onAddTag,
                              child: Text(S.of(context)!.addTag),
                            ),
                        ],
                      ),
                    ),
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: filteredOptions.length,
                      itemBuilder: (BuildContext context, int index) {
                        final option = filteredOptions.elementAt(index);
                        final selected = _selectedIds.contains(option);
                        return _buildOptionWidget(option, selected, options);
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  void _onAddTag() async {
    final createdTag = await CreateLabelRoute(
      LabelType.tag,
      name: _textEditingController.text,
    ).push<Tag>(context);
    _textEditingController.clear();
    if (createdTag != null) {
      setState(() {
        _selectedIds.remove(-1);
        _selectedIds.add(createdTag.id);
      });
    }
  }

  void _onSubmitSelection() {
    if (_selectedIds.isEmpty) {
      widget.onSubmit(returnValue: null);
      return;
    }

    if (_selectedIds.contains(-1)) {
      switch (_selectionType) {
        case SelectionType.include:
          widget.onSubmit(returnValue: const AnyAssignedTagsQuery());
          return;
        case SelectionType.exclude:
          widget.onSubmit(returnValue: const NotAssignedTagsQuery());
          return;
      }
    }

    widget.onSubmit(
      returnValue: switch (_selectionType) {
        SelectionType.include => IdsTagsQuery(include: _selectedIds),
        SelectionType.exclude => IdsTagsQuery(exclude: _selectedIds),
      },
    );
  }

  /// Filters the options passed to this widget by the current [query] and
  /// adds any-assigned/not-assigned option at the top when exclude is allowed.
  Iterable<int> _filterOptionsByQuery(
    String query,
    Map<int, Tag> options,
  ) sync* {
    final normalizedQuery = query.trim().toLowerCase();
    // Show the any-assigned/not-assigned option only in filter mode
    if (widget.allowExclude) {
      yield -1;
    }

    yield* options.entries
        .where(
          (entry) => entry.value.name.toLowerCase().contains(normalizedQuery),
        )
        .map((e) => e.key);
  }

  String? _buildHintText() {
    return switch (widget.initialValue) {
      NotAssignedTagsQuery() => S.of(context)!.notAssigned,
      AnyAssignedTagsQuery() => S.of(context)!.anyAssigned,
      _ => S.of(context)!.startTyping,
    };
  }

  Widget _buildOptionWidget(int option, bool selected, Map<int, Tag> options) {
    if (option == -1) {
      return ListTile(
        selected: selected,
        selectedTileColor: Theme.of(context).focusColor,
        title: Text(switch (_selectionType) {
          SelectionType.include => S.of(context)!.anyAssigned,
          SelectionType.exclude => S.of(context)!.notAssigned,
        }),
        onTap: () => _onOptionTap(option),
      );
    }

    final tag = options[option];
    if (tag == null) return const SizedBox.shrink();

    return SelectableTagWidget(
      tag: tag,
      selected: selected,
      onTap: () => _onOptionTap(option),
    );
  }

  void _onOptionTap(int option) {
    if (option == -1) {
      if (_selectedIds.contains(option)) {
        setState(() {
          _selectedIds.clear();
        });
      } else {
        setState(() {
          _selectedIds = [option];
        });
      }
    } else {
      _selectedIds.remove(-1);
      if (_selectedIds.contains(option)) {
        setState(() {
          _selectedIds.remove(option);
        });
      } else {
        setState(() {
          _selectedIds.add(option);
        });
      }
    }
  }

  Widget _buildIncludeExcludeButtonGroup() {
    return Flexible(
      child: SegmentedButton<SelectionType>(
        showSelectedIcon: false,
        multiSelectionEnabled: false,
        selected: {_selectionType},
        onSelectionChanged: (newSelection) {
          setState(() {
            _selectionType = newSelection.first;
          });
        },
        segments: [
          ButtonSegment(
            value: SelectionType.include,
            label: Text(S.of(context)!.include),
          ),
          ButtonSegment(
            value: SelectionType.exclude,
            label: Text(S.of(context)!.exclude),
          ),
        ],
      ),
    );
  }
}

class SelectableTagWidget extends StatelessWidget {
  final Tag tag;
  final bool selected;
  final VoidCallback onTap;

  const SelectableTagWidget({
    super.key,
    required this.tag,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(tag.name),
      trailing: Text(S.of(context)!.documentsAssigned(tag.documentCount ?? 0)),
      leading: CircleAvatar(
        backgroundColor: tag.color,
        child: tag.isInboxTag ? Icon(Icons.inbox, color: tag.textColor) : null,
      ),
      onTap: onTap,
      selected: selected,
      selectedTileColor: Theme.of(context).focusColor,
    );
  }
}
