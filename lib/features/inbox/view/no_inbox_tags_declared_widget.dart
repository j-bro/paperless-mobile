import 'package:flutter/material.dart';
import 'package:paperless_mobile/api/paperless_api.dart';
import 'package:paperless_mobile/core/extensions/flutter_extensions.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';
import 'package:paperless_mobile/routing/routes/labels_route.dart';

class NoInboxTagsDeclaredWidget extends StatelessWidget {
  const NoInboxTagsDeclaredWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          S.of(context)!.setUpYourInbox,
          style: Theme.of(context).textTheme.titleMedium,
          textAlign: TextAlign.center,
        ).paddedSymmetrically(horizontal: 16),
        Text(
          S.of(context)!.noInboxTagsSetUpHint,
          textAlign: TextAlign.center,
        ).paddedSymmetrically(horizontal: 16, vertical: 8),
        SizedBox(height: 16),
        FilledButton.tonalIcon(
          icon: Icon(Icons.add),
          label: Text(S.of(context)!.createInboxTag),
          onPressed: () async {
            await CreateLabelRoute(
              LabelType.tag,
              name: S.of(context)!.inbox,
              isInboxTag: true,
            ).push(context);
          },
        ),
      ],
    );
  }
}
