import 'package:flutter/widgets.dart';
import 'package:paperless_api/generated/lib/src/model/correspondent_request.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/extensions/context_extensions.dart';
import 'package:paperless_mobile/features/edit_label/view/add_label_page.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';

class AddCorrespondentPage extends StatelessWidget {
  final String? initialName;
  const AddCorrespondentPage({super.key, this.initialName});

  @override
  Widget build(BuildContext context) {
    return AddLabelPage<Correspondent>(
      pageTitle: Text(S.of(context)!.addCorrespondent),
      fromJsonT: Correspondent.fromJson,
      initialName: initialName,
      onSubmit: (context, label) async {
        final response = await context.correspondentRepository.createMutation
            .mutate(CorrespondentRequest.fromJson(label.toJson()));
        return response.data!;
      },
    );
  }
}
