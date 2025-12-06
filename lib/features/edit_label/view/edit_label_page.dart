import 'dart:developer';

import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:go_router/go_router.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/widgets/dialog_utils/dialog_cancel_button.dart';
import 'package:paperless_mobile/core/widgets/dialog_utils/dialog_confirm_button.dart';
import 'package:paperless_mobile/core/widgets/dialog_utils/pop_with_unsaved_changes.dart';
import 'package:paperless_mobile/core/widgets/icon_loading_widget.dart';
import 'package:paperless_mobile/features/edit_label/view/label_form.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';
import 'package:paperless_mobile/helpers/message_helpers.dart';

class EditLabelPage<T extends Label, TRequest extends LabelRequest>
    extends StatelessWidget {
  final T initialValue;
  final TRequest Function(Map<String, dynamic> json) fromJsonTRequest;
  final List<Widget> additionalFields;
  final Mutation<T, TRequest> editMutation;
  final Mutation<int, void> deleteMutation;
  final bool canDelete;

  const EditLabelPage({
    super.key,
    required this.initialValue,
    required this.fromJsonTRequest,
    this.additionalFields = const [],
    required this.editMutation,
    required this.deleteMutation,
    required this.canDelete,
  });

  @override
  Widget build(BuildContext context) {
    return EditLabelForm(
      initialValue: initialValue,
      additionalFields: additionalFields,
      fromJsonT: fromJsonTRequest,
      editMutation: editMutation,
      deleteMutation: deleteMutation,
      canDelete: canDelete,
    );
  }
}

class EditLabelForm<T extends Label, TRequest extends LabelRequest>
    extends StatelessWidget {
  final T initialValue;
  final TRequest Function(Map<String, dynamic> json) fromJsonT;
  final List<Widget> additionalFields;
  final Mutation<T, TRequest> editMutation;
  final Mutation<int, void> deleteMutation;
  final bool canDelete;
  final _formKey = GlobalKey<FormBuilderState>();

  EditLabelForm({
    super.key,
    required this.initialValue,
    required this.fromJsonT,
    required this.additionalFields,
    required this.editMutation,
    required this.deleteMutation,
    required this.canDelete,
  });

  @override
  Widget build(BuildContext context) {
    return PopWithUnsavedChanges(
      hasChangesPredicate: () {
        return _formKey.currentState?.isDirty ?? false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(S.of(context)!.edit),
          actions: [
            MutationBuilder(
              mutation: deleteMutation,
              builder: (context, state, _) {
                return IconButton(
                  onPressed: canDelete && !state.isLoading
                      ? () => _onDelete(context)
                      : null,
                  icon: state.isLoading
                      ? const IconLoadingWidget()
                      : Icon(Icons.delete),
                );
              },
            ),
          ],
        ),
        body: LabelForm(
          formKey: _formKey,
          autofocusNameField: false,
          initialValue: initialValue.toRequest(),
          fromJsonT: fromJsonT,
          submitButtonConfig: SubmitButtonConfig<T, TRequest>(
            icon: const Icon(Icons.save),
            label: Text(S.of(context)!.saveChanges),
            mutation: editMutation,
          ),
          additionalFields: additionalFields,
        ),
      ),
    );
  }

  void _onDelete(BuildContext context) async {
    if ((initialValue.documentCount ?? 0) > 0) {
      final shouldDelete =
          await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(S.of(context)!.confirmDeletion),
              content: Text(S.of(context)!.deleteLabelWarningText),
              actions: [
                const DialogCancelButton(),
                DialogConfirmButton(
                  label: S.of(context)!.delete,
                  style: DialogConfirmButtonStyle.danger,
                ),
              ],
            ),
          ) ??
          false;
      if (shouldDelete) {
        try {
          final mutationResult = await deleteMutation.mutate();
          if (mutationResult is MutationError) {
            throw (mutationResult as MutationError).error;
          }
          if (context.mounted) {
            context.pop();
          }
        } on PaperlessApiException catch (error) {
          if (context.mounted) {
            showErrorMessage(context, error);
          }
        } catch (error, stackTrace) {
          log("An error occurred!", error: error, stackTrace: stackTrace);
        }
      }
    } else {
      deleteMutation.mutate();
      context.pop();
    }
  }
}
