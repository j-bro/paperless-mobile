import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:paperless_mobile/api/models/correspondent_permissions_view.dart';

part 'correspondent_permissions.freezed.dart';
part 'correspondent_permissions.g.dart';

@Freezed(toJson: true, fromJson: true)
abstract class CorrespondentPermissions with _$CorrespondentPermissions {
  factory CorrespondentPermissions({
    CorrespondentPermissionsView? view,
    CorrespondentPermissionsView? change,
  }) = _CorrespondentPermissions;

  factory CorrespondentPermissions.fromJson(Map<String, dynamic> json) =>
      _$CorrespondentPermissionsFromJson(json);
}
