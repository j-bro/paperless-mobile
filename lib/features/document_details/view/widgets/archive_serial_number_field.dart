import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:paperless_mobile/api/paperless_api.dart';
import 'package:paperless_mobile/core/bloc/connectivity_cubit.dart';
import 'package:paperless_mobile/core/extensions/context_extensions.dart';
import 'package:paperless_mobile/core/extensions/flutter_extensions.dart';
import 'package:paperless_mobile/core/repository/document_repository.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';
import 'package:paperless_mobile/helpers/message_helpers.dart';

class ArchiveSerialNumberField extends StatefulWidget {
  final int documentId;
  final int? initialValue;
  const ArchiveSerialNumberField({
    super.key,
    required this.documentId,
    this.initialValue,
  });

  @override
  State<ArchiveSerialNumberField> createState() =>
      _ArchiveSerialNumberFieldState();
}

class _ArchiveSerialNumberFieldState extends State<ArchiveSerialNumberField> {
  late final TextEditingController _asnEditingController;
  late bool _showClearButton;
  bool _canUpdate = false;
  Map<String, dynamic> _errors = {};

  @override
  void initState() {
    super.initState();
    _asnEditingController = TextEditingController(
      text: widget.initialValue?.toString(),
    )..addListener(_onTextChanged);
    _showClearButton = widget.initialValue != null;
  }

  void _onTextChanged() {
    final currentValue = int.tryParse(_asnEditingController.text);
    setState(() {
      _showClearButton = _asnEditingController.text.isNotEmpty;
      _canUpdate = currentValue != widget.initialValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userCanEditDocument =
        context.loggedInUser$.paperlessUser.canEditDocuments;
    return MutationConsumer(
      mutation: context.documentRepository.assignAsnMutation(widget.documentId),
      listenWhen: (oldState, newState) {
        return oldState.runtimeType != newState.runtimeType;
      },
      listener: (state) {
        switch (state) {
          case MutationSuccess():
            showSnackBar(context, S.of(context)!.archiveSerialNumberUpdated);
            break;
          case MutationError(:final error):
            if (error is PaperlessFormValidationException) {
              setState(() => _errors = error.validationMessages);
            } else if (mounted) {
              showGenericError(context, error, null);
            }
          default:
            break;
        }
      },
      builder: (context, state, assignAsn) {
        return Column(
          children: [
            TextFormField(
              enabled: userCanEditDocument,
              controller: _asnEditingController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onFieldSubmitted: (_) => _onSubmitted(assignAsn),
              decoration: InputDecoration(
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_showClearButton)
                      IconButton(
                        icon: const Icon(Icons.clear),
                        color: Theme.of(context).colorScheme.primary,
                        onPressed: userCanEditDocument
                            ? _asnEditingController.clear
                            : null,
                      ),
                    IconButton(
                      icon: const Icon(Icons.plus_one_rounded),
                      color: Theme.of(context).colorScheme.primary,
                      onPressed:
                          context.internetConnection$ && !_showClearButton
                          ? () => _onSubmitted(assignAsn, auto: true)
                          : null,
                    ).paddedOnly(right: 8),
                  ],
                ),
                errorText: _errors['archive_serial_number'],
                errorMaxLines: 2,
                labelText: S.of(context)!.archiveSerialNumber,
              ),
            ),
            TextButton.icon(
              icon: const Icon(Icons.done),
              onPressed: userCanEditDocument && _canUpdate && !state.isLoading
                  ? () => _onSubmitted(assignAsn)
                  : null,
              label: Text(S.of(context)!.save),
            ).padded(),
          ],
        );
      },
    );
  }

  Future<void> _onSubmitted(
    Future<MutationState<int?>> Function(AssignAsnRequest request) assignAsn, {
    bool auto = false,
  }) async {
    FocusScope.of(context).unfocus();
    int? asn;
    if (!auto) {
      final value = _asnEditingController.text;
      asn = int.tryParse(value);
    }
    await assignAsn(AssignAsnRequest(auto: auto, asn: asn));
    _onAsnUpdated();
  }

  void _onAsnUpdated() {
    setState(() => _errors = {});
    FocusScope.of(context).unfocus();
    showSnackBar(context, S.of(context)!.archiveSerialNumberUpdated);
  }
}
