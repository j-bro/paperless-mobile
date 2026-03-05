import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:flutter/material.dart';
import 'package:paperless_mobile/api/paperless_api.dart';
import 'package:paperless_mobile/core/extensions/flutter_extensions.dart';
import 'package:paperless_mobile/core/extensions/label_list_extension.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';

/// A fullscreen form for selecting a single label.
///
/// This form is used when only one label can be selected, such as when
/// assigning a label to a document.
class SingleLabelForm<T extends Label> extends StatefulWidget {
  /// The initially selected label ID, or null if none selected.
  final int? initialValue;
  final Query<List<T>> query;
  final Future<T?> Function(String? initialName)? onCreateNewLabel;
  final void Function({int? returnValue}) onSubmit;
  final Widget leadingIcon;
  final String? addNewLabelText;
  final bool autofocus;

  const SingleLabelForm({
    super.key,
    this.initialValue,
    required this.query,
    this.onCreateNewLabel,
    required this.onSubmit,
    required this.leadingIcon,
    this.addNewLabelText,
    this.autofocus = true,
  }) : assert((addNewLabelText != null) == (onCreateNewLabel != null));

  @override
  State<SingleLabelForm<T>> createState() => _SingleLabelFormState<T>();
}

class _SingleLabelFormState<T extends Label> extends State<SingleLabelForm<T>> {
  bool _showClearIcon = false;
  final _textEditingController = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _textEditingController.addListener(() {
      setState(() => _showClearIcon = _textEditingController.text.isNotEmpty);
    });
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
      query: widget.query,
      builder: (context, state) {
        final options = state.data?.toIdMap() ?? {};
        final filteredOptions = _filterOptionsByQuery(
          _textEditingController.text,
          options,
        );

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
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1),
              child: Divider(color: theme.colorScheme.outline),
            ),
          ),
          floatingActionButton: showFab && widget.onCreateNewLabel != null
              ? FloatingActionButton(
                  heroTag: "fab_single_label_form",
                  onPressed: _onCreateNewLabel,
                  child: const Icon(Icons.add),
                )
              : null,
          body: Builder(
            builder: (context) {
              return Column(
                children: [
                  if (filteredOptions.isEmpty)
                    Center(
                      child: Column(
                        children: [
                          Text(S.of(context)!.noItemsFound).padded(),
                          if (widget.onCreateNewLabel != null)
                            TextButton(
                              onPressed: _onCreateNewLabel,
                              child: Text(widget.addNewLabelText!),
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
                        final selected = _isOptionSelected(option);
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

  bool _isOptionSelected(int option) {
    return widget.initialValue == option;
  }

  void _onCreateNewLabel() async {
    final label = await widget.onCreateNewLabel!(_textEditingController.text);
    if (!mounted) return;
    if (label?.id != null) {
      // Use postFrameCallback to ensure close happens after any widget rebuilds
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          widget.onSubmit(returnValue: label!.id);
        }
      });
    }
  }

  /// Filters the options passed to this widget by the current [query].
  Iterable<int> _filterOptionsByQuery(String query, Map<int, T> options) sync* {
    final normalizedQuery = query.trim().toLowerCase();

    yield* options.entries
        .where(
          (entry) => entry.value.name.toLowerCase().contains(normalizedQuery),
        )
        .map((e) => e.key);
  }

  String? _buildHintText() {
    // Note: hint text is static based on initial value, no need for live options
    return S.of(context)!.startTyping;
  }

  Widget _buildOptionWidget(int option, bool selected, Map<int, T> options) {
    return ListTile(
      selected: selected,
      selectedTileColor: Theme.of(context).focusColor,
      title: Text(options[option]?.name ?? '?'),
      onTap: () {
        widget.onSubmit(returnValue: option);
      },
    );
  }
}
