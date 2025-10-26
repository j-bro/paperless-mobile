import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:paperless_mobile/features/inbox/view/pages/inbox_page.dart';
import 'package:paperless_mobile/routing/navigation_keys.dart';

import 'shells/authenticated_route.dart';

class InboxBranch extends StatefulShellBranchData {
  static final GlobalKey<NavigatorState> $navigatorKey = inboxNavigatorKey;

  const InboxBranch();
}

class InboxRoute extends GoRouteData with $InboxRoute {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const InboxPage();
  }
}
