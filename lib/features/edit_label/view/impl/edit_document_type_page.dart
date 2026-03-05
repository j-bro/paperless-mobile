import 'package:flutter/widgets.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:paperless_mobile/api/paperless_api.dart';
import 'package:paperless_mobile/core/extensions/context_extensions.dart';
import 'package:paperless_mobile/features/edit_label/view/edit_label_page.dart';
import 'package:paperless_mobile/features/edit_label/view/label_form_values.dart';

class EditDocumentTypePage extends StatelessWidget {
  final DocumentType documentType;
  const EditDocumentTypePage({super.key, required this.documentType});

  @override
  Widget build(BuildContext context) {
    return EditLabelPage(
      initialValue: documentType,
      initialRequest: DocumentTypeRequest(
        name: documentType.name,
        match: documentType.match,
        matchingAlgorithm: documentType.matchingAlgorithm,
        isInsensitive: documentType.isInsensitive,
        owner: documentType.owner,
      ),
      buildRequest: _buildRequest,
      editMutation: context.documentTypeRepository.putMutation(documentType.id),
      deleteMutation: context.documentTypeRepository.deleteMutation(
        documentType.id,
      ),
      canDelete: context.loggedInUser$.paperlessUser.canDeleteDocumentTypes,
    );
  }

  static DocumentTypeRequest _buildRequest(
    LabelFormValues values,
    FormBuilderState formState,
  ) {
    return DocumentTypeRequest(
      name: values.name,
      match: values.match,
      matchingAlgorithm: values.matchingAlgorithm,
      isInsensitive: values.isInsensitive,
      owner: values.owner,
    );
  }
}
