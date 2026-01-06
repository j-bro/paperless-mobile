import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:paperless_mobile/features/login/server_connection/model/header_entry.dart';
import 'package:paperless_mobile/features/login/view/widgets/form_fields/additional_headers_page.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';

class AdditionalHeadersFormField extends StatefulWidget {
  final String name;

  final List<HeaderEntry>? initialHeaders;

  final ValueChanged<List<HeaderEntry>>? onChanged;
  const AdditionalHeadersFormField({
    super.key,
    this.onChanged,
    this.initialHeaders,
    required this.name,
  });

  @override
  State<AdditionalHeadersFormField> createState() =>
      _AdditionalHeadersFormFieldState();
}

class _AdditionalHeadersFormFieldState extends State<AdditionalHeadersFormField>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FormBuilderField<List<HeaderEntry>>(
      key: const ValueKey('login-additional-headers'),
      name: widget.name,
      onChanged: (value) {
        if (value != null) {
          widget.onChanged?.call(value);
        }
      },
      initialValue: widget.initialHeaders,
      builder: (field) {
        final theme = Theme.of(
          context,
        ).copyWith(dividerColor: Colors.transparent);
        return Theme(
          data: theme,
          child: ListTile(
            title: Text(
              '${S.of(context)!.additionalHeaders} '
              '(${field.value?.length ?? 0})',
            ),
            subtitle: Text(S.of(context)!.configureAdditionalHttpHeaders),
            trailing: const Icon(Icons.open_in_new),
            onTap: () async {
              final headers = await Navigator.of(context)
                  .push<List<HeaderEntry>>(
                    MaterialPageRoute(
                      builder: (context) =>
                          AdditionalHeadersPage(initialHeaders: field.value),
                    ),
                  );
              if (headers != null) {
                field.didChange(headers);
              }
            },
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
