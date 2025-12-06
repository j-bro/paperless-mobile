import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:flutter/material.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/features/edit_label/view/label_form.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';

class AddLabelPage<T extends Label, TRequest extends LabelRequest>
    extends StatelessWidget {
  final String? initialName;
  final Widget pageTitle;
  final TRequest Function(Map<String, dynamic> json) fromJsonT;
  final List<Widget> additionalFields;
  final Mutation<T, TRequest> mutation;

  const AddLabelPage({
    super.key,
    this.initialName,
    required this.mutation,
    required this.pageTitle,
    required this.fromJsonT,
    this.additionalFields = const [],
  });

  @override
  Widget build(BuildContext context) {
    return AddLabelFormWidget(
      pageTitle: pageTitle,
      initialValue: initialName != null
          ? fromJsonT({'name': initialName})
          : null,
      additionalFields: additionalFields,
      fromJsonT: fromJsonT,
      mutation: mutation,
    );
  }
}

class AddLabelFormWidget<T extends Label, TRequest extends LabelRequest>
    extends StatelessWidget {
  final TRequest? initialValue;
  final TRequest Function(Map<String, dynamic> json) fromJsonT;
  final List<Widget> additionalFields;
  final Mutation<T, TRequest> mutation;
  final Widget pageTitle;
  const AddLabelFormWidget({
    super.key,
    this.initialValue,
    required this.fromJsonT,
    required this.additionalFields,
    required this.pageTitle,
    required this.mutation,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: pageTitle),
      body: LabelForm(
        autofocusNameField: true,
        initialValue: initialValue,
        fromJsonT: fromJsonT,
        submitButtonConfig: SubmitButtonConfig<T, TRequest>(
          icon: const Icon(Icons.add),
          label: Text(S.of(context)!.create),
          mutation: mutation,
        ),
        additionalFields: additionalFields,
      ),
    );
  }
}
