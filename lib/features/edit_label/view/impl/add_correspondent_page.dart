import 'package:flutter/widgets.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/extensions/context_extensions.dart';
import 'package:paperless_mobile/features/edit_label/view/add_label_page.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';

class AddCorrespondentPage extends StatelessWidget {
  final String? initialName;
  const AddCorrespondentPage({super.key, this.initialName});

  @override
  Widget build(BuildContext context) {
    return AddLabelPage(
      pageTitle: Text(S.of(context)!.addCorrespondent),
      fromJsonT: CorrespondentRequest.fromJson,
      initialName: initialName,
      mutation: context.correspondentRepository.createMutation,
    );
  }
}
