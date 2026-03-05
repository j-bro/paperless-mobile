import 'package:flutter/material.dart';
import 'package:paperless_mobile/api/paperless_api.dart';
import 'package:paperless_mobile/core/extensions/context_extensions.dart';
import 'package:paperless_mobile/core/extensions/document_extensions.dart';
import 'package:paperless_mobile/core/extensions/flutter_extensions.dart';
import 'package:paperless_mobile/features/documents/view/widgets/selection/bulk_delete_confirmation_dialog.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';
import 'package:paperless_mobile/helpers/message_helpers.dart';
import 'package:paperless_mobile/routing/routes/documents_route.dart';

class DocumentSelectionSliverAppBar extends StatelessWidget {
  final Iterable<Document> selection;
  final VoidCallback onResetSelection;
  const DocumentSelectionSliverAppBar({
    super.key,
    required this.selection,
    required this.onResetSelection,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      stretch: false,
      pinned: true,
      floating: true,
      snap: true,
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      title: Text(S.of(context)!.countSelected(selection.length)),
      leading: IconButton(
        icon: const Icon(Icons.close),
        onPressed: onResetSelection,
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () async {
            final bulkDelete = context.documentRepository
                .bulkActionMutation()
                .mutate;

            final shouldDelete =
                await showDialog<bool>(
                  context: context,
                  builder: (context) =>
                      BulkDeleteConfirmationDialog(selection: selection),
                ) ??
                false;
            if (shouldDelete) {
              try {
                await bulkDelete(
                  BulkEditRequest(
                    documents: selection.ids,
                    method: MethodEnum.delete,
                  ),
                );
                if (!context.mounted) return;
                showSnackBar(
                  context,
                  S.of(context)!.documentsSuccessfullyDeleted,
                );
                onResetSelection();
              } on PaperlessApiException catch (error, stackTrace) {
                if (!context.mounted) return;
                showErrorMessage(context, error, stackTrace);
              }
            }
          },
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(kTextTabBarHeight),
        child: SizedBox(
          height: kTextTabBarHeight,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              ActionChip(
                label: Text(S.of(context)!.correspondent),
                avatar: const Icon(Icons.edit),
                onPressed: () {
                  BulkEditDocumentsRoute(
                    BulkEditExtraWrapper(selection, LabelType.correspondent),
                  ).push<bool>(context).then((wasSuccessful) {
                    if (wasSuccessful ?? false) {
                      onResetSelection();
                    }
                  });
                },
              ).paddedOnly(left: 8, right: 4),
              ActionChip(
                label: Text(S.of(context)!.documentType),
                avatar: const Icon(Icons.edit),
                onPressed: () async {
                  BulkEditDocumentsRoute(
                    BulkEditExtraWrapper(selection, LabelType.documentType),
                  ).push<bool>(context).then((wasSuccessful) {
                    if (wasSuccessful ?? false) {
                      onResetSelection();
                    }
                  });
                },
              ).paddedOnly(left: 8, right: 4),
              ActionChip(
                label: Text(S.of(context)!.storagePath),
                avatar: const Icon(Icons.edit),
                onPressed: () async {
                  BulkEditDocumentsRoute(
                    BulkEditExtraWrapper(selection, LabelType.storagePath),
                  ).push<bool>(context).then((wasSuccessful) {
                    if (wasSuccessful ?? false) {
                      onResetSelection();
                    }
                  });
                },
              ).paddedOnly(left: 8, right: 4),
              _buildBulkEditTagsChip(context).paddedOnly(left: 4, right: 4),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBulkEditTagsChip(BuildContext context) {
    return ActionChip(
      label: Text(S.of(context)!.tags),
      avatar: const Icon(Icons.edit),
      onPressed: () {
        BulkEditDocumentsRoute(
          BulkEditExtraWrapper(selection, LabelType.tag),
        ).push<bool>(context).then((wasSuccessful) {
          if (wasSuccessful ?? false) {
            onResetSelection();
          }
        });
      },
    );
  }
}
