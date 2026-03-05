import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:paperless_mobile/api/paperless_api.dart';
import 'package:paperless_mobile/features/saved_view/view/add_saved_view_page.dart';
import 'package:paperless_mobile/features/saved_view/view/edit_saved_view_page.dart';

import 'shells/authenticated_route.dart';

class SavedViewsRoute extends GoRouteData with $SavedViewsRoute {
  const SavedViewsRoute();
}

class CreateSavedViewRoute extends GoRouteData with $CreateSavedViewRoute {
  final DocumentFilter? $extra;
  final bool? showOnDashboard;
  final bool? showInSidebar;
  const CreateSavedViewRoute({
    this.$extra = const DocumentFilter(),
    this.showOnDashboard,
    this.showInSidebar,
  });

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return AddSavedViewPage(
      initialFilter: $extra,
      showInSidebar: showInSidebar,
      showOnDashboard: showOnDashboard,
    );
  }
}

class EditSavedViewRoute extends GoRouteData with $EditSavedViewRoute {
  final SavedView $extra;
  const EditSavedViewRoute({required this.$extra});

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return EditSavedViewPage(savedView: $extra);
  }
}
