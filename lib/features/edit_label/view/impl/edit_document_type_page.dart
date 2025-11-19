import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperless_api/generated/lib/src/model/document_type_request.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/extensions/context_extensions.dart';
import 'package:paperless_mobile/core/store/slices/local_user_account.dart';
import 'package:paperless_mobile/features/edit_label/view/edit_label_page.dart';

class EditDocumentTypePage extends StatelessWidget {
  final DocumentType documentType;
  const EditDocumentTypePage({super.key, required this.documentType});

  @override
  Widget build(BuildContext context) {
    return EditLabelPage<DocumentType>(
      label: documentType,
      fromJsonT: DocumentType.fromJson,
      onSubmit: (context, label) async {
        final response = await context.documentTypeRepository.putMutation
            .mutate((label.id, DocumentTypeRequest.fromJson(label.toJson())));
        return response.data!;
      },
      onDelete: (context, label) async {
        await context.documentTypeRepository.deleteMutation.mutate(label.id);
      },
      canDelete: context
          .watch<LocalUserAccount>()
          .paperlessUser
          .canDeleteDocumentTypes,
    );
  }
}
