import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:paperless_mobile/constants.dart';
import 'package:paperless_mobile/core/extensions/flutter_extensions.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';
import 'package:paperless_mobile/routing/routes/app_logs_route.dart';

class AppLogsFooterWidget extends StatelessWidget {
  const AppLogsFooterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        style: Theme.of(context).textTheme.labelLarge,
        children: [
          TextSpan(text: S.of(context)!.version(packageInfo.version)),
          WidgetSpan(child: SizedBox(width: 24)),
          TextSpan(
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
            text: S.of(context)!.appLogs(''),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                AppLogsRoute().push(context);
              },
          ),
        ],
      ),
    );
  }
}
