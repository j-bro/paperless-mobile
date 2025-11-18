import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:paperless_api/generated/lib/src/model/bulk_edit_request.dart';
import 'package:paperless_api/generated/lib/src/model/document.dart';
import 'package:paperless_api/generated/lib/src/model/method_enum.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/extensions/dart_extensions.dart';
import 'package:paperless_mobile/core/extensions/document_extensions.dart';
import 'package:paperless_mobile/core/extensions/label_list_extension.dart';
import 'package:paperless_mobile/core/repository/document_repository.dart';
import 'package:paperless_mobile/core/repository/tag_repository.dart';
import 'package:paperless_mobile/core/widgets/form_fields/fullscreen_selection_form.dart';
import 'package:paperless_mobile/features/document_bulk_action/view/widgets/confirm_bulk_modify_tags_dialog.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';

class FullscreenBulkEditTagsWidget extends StatefulWidget {
  final List<Document> selection;

  const FullscreenBulkEditTagsWidget({super.key, required this.selection});

  @override
  State<FullscreenBulkEditTagsWidget> createState() =>
      _FullscreenBulkEditTagsWidgetState();
}

class _FullscreenBulkEditTagsWidgetState
    extends State<FullscreenBulkEditTagsWidget> {
  final TextEditingController _controller = TextEditingController();

  /// Tags shared by all documents
  late final List<int> _sharedTags;

  /// Tags not assigned to at least one document in the selection
  late final List<int> _nonSharedTags;

  final List<int> _addTags = [];
  final List<int> _removeTags = [];
  late List<int> _filteredTags;

  @override
  void initState() {
    super.initState();
    final tags = context.read<TagRepository>().getAllQuery().state.data ?? [];
    _sharedTags = widget.selection
        .map((e) => e.tags.toSet())
        .fold(
          tags.map((e) => e.id).toSet(),
          (previousValue, element) => previousValue.intersection(element),
        )
        .toList();
    _nonSharedTags = widget.selection
        .map((e) => e.tags)
        .flattened
        .toSet()
        .difference(_sharedTags.toSet())
        .toList();
    _filteredTags = tags.map((e) => e.id).toList();
    _controller.addListener(() {
      setState(() {
        _filteredTags = tags
            .where(
              (e) =>
                  e.name.normalized().contains(_controller.text.normalized()),
            )
            .map((e) => e.id)
            .toList();
      });
    });
  }

  List<int> get _assignedTags => [..._sharedTags, ..._nonSharedTags];

  @override
  Widget build(BuildContext context) {
    return QueryBuilder(
      query: context.read<TagRepository>().getAllQuery(),
      builder: (context, tagQueryState) {
        return FullscreenSelectionForm(
          controller: _controller,
          floatingActionButton: _addTags.isNotEmpty || _removeTags.isNotEmpty
              ? FloatingActionButton.extended(
                  heroTag: "fab_fullscreen_bulk_edit_tags",
                  label: Text(S.of(context)!.apply),
                  icon: const Icon(Icons.done),
                  onPressed: _submit,
                )
              : null,
          hintText: S.of(context)!.startTyping,
          leadingIcon: const Icon(Icons.label_outline),
          selectionBuilder: (context, index) {
            return _buildTagOption(
              _filteredTags[index],
              tagQueryState.data?.toIdMap() ?? {},
            );
          },
          selectionCount: _filteredTags.length,
        );
      },
    );
  }

  Widget _buildTagOption(int id, Map<int, Tag> options) {
    Widget? icon;
    if (_sharedTags.contains(id) && !_removeTags.contains(id)) {
      // Tag is assigned to all documents and not marked for removal
      // => will remain assigned
      icon = const Icon(Icons.done);
    } else if (_addTags.contains(id)) {
      // tag is marked to be added
      icon = const Icon(Icons.done);
    } else if (_nonSharedTags.contains(id) && !_removeTags.contains(id)) {
      // Tag is neither shared among all documents, nor marked to be removed or
      // added but assigned to at least one document
      icon = const Icon(Icons.remove);
    }

    return ListTile(
      title: Text(options[id]!.name),
      trailing: icon,
      leading: CircleAvatar(
        backgroundColor: options[id]!.color,
        foregroundColor: options[id]!.textColor,
        child: options[id]!.isInboxTag ? const Icon(Icons.inbox) : null,
      ),
      onTap: () {
        if (_addTags.contains(id)) {
          setState(() {
            _addTags.remove(id);
          });
          if (_assignedTags.contains(id)) {
            setState(() {
              _removeTags.add(id);
            });
          }
        } else if (_removeTags.contains(id)) {
          setState(() {
            _removeTags.remove(id);
          });
          if (!_sharedTags.contains(id)) {
            setState(() {
              _addTags.add(id);
            });
          }
        } else {
          if (_sharedTags.contains(id)) {
            setState(() {
              _removeTags.add(id);
            });
          } else {
            setState(() {
              _addTags.add(id);
            });
          }
        }
      },
    );
  }

  void _submit() async {
    if (_addTags.isNotEmpty || _removeTags.isNotEmpty) {
      final bulkEditMutation = context
          .read<DocumentRepository>()
          .bulkActionMutation();
      final tags =
          context.read<TagRepository>().getAllQuery().state.data?.toIdMap() ??
          {};
      final addNames = _addTags
          .map((value) => "\"${tags[value]!.name}\"")
          .toList();
      final removeNames = _removeTags
          .map((value) => "\"${tags[value]!.name}\"")
          .toList();
      final shouldPerformAction =
          await showDialog<bool>(
            context: context,
            builder: (context) => ConfirmBulkModifyTagsDialog(
              selectionCount: widget.selection.length,
              addTags: addNames,
              removeTags: removeNames,
            ),
          ) ??
          false;
      if (shouldPerformAction) {
        bulkEditMutation.mutate(
          BulkEditRequest(
            documents: widget.selection.ids,
            method: MethodEnum.modifyTags,
            parameters: {
              'add_tags': _addTags.toList(),
              'remove_tags': _removeTags.toList(),
            },
          ),
        );
        if (mounted) context.pop();
      }
    }
  }
}
