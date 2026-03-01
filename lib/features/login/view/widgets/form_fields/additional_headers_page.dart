import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:go_router/go_router.dart';
import 'package:paperless_mobile/core/extensions/flutter_extensions.dart';
import 'package:paperless_mobile/core/widgets/hint_card.dart';
import 'package:paperless_mobile/core/widgets/hint_state_builder.dart';
import 'package:paperless_mobile/features/login/server_connection/model/header_entry.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';

class AdditionalHeadersPage extends StatefulWidget {
  final List<HeaderEntry>? initialHeaders;
  const AdditionalHeadersPage({super.key, this.initialHeaders});

  @override
  State<AdditionalHeadersPage> createState() => _AdditionalHeadersPageState();
}

class _AdditionalHeadersPageState extends State<AdditionalHeadersPage> {
  List<HeaderEntry> _headers = [];

  @override
  void initState() {
    super.initState();
    if (widget.initialHeaders != null) {
      _headers = widget.initialHeaders!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope<List<HeaderEntry>>(
      canPop: false,
      onPopInvokedWithResult: (didPop, data) {
        if (didPop) {
          return;
        }
        context.pop<List<HeaderEntry>>(_headers);
      },
      child: Scaffold(
        appBar: AppBar(title: Text(S.of(context)!.additionalHeaders)),
        body: Column(
          spacing: 8,
          children: [
            HintStateBuilder(
              builder: (context, acknowledged, onAcknowledge) => HintCard(
                show: !acknowledged,
                hintText: S.of(context)!.addAdditionalHeadersHint,
                onAcknowledgeHint: onAcknowledge,
              ),
              listenKey: 'additionalHeaders',
            ),
            if (_headers.isNotEmpty)
              Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                columnWidths: {
                  0: IntrinsicColumnWidth(),
                  1: FlexColumnWidth(3),
                  2: FlexColumnWidth(4),
                  3: IntrinsicColumnWidth(),
                },
                children: [
                  TableRow(
                    children: [
                      SizedBox.shrink(),
                      Text(
                        S.of(context)!.key,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        S.of(context)!.value,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      SizedBox.shrink(),
                    ],
                  ),
                  ..._headers.mapIndexed(
                    (index, e) => TableRow(
                      children: [
                        Tooltip(
                          message: S.of(context)!.enabled,
                          child: Checkbox(
                            value: e.enabled,
                            onChanged: (value) {
                              setState(() {
                                _headers = _headers.map((header) {
                                  if (header.key == e.key &&
                                      header.value == e.value) {
                                    return header.copyWith(
                                      enabled: value ?? true,
                                    );
                                  }
                                  return header;
                                }).toList();
                              });
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: SelectableText(e.key),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: SelectableText(e.value),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _headers.removeAt(index);
                            });
                          },
                          icon: Icon(Icons.delete),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            HeaderEntryFormField(
              headers: _headers,
              onAdded: (header) {
                setState(() {
                  _headers.add(header);
                });
              },
            ),
          ],
        ).paddedSymmetrically(horizontal: 16, vertical: 16),
      ),
    );
  }
}

class HeaderEntryFormField extends StatelessWidget {
  final _formKey = GlobalKey<FormBuilderState>();
  final List<HeaderEntry> headers;
  final HeaderEntry? initialValue;
  final ValueChanged<HeaderEntry> onAdded;

  HeaderEntryFormField({
    super.key,
    required this.onAdded,
    this.initialValue,
    required this.headers,
  });

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: _formKey,
      child: Column(
        spacing: 8,
        children: [
          Row(
            spacing: 8,
            children: [
              Flexible(
                child: FormBuilderTextField(
                  name: 'header-name',
                  initialValue: initialValue?.key,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: S.of(context)!.key,
                    border: UnderlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return S.of(context)!.headerNameMustNotBeEmpty;
                    }
                    if (headers.any(
                      (element) =>
                          element.key.toLowerCase() == value!.toLowerCase(),
                    )) {
                      return S.of(context)!.headerNameAlreadyExists;
                    }
                    return null;
                  },
                ),
              ),
              Flexible(
                child: FormBuilderTextField(
                  name: 'header-value',
                  initialValue: initialValue?.value,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    labelText: S.of(context)!.value,
                    border: UnderlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return S.of(context)!.headerValueMustNotBeEmpty;
                    }
                    return null;
                  },
                  onSubmitted: (value) {
                    _onSubmit();
                  },
                ),
              ),
            ],
          ),
          Align(
            alignment: AlignmentGeometry.centerRight,
            child: TextButton.icon(
              onPressed: _onSubmit,
              label: Text(S.of(context)!.add),
              icon: Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }

  void _onSubmit() {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final headerEntry = HeaderEntry(
        key: _formKey.currentState!.fields['header-name']!.value,
        value: _formKey.currentState!.fields['header-value']!.value,
      );
      onAdded(headerEntry);
      _formKey.currentState?.reset();
    }
  }
}
