import 'package:flutter/material.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/extensions/context_extensions.dart';
import 'package:paperless_mobile/features/edit_label/view/edit_label_page.dart';
import 'package:paperless_mobile/features/labels/storage_path/view/widgets/storage_path_autofill_form_builder_field.dart';

class EditStoragePathPage extends StatelessWidget {
  final StoragePath storagePath;
  const EditStoragePathPage({super.key, required this.storagePath});

  @override
  Widget build(BuildContext context) {
    return EditLabelPage(
      initialValue: storagePath,
      fromJsonTRequest: StoragePathRequest.fromJson,
      editMutation: context.storagePathRepository.putMutation(storagePath.id),
      deleteMutation: context.storagePathRepository.deleteMutation(
        storagePath.id,
      ),
      canDelete: context.loggedInUser$.paperlessUser.canDeleteStoragePaths,
      additionalFields: [
        StoragePathAutofillFormBuilderField(
          name: StoragePath.pathKey,
          initialValue: storagePath.path,
        ),
        const SizedBox(height: 120.0),
      ],
    );
  }
}
