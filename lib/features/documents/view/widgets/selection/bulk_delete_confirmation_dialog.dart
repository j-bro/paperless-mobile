import 'package:flutter/material.dart';
import 'package:paperless_mobile/api/models/document.dart';
import 'package:paperless_mobile/core/widgets/dialog_utils/dialog_cancel_button.dart';
import 'package:paperless_mobile/core/widgets/dialog_utils/dialog_confirm_button.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';

class BulkDeleteConfirmationDialog extends StatelessWidget {
  const BulkDeleteConfirmationDialog({super.key, required this.selection});
  final Iterable<Document> selection;
  @override
  Widget build(BuildContext context) {
    assert(selection.isNotEmpty);
    return AlertDialog(
      title: Text(S.of(context)!.confirmDeletion),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            S
                .of(context)!
                .areYouSureYouWantToDeleteTheFollowingDocuments(
                  selection.length,
                ),
          ),
          const SizedBox(height: 16),
          ...selection.map(_buildBulletPoint),
          const SizedBox(height: 16),
          Text(S.of(context)!.thisActionIsIrreversibleDoYouWishToProceedAnyway),
        ],
      ),
      actions: [
        const DialogCancelButton(),
        DialogConfirmButton(
          label: S.of(context)!.delete,
          style: DialogConfirmButtonStyle.danger,
        ),
      ],
    );
  }

  Widget _buildBulletPoint(Document doc) {
    return ListTile(
      dense: true,
      title: Text(
        doc.title ?? '-',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontWeight: FontWeight.w700),
      ),
    );
  }
}
