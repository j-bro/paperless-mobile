import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:paperless_mobile/api/paperless_api.dart';
import 'package:paperless_mobile/core/extensions/context_extensions.dart';
import 'package:paperless_mobile/core/widgets/form_builder_fields/form_builder_color_picker.dart';
import 'package:paperless_mobile/features/edit_label/view/edit_label_page.dart';
import 'package:paperless_mobile/features/edit_label/view/label_form_values.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';

class EditTagPage extends StatelessWidget {
  final Tag tag;

  const EditTagPage({super.key, required this.tag});

  @override
  Widget build(BuildContext context) {
    return EditLabelPage(
      initialValue: tag,
      initialRequest: TagRequest(
        name: tag.name,
        match: tag.match,
        matchingAlgorithm: tag.matchingAlgorithm,
        isInsensitive: tag.isInsensitive,
        owner: tag.owner,
        color: tag.color?.toHex(),
        isInboxTag: tag.isInboxTag,
      ),
      buildRequest: _buildRequest,
      editMutation: context.tagRepository.putMutation(tag.id),
      deleteMutation: context.tagRepository.deleteMutation(tag.id),
      canDelete: context.uiSettings$.canDeleteTags,
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

  static TagRequest _buildRequest(
    LabelFormValues values,
    FormBuilderState formState,
  ) {
    final color = formState.value[Tag.colorKey] as Color?;
    return TagRequest(
      name: values.name,
      match: values.match,
      matchingAlgorithm: values.matchingAlgorithm,
      isInsensitive: values.isInsensitive,
      owner: values.owner,
      color: color?.toHex(),
      isInboxTag: formState.value[Tag.isInboxTagKey] as bool?,
    );
  }
}
