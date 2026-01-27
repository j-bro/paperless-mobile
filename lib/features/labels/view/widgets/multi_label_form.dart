import 'package:flutter/material.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/extensions/flutter_extensions.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';

enum SelectionType { include, exclude }

/// A fullscreen form for selecting multiple labels.
///
/// This form is used when multiple labels can be selected, such as in filters
/// where you may want to filter for multiple labels.
class MultiLabelForm<T extends Label> extends StatefulWidget {
  /// If null, this will resolve to [UnsetIdQueryParameter].
  final IdQueryParameter initialValue;
  final Map<int, T> options;
  final void Function({IdQueryParameter returnValue}) onSubmit;
  final Widget leadingIcon;
  final bool autofocus;
  final bool allowExclude;

  const MultiLabelForm({
    super.key,
    this.initialValue = const IdQueryParameter.unset(),
    required this.options,
    required this.onSubmit,
    required this.leadingIcon,
    this.autofocus = true,
    this.allowExclude = true,
  });

  @override
  State<MultiLabelForm<T>> createState() => _MultiLabelFormState<T>();
}

class _MultiLabelFormState<T extends Label> extends State<MultiLabelForm<T>> {
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
      IncludeIdsQueryParameter() => SelectionType.include,
      ExcludeIdsQueryParameter() => SelectionType.exclude,
      _ => SelectionType.include,
    };
    _selectedIds = switch (widget.initialValue) {
      IncludeIdsQueryParameter(ids: final ids) => [...ids],
      ExcludeIdsQueryParameter(ids: final ids) => [...ids],
      SingleIdQueryParameter(id: final id) => [id],
      NotAssignedIdQueryParameter() || AnyAssignedIdQueryParameter() => [-1],
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
    final theme = Theme.of(context);
    final filteredOptions = _filterOptionsByQuery(_textEditingController.text);

    return Scaffold(
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
            icon: widget.leadingIcon,
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
          IconButton(icon: Icon(Icons.done), onPressed: _onSubmitSelection),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(color: theme.colorScheme.outline),
        ),
      ),
      floatingActionButton: null,
      body: Builder(
        builder: (context) {
          return Column(
            children: [
              if (widget.allowExclude) _buildIncludeExcludeButtonGroup(),
              if (filteredOptions.where((id) => id != -1).isEmpty)
                Center(
                  child: Column(
                    children: [Text(S.of(context)!.noItemsFound).padded()],
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
                    return _buildOptionWidget(option, selected);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _onSubmitSelection() {
    if (_selectedIds.isEmpty) {
      widget.onSubmit(returnValue: const IdQueryParameter.unset());
      return;
    }

    if (_selectedIds.contains(-1)) {
      switch (_selectionType) {
        case SelectionType.include:
          widget.onSubmit(returnValue: const AnyAssignedIdQueryParameter());
          return;
        case SelectionType.exclude:
          widget.onSubmit(returnValue: const NotAssignedIdQueryParameter());
          return;
      }
    }

    widget.onSubmit(
      returnValue: switch (_selectionType) {
        SelectionType.include => IdQueryParameter.include(ids: _selectedIds),
        SelectionType.exclude => IdQueryParameter.exclude(ids: _selectedIds),
      },
    );
  }

  /// Filters the options passed to this widget by the current [query] and
  /// adds any-assigned/not-assigned option at the top
  Iterable<int> _filterOptionsByQuery(String query) sync* {
    final normalizedQuery = query.trim().toLowerCase();
    // Always show the any-assigned/not-assigned option
    yield -1;

    yield* widget.options.entries
        .where(
          (entry) => entry.value.name.toLowerCase().contains(normalizedQuery),
        )
        .map((e) => e.key);
  }

  String? _buildHintText() {
    return switch (widget.initialValue) {
      UnsetIdQueryParameter() => S.of(context)!.startTyping,
      NotAssignedIdQueryParameter() => S.of(context)!.notAssigned,
      AnyAssignedIdQueryParameter() => S.of(context)!.anyAssigned,
      IncludeIdsQueryParameter(ids: final ids) ||
      ExcludeIdsQueryParameter(
        ids: final ids,
      ) => widget.options[ids.first]?.name ?? S.of(context)!.startTyping,
      SingleIdQueryParameter(id: final id) =>
        widget.options[id]?.name ?? S.of(context)!.startTyping,
    };
  }

  Widget _buildOptionWidget(int option, bool selected) {
    return ListTile(
      selected: selected,
      selectedTileColor: Theme.of(context).focusColor,
      title: option == -1
          ? Text(switch (_selectionType) {
              SelectionType.include => S.of(context)!.anyAssigned,
              SelectionType.exclude => S.of(context)!.notAssigned,
            })
          : Text(widget.options[option]?.name ?? '?'),
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
