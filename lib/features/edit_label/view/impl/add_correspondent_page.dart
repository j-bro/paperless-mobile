import 'package:flutter/widgets.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:paperless_mobile/api/paperless_api.dart';
import 'package:paperless_mobile/core/extensions/context_extensions.dart';
import 'package:paperless_mobile/features/edit_label/view/add_label_page.dart';
import 'package:paperless_mobile/features/edit_label/view/label_form_values.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';

class AddCorrespondentPage extends StatelessWidget {
  final String? initialName;
  const AddCorrespondentPage({super.key, this.initialName});

  @override
  Widget build(BuildContext context) {
    return AddLabelPage(
      pageTitle: Text(S.of(context)!.addCorrespondent),
      buildRequest: _buildRequest,
      buildRequestFromName: (name) => CorrespondentRequest(name: name),
      initialName: initialName,
      mutation: context.correspondentRepository.createMutation,
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
