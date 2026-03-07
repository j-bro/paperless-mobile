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
    // Uncommenting this will keep the state of all the children alive, but it also causes
    // some weird side effects like multiple heros being active at the same time.

    // return IndexedStack(
    //   index: navigationShell.currentIndex,
    //   children: children,
    // );
    return children[navigationShell.currentIndex];
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
