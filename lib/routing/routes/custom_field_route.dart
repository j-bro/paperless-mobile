import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:paperless_mobile/api/paperless_api.dart';
import 'package:paperless_mobile/core/extensions/context_extensions.dart';
import 'package:paperless_mobile/features/labels/custom_fields/view/pages/add_custom_field_page.dart';
import 'package:paperless_mobile/features/labels/custom_fields/view/pages/edit_custom_field_page.dart';
import 'package:paperless_mobile/routing/navigation_keys.dart';

import 'shells/authenticated_route.dart';

class CreateCustomFieldRoute extends GoRouteData with $CreateCustomFieldRoute {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      outerShellNavigatorKey;

  final String? name;

  CreateCustomFieldRoute({this.name});

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return AddCustomFieldPage(
      initialName: name,
      mutation: context.customFieldRepository.createMutation,
    );
  }
}

class EditCustomFieldRoute extends GoRouteData with $EditCustomFieldRoute {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      outerShellNavigatorKey;

  final CustomField $extra;

  const EditCustomFieldRoute(this.$extra);

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return EditCustomFieldPage(
      customField: $extra,
      editMutation: context.customFieldRepository.putMutation($extra.id),
      deleteMutation: context.customFieldRepository.deleteMutation($extra.id),
      canDelete: context.uiSettings$.canDeleteCustomFields,
    );
  }
}
