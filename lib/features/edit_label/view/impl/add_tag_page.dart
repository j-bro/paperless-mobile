import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:paperless_api/generated/lib/src/model/tag_request.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/extensions/context_extensions.dart';
import 'package:paperless_mobile/core/widgets/form_builder_fields/form_builder_color_picker.dart';
import 'package:paperless_mobile/features/edit_label/view/add_label_page.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';

class AddTagPage extends StatelessWidget {
  final String? initialName;
  const AddTagPage({super.key, this.initialName});

  @override
  Widget build(BuildContext context) {
    return AddLabelPage<Tag>(
      pageTitle: Text(S.of(context)!.addTag),
      fromJsonT: Tag.fromJson,
      initialName: initialName,
      onSubmit: (context, label) async {
        final response = await context.tagRepository.createMutation.mutate(
          TagRequest.fromJson(label.toJson()),
        );
        return response.data!;
      },
      additionalFields: [
        FormBuilderColorPickerField(
          name: Tag.colorKey,
          valueTransformer: (color) => color?.toHex(),
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
}
