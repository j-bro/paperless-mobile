import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperless_api/generated/lib/src/model/correspondent_request.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/extensions/context_extensions.dart';
import 'package:paperless_mobile/core/store/slices/local_user_account.dart';
import 'package:paperless_mobile/features/edit_label/view/edit_label_page.dart';

class EditCorrespondentPage extends StatelessWidget {
  final Correspondent correspondent;
  const EditCorrespondentPage({super.key, required this.correspondent});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return EditLabelPage<Correspondent>(
          label: correspondent,
          fromJsonT: Correspondent.fromJson,
          onSubmit: (context, label) async {
            final response = await context.correspondentRepository.putMutation
                .mutate((
                  label.id,
                  CorrespondentRequest.fromJson(label.toJson()),
                ));
            return response.data!;
          },
          onDelete: (context, label) async {
            await context.correspondentRepository.deleteMutation.mutate(
              label.id,
            );
          },
          canDelete: context
              .watch<LocalUserAccount>()
              .paperlessUser
              .canDeleteCorrespondents,
        );
      },
    );
  }
}
