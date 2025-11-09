import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce/hive.dart';
import 'package:paperless_api/src/models/permissions/users_and_groups_permissions.dart';

part 'permissions.freezed.dart';
part 'permissions.g.dart';

@freezed
abstract class Permissions with _$Permissions {
  const factory Permissions({
    required UsersAndGroupsPermissions view,
    required UsersAndGroupsPermissions change,
  }) = _Permissions;

  factory Permissions.fromJson(Map<String, dynamic> json) =>
      _$PermissionsFromJson(json);
}
