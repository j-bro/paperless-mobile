import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:paperless_api/generated/lib/src/model/tag_request.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/extensions/context_extensions.dart';
import 'package:paperless_mobile/core/store/slices/local_user_account.dart';
import 'package:paperless_mobile/core/widgets/form_builder_fields/form_builder_color_picker.dart';
import 'package:paperless_mobile/features/edit_label/view/edit_label_page.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';

class EditTagPage extends StatelessWidget {
  final Tag tag;

  const EditTagPage({super.key, required this.tag});

  @override
  Widget build(BuildContext context) {
    return EditLabelPage<Tag>(
      label: tag,
      fromJsonT: Tag.fromJson,
      onSubmit: (context, label) async {
        final response = await context.tagRepository.putMutation.mutate((
          label.id,
          TagRequest.fromJson(label.toJson()),
        ));
        return response.data!;
      },
      onDelete: (context, label) async {
        await context.tagRepository.deleteMutation.mutate(label.id);
      },
      canDelete: context.loggedInUser$.paperlessUser.canDeleteTags,
      additionalFields: [
        FormBuilderColorPickerField(
          initialValue: tag.color,
          name: Tag.colorKey,
          decoration: InputDecoration(label: Text(S.of(context)!.color)),
          colorPickerType: ColorPickerType.materialPicker,
          readOnly: true,
        ),
        FormBuilderField<bool>(
          name: Tag.isInboxTagKey,
          initialValue: tag.isInboxTag,
          builder: (field) {
            return CheckboxListTile(
              value: field.value,
              title: Text(S.of(context)!.inboxTag),
              onChanged: (value) => field.didChange(value),
            );
          },
        ),
      ],
    );
  }
}
