import 'package:flutter/widgets.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/extensions/context_extensions.dart';
import 'package:paperless_mobile/features/edit_label/view/edit_label_page.dart';

class EditDocumentTypePage extends StatelessWidget {
  final DocumentType documentType;
  const EditDocumentTypePage({super.key, required this.documentType});

  @override
  Widget build(BuildContext context) {
    return EditLabelPage(
      initialValue: documentType,
      fromJsonTRequest: DocumentTypeRequest.fromJson,
      editMutation: context.documentTypeRepository.putMutation(documentType.id),
      deleteMutation: context.documentTypeRepository.deleteMutation(
        documentType.id,
      ),
      canDelete: context.loggedInUser$.paperlessUser.canDeleteDocumentTypes,
    );
  }
}
