import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:paperless_mobile/api/paperless_api.dart';
import 'package:paperless_mobile/core/extensions/context_extensions.dart';
import 'package:paperless_mobile/features/edit_label/view/edit_label_page.dart';
import 'package:paperless_mobile/features/edit_label/view/label_form_values.dart';
import 'package:paperless_mobile/features/labels/storage_path/view/widgets/storage_path_autofill_form_builder_field.dart';

class EditStoragePathPage extends StatelessWidget {
  final StoragePath storagePath;
  const EditStoragePathPage({super.key, required this.storagePath});

  @override
  Widget build(BuildContext context) {
    return EditLabelPage(
      initialValue: storagePath,
      initialRequest: StoragePathRequest(
        name: storagePath.name,
        path: storagePath.path,
        match: storagePath.match,
        matchingAlgorithm: storagePath.matchingAlgorithm,
        isInsensitive: storagePath.isInsensitive,
        owner: storagePath.owner,
      ),
      buildRequest: _buildRequest,
      editMutation: context.storagePathRepository.putMutation(storagePath.id),
      deleteMutation: context.storagePathRepository.deleteMutation(
        storagePath.id,
      ),
      canDelete: context.uiSettings$.canDeleteStoragePaths,
      additionalFields: [
        StoragePathAutofillFormBuilderField(
          name: StoragePath.pathKey,
          initialValue: storagePath.path,
        ),
        const SizedBox(height: 120.0),
      ],
    );
  }

  static StoragePathRequest _buildRequest(
    LabelFormValues values,
    FormBuilderState formState,
  ) {
    return StoragePathRequest(
      name: values.name,
      path: formState.value[StoragePath.pathKey] as String? ?? '',
      match: values.match,
      matchingAlgorithm: values.matchingAlgorithm,
      isInsensitive: values.isInsensitive,
      owner: values.owner,
    );
  }
}
