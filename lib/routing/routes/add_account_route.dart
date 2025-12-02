import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:paperless_mobile/routing/navigation_keys.dart';
import 'package:paperless_mobile/routing/routes.dart';

part 'add_account_route.g.dart';

@TypedGoRoute<AddAccountRoute>(path: '/add-account', name: R.addAccount)
class AddAccountRoute extends GoRouteData with $AddAccountRoute {
  const AddAccountRoute();

  static final $parentNavigatorKey = rootNavigatorKey;

  @override
  FutureOr<String?> redirect(BuildContext context, GoRouterState state) {
    return '/connect?success-redirect-route-name=${R.addAccountCredentialsInput}';
  }
}
