import 'package:flutter/material.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/extensions/context_extensions.dart';
import 'package:paperless_mobile/features/edit_label/view/edit_label_page.dart';

class EditCorrespondentPage extends StatelessWidget {
  final Correspondent correspondent;
  const EditCorrespondentPage({super.key, required this.correspondent});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return EditLabelPage(
          initialValue: correspondent,
          fromJsonTRequest: CorrespondentRequest.fromJson,
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
}
