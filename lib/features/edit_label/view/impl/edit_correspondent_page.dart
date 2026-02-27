import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/extensions/context_extensions.dart';
import 'package:paperless_mobile/features/edit_label/view/edit_label_page.dart';
import 'package:paperless_mobile/features/edit_label/view/label_form_values.dart';

class EditCorrespondentPage extends StatelessWidget {
  final Correspondent correspondent;
  const EditCorrespondentPage({super.key, required this.correspondent});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return EditLabelPage(
          initialValue: correspondent,
          initialRequest: CorrespondentRequest(
            name: correspondent.name,
            match: correspondent.match,
            matchingAlgorithm: correspondent.matchingAlgorithm,
            isInsensitive: correspondent.isInsensitive,
            owner: correspondent.owner,
          ),
          buildRequest: _buildRequest,
          editMutation: context.correspondentRepository.putMutation(
            correspondent.id,
          ),
          deleteMutation: context.correspondentRepository.deleteMutation(
            correspondent.id,
          ),
          canDelete:
              context.loggedInUser$.paperlessUser.canDeleteCorrespondents,
        );
      },
    );
  }

  static CorrespondentRequest _buildRequest(
    LabelFormValues values,
    FormBuilderState formState,
  ) {
    return CorrespondentRequest(
      name: values.name,
      match: values.match,
      matchingAlgorithm: values.matchingAlgorithm,
      isInsensitive: values.isInsensitive,
      owner: values.owner,
    );
  }
}
