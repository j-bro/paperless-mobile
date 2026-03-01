import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/extensions/context_extensions.dart';
import 'package:paperless_mobile/core/widgets/form_builder_fields/form_builder_color_picker.dart';
import 'package:paperless_mobile/features/edit_label/view/add_label_page.dart';
import 'package:paperless_mobile/features/edit_label/view/label_form_values.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';

class AddTagPage extends StatelessWidget {
  final String? initialName;
  const AddTagPage({super.key, this.initialName});

  @override
  Widget build(BuildContext context) {
    return AddLabelPage(
      pageTitle: Text(S.of(context)!.addTag),
      buildRequest: _buildRequest,
      buildRequestFromName: (name) => TagRequest(name: name),
      initialName: initialName,
      mutation: context.tagRepository.createMutation,
      additionalFields: [
        FormBuilderColorPickerField(
          name: Tag.colorKey,
          decoration: InputDecoration(label: Text(S.of(context)!.color)),
          colorPickerType: ColorPickerType.materialPicker,
          initialValue: Color(
            (Random().nextDouble() * 0xFFFFFF).toInt(),
          ).withAlpha(255),
          readOnly: true,
        ),
        FormBuilderField<bool>(
          name: Tag.isInboxTagKey,
          initialValue: false,
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
