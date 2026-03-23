import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:paperless_mobile/api/models/correspondent_permissions_view.dart';

part 'document_permissions.freezed.dart';
part 'document_permissions.g.dart';

@Freezed(toJson: true, fromJson: true)
abstract class DocumentPermissions with _$DocumentPermissions {
  factory DocumentPermissions({
    CorrespondentPermissionsView? view,
    CorrespondentPermissionsView? change,
  }) = _DocumentPermissions;

  factory DocumentPermissions.fromJson(Map<String, dynamic> json) =>
      _$DocumentPermissionsFromJson(json);
}
