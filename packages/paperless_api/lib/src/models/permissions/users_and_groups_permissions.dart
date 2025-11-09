import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce/hive.dart';
import 'package:paperless_api/paperless_api.dart';

part 'users_and_groups_permissions.freezed.dart';
part 'users_and_groups_permissions.g.dart';

@freezed
abstract class UsersAndGroupsPermissions with _$UsersAndGroupsPermissions {
  const factory UsersAndGroupsPermissions({
    @Default([]) List<int> users,
    @Default([]) List<int> groups,
  }) = _UsersAndGroupsPermissions;

  factory UsersAndGroupsPermissions.fromJson(Map<String, dynamic> json) =>
      _$UsersAndGroupsPermissionsFromJson(json);
}
