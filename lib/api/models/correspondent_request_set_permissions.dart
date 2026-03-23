import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:paperless_mobile/api/models/correspondent_permissions_view.dart';

part 'correspondent_request_set_permissions.freezed.dart';
part 'correspondent_request_set_permissions.g.dart';

@Freezed(toJson: true, fromJson: true)
abstract class CorrespondentRequestSetPermissions
    with _$CorrespondentRequestSetPermissions {
  factory CorrespondentRequestSetPermissions({
    CorrespondentPermissionsView? view,
    CorrespondentPermissionsView? change,
  }) = _CorrespondentRequestSetPermissions;

  factory CorrespondentRequestSetPermissions.fromJson(
    Map<String, dynamic> json,
  ) => _$CorrespondentRequestSetPermissionsFromJson(json);
}
