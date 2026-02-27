import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/extensions/context_extensions.dart';
import 'package:paperless_mobile/features/edit_label/view/add_label_page.dart';
import 'package:paperless_mobile/features/edit_label/view/label_form_values.dart';
import 'package:paperless_mobile/features/labels/storage_path/view/widgets/storage_path_autofill_form_builder_field.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';

class AddStoragePathPage extends StatelessWidget {
  final String? initialName;
  const AddStoragePathPage({super.key, this.initialName});

  @override
  Widget build(BuildContext context) {
    return AddLabelPage(
      pageTitle: Text(S.of(context)!.addStoragePath),
      buildRequest: _buildRequest,
      buildRequestFromName: (name) => StoragePathRequest(name: name, path: ''),
      initialName: initialName,
      mutation: context.storagePathRepository.createMutation,
      additionalFields: const [
        StoragePathAutofillFormBuilderField(name: StoragePath.pathKey),
        SizedBox(height: 120.0),
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
