import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:paperless_mobile/api/models/data_type_enum.dart';
import 'package:paperless_mobile/core/extensions/flutter_extensions.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';

/// Shows extra form fields depending on the selected [dataType].
/// Uses a [ValueKey] so that switching data types disposes the old widget
/// subtree and resets the form state of the previously shown fields.
class CustomFieldConditionalFormFields extends StatelessWidget {
  final DataTypeEnum? dataType;
  final Map<String, dynamic>? extraData;

  const CustomFieldConditionalFormFields({
    super.key,
    this.dataType,
    this.extraData,
  });

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: ValueKey(dataType),
      child: switch (dataType) {
        DataTypeEnum.monetary => _MonetaryFieldExtraFields(
          initialCurrency: extraData?['default_currency'] as String?,
        ),
        DataTypeEnum.select => _SelectFieldExtraFields(
          initialOptions: (extraData?['select_options'] as List<dynamic>?)
              ?.map((e) => Map<String, dynamic>.from(e as Map))
              .toList(),
        ),
        _ => const SizedBox.shrink(),
      },
    );
  }
}

class _MonetaryFieldExtraFields extends StatelessWidget {
  final String? initialCurrency;

  const _MonetaryFieldExtraFields({this.initialCurrency});

  @override
  Widget build(BuildContext context) {
    return FormBuilderTextField(
      name: 'default_currency',
      initialValue: initialCurrency,
      valueTransformer: (value) {
        final trimmed = value?.trim();
        return (trimmed != null && trimmed.isNotEmpty) ? trimmed : null;
      },
      decoration: InputDecoration(
        labelText: S.of(context)!.customFieldMonetaryDefaultCurrencyLabel,
        hintText: 'EUR',
        helperText: S.of(context)!.customFieldMonetaryDefaultCurrencyHelperText,
      ),
    );
  }
}

class _SelectFieldExtraFields extends StatefulWidget {
  final List<Map<String, dynamic>>? initialOptions;

  const _SelectFieldExtraFields({this.initialOptions});

  @override
  State<_SelectFieldExtraFields> createState() =>
      _SelectFieldExtraFieldsState();
}

class _SelectFieldExtraFieldsState extends State<_SelectFieldExtraFields> {
  late final List<TextEditingController> _controllers;
  late final List<dynamic> _optionIds;

  @override
  void initState() {
    super.initState();
    final initial = widget.initialOptions;
    if (initial != null && initial.isNotEmpty) {
      _controllers = initial
          .map((o) => TextEditingController(text: o['label'] as String? ?? ''))
          .toList();
      _optionIds = initial.map((o) => o['id']).toList();
    } else {
      _controllers = [TextEditingController()];
      _optionIds = [null];
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  List<Map<String, dynamic>> _buildValue() {
    return List.generate(
      _controllers.length,
      (i) => {
        'label': _controllers[i].text,
        'id': i < _optionIds.length ? _optionIds[i] : null,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilderField<List<Map<String, dynamic>>>(
      name: 'select_options',
      initialValue: _buildValue(),
      builder: (FormFieldState<List<Map<String, dynamic>>> field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              S.of(context)!.customFieldSelectOptions,
              style: Theme.of(context).textTheme.labelLarge,
            ).paddedSymmetrically(horizontal: 8, vertical: 16),
            ...List.generate(_controllers.length, (index) {
              return Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controllers[index],
                      decoration: InputDecoration(
                        labelText: S
                            .of(context)!
                            .customFieldSelectOptionHintText(index + 1),
                      ),
                      onChanged: (_) => field.didChange(_buildValue()),
                    ),
                  ),
                  if (_controllers.length > 1)
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline),
                      onPressed: () {
                        setState(() {
                          _controllers[index].dispose();
                          _controllers.removeAt(index);
                          if (index < _optionIds.length) {
                            _optionIds.removeAt(index);
                          }
                        });
                        field.didChange(_buildValue());
                      },
                    ),
                ],
              ).paddedOnly(bottom: 16);
            }),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                icon: const Icon(Icons.add),
                label: Text(S.of(context)!.customFieldSelectAddOption),
                onPressed: () {
                  setState(() {
                    _controllers.add(TextEditingController());
                    _optionIds.add(null);
                  });
                  field.didChange(_buildValue());
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
