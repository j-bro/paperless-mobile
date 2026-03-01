import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'set_permissions.g.dart';

@JsonSerializable(includeIfNull: false)
class SetPermissions with EquatableMixin {
  final SetPermissionsScope? view;
  final SetPermissionsScope? change;

  SetPermissions({required this.view, required this.change});

  factory SetPermissions.fromJson(Map<String, dynamic> json) =>
      _$SetPermissionsFromJson(json);
  Map<String, dynamic> toJson() => _$SetPermissionsToJson(this);

  @override
  List<Object?> get props => [view, change];
}

@JsonSerializable()
class SetPermissionsScope with EquatableMixin {
  final List<int> users;
  final List<int> groups;

  SetPermissionsScope({this.users = const [], this.groups = const []});

  factory SetPermissionsScope.fromJson(Map<String, dynamic> json) =>
      _$SetPermissionsScopeFromJson(json);
  Map<String, dynamic> toJson() => _$SetPermissionsScopeToJson(this);

  @override
  List<Object?> get props => [users, groups];
}
