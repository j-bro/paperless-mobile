import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:paperless_mobile/api/paperless_api.dart';
import 'package:paperless_mobile/features/edit_label/view/impl/add_correspondent_page.dart';
import 'package:paperless_mobile/features/edit_label/view/impl/add_document_type_page.dart';
import 'package:paperless_mobile/features/edit_label/view/impl/add_storage_path_page.dart';
import 'package:paperless_mobile/features/edit_label/view/impl/add_tag_page.dart';
import 'package:paperless_mobile/features/edit_label/view/impl/edit_correspondent_page.dart';
import 'package:paperless_mobile/features/edit_label/view/impl/edit_document_type_page.dart';
import 'package:paperless_mobile/features/edit_label/view/impl/edit_storage_path_page.dart';
import 'package:paperless_mobile/features/edit_label/view/impl/edit_tag_page.dart';
import 'package:paperless_mobile/features/labels/view/pages/labels_page.dart';
import 'package:paperless_mobile/features/linked_documents/view/linked_documents_page.dart';
import 'package:paperless_mobile/routing/navigation_keys.dart';

import 'shells/authenticated_route.dart';

class LabelsBranch extends StatefulShellBranchData {
  static final GlobalKey<NavigatorState> $navigatorKey = labelsNavigatorKey;
  const LabelsBranch();
}

class LabelsRoute extends GoRouteData with $LabelsRoute {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const LabelsPage();
  }
}

class EditLabelRoute extends GoRouteData with $EditLabelRoute {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      outerShellNavigatorKey;

  final Label $extra;

  const EditLabelRoute(this.$extra);

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return switch ($extra) {
      Correspondent c => EditCorrespondentPage(correspondent: c),
      DocumentType d => EditDocumentTypePage(documentType: d),
      Tag t => EditTagPage(tag: t),
      StoragePath s => EditStoragePathPage(storagePath: s),
    };
  }
}

class CreateLabelRoute extends GoRouteData with $CreateLabelRoute {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      outerShellNavigatorKey;
  final LabelType $extra;
  final String? name;
  //TODO: Refactor, currently possible on all routes, but only relevant for tags
  final bool? isInboxTag;

  CreateLabelRoute(this.$extra, {this.name, this.isInboxTag});

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return switch ($extra) {
      LabelType.correspondent => AddCorrespondentPage(initialName: name),
      LabelType.documentType => AddDocumentTypePage(initialName: name),
      LabelType.tag => AddTagPage(
        initialName: name,
        isInboxTag: isInboxTag ?? false,
      ),
      LabelType.storagePath => AddStoragePathPage(initialName: name),
    };
  }
}

class LinkedDocumentsRoute extends GoRouteData with $LinkedDocumentsRoute {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      outerShellNavigatorKey;
  final DocumentFilter $extra;

  const LinkedDocumentsRoute(this.$extra);
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return LinkedDocumentsPage(filter: $extra);
  }
}
