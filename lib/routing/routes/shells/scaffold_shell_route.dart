import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:paperless_mobile/features/home/view/scaffold_with_navigation_bar.dart';

class ScaffoldShellRoute extends StatefulShellRouteData {
  const ScaffoldShellRoute();

  static Widget $navigatorContainerBuilder(
    BuildContext context,
    StatefulNavigationShell navigationShell,
    List<Widget> children,
  ) {
    return IndexedStack(
      index: navigationShell.currentIndex,
      children: children,
    );
    // return children[navigationShell.currentIndex];
  }

  @override
  Widget builder(
    BuildContext context,
    GoRouterState state,
    StatefulNavigationShell navigationShell,
  ) {
    return ScaffoldWithNavigationBar(navigationShell: navigationShell);
  }
}
