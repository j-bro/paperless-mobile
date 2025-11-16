import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:paperless_mobile/core/store/local_store.dart';
import 'package:paperless_mobile/features/home/view/scaffold_with_navigation_bar.dart';
import 'package:provider/provider.dart';

class ScaffoldShellRoute extends StatefulShellRouteData {
  const ScaffoldShellRoute();

  static Widget $navigatorContainerBuilder(
    BuildContext context,
    StatefulNavigationShell navigationShell,
    List<Widget> children,
  ) {
    return children[navigationShell.currentIndex];
  }

  @override
  Widget builder(
    BuildContext context,
    GoRouterState state,
    StatefulNavigationShell navigationShell,
  ) {
    final localStoreState = context.read<LocalStore>().state;
    final currentUserId = localStoreState.loggedInUserId!;
    final authenticatedUser =
        localStoreState.localUserData[currentUserId]!.remoteUser.paperlessUser;

    return ScaffoldWithNavigationBar(
      authenticatedUser: authenticatedUser,
      navigationShell: navigationShell,
    );
  }
}
