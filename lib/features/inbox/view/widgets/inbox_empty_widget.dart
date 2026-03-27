import 'package:flutter/material.dart';
import 'package:paperless_mobile/core/extensions/context_extensions.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';

class InboxEmptyWidget extends StatelessWidget {
  const InboxEmptyWidget({
    super.key,
    required GlobalKey<RefreshIndicatorState> emptyStateRefreshIndicatorKey,
  }) : _emptyStateRefreshIndicatorKey = emptyStateRefreshIndicatorKey;

  final GlobalKey<RefreshIndicatorState> _emptyStateRefreshIndicatorKey;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      key: _emptyStateRefreshIndicatorKey,
      onRefresh: context.inboxRepository.reload,
      child: Center(
        child: Column(
          spacing: 8,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(S.of(context)!.youDoNotHaveUnseenDocuments),
            TextButton(
              onPressed: () =>
                  _emptyStateRefreshIndicatorKey.currentState?.show(),
              child: Text(S.of(context)!.refresh),
            ),
          ],
        ),
      ),
    );
  }
}
