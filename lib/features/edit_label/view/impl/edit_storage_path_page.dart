import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperless_api/generated/lib/src/model/storage_path_request.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/extensions/context_extensions.dart';
import 'package:paperless_mobile/core/store/slices/local_user_account.dart';
import 'package:paperless_mobile/features/edit_label/view/edit_label_page.dart';
import 'package:paperless_mobile/features/labels/storage_path/view/widgets/storage_path_autofill_form_builder_field.dart';

class EditStoragePathPage extends StatelessWidget {
  final StoragePath storagePath;
  const EditStoragePathPage({super.key, required this.storagePath});

  @override
  Widget build(BuildContext context) {
    return EditLabelPage<StoragePath>(
      label: storagePath,
      fromJsonT: StoragePath.fromJson,
      onSubmit: (context, label) async {
        final response = await context.storagePathRepository.putMutation.mutate(
          (label.id, StoragePathRequest.fromJson(label.toJson())),
        );
        return response.data!;
      },
      onDelete: (context, label) async {
        await context.storagePathRepository.deleteMutation.mutate(label.id);
      },
      canDelete: context
          .watch<LocalUserAccount>()
          .paperlessUser
          .canDeleteStoragePaths,
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
