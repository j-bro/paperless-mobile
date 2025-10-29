//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'ui_settings_view_user.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class UiSettingsViewUser {
  /// Returns a new [UiSettingsViewUser] instance.
  UiSettingsViewUser({
    this.id,

    this.username,

    this.firstName,

    this.lastName,

    this.groups,

    this.isStaff,

    this.isSuperuser,
  });

  @JsonKey(name: r'id', required: false, includeIfNull: false)
  final int? id;

  @JsonKey(name: r'username', required: false, includeIfNull: false)
  final String? username;

  @JsonKey(name: r'first_name', required: false, includeIfNull: false)
  final String? firstName;

  @JsonKey(name: r'last_name', required: false, includeIfNull: false)
  final String? lastName;

  @JsonKey(name: r'groups', required: false, includeIfNull: false)
  final List<int>? groups;

  @JsonKey(name: r'is_staff', required: false, includeIfNull: false)
  final bool? isStaff;

  @JsonKey(name: r'is_superuser', required: false, includeIfNull: false)
  final bool? isSuperuser;

  bool operator ==(Object other) {
    return identical(this, other) ||
        other is UiSettingsViewUser &&
            runtimeType == other.runtimeType &&
            equals(
              [id, username, firstName, lastName, groups, isStaff, isSuperuser],
              [
                other.id,
                other.username,
                other.firstName,
                other.lastName,
                other.groups,
                other.isStaff,
                other.isSuperuser,
              ],
            );
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      mapPropsToHashCode([
        id,
        username,
        firstName,
        lastName,
        groups,
        isStaff,
        isSuperuser,
      ]);

  factory UiSettingsViewUser.fromJson(Map<String, dynamic> json) =>
      _$UiSettingsViewUserFromJson(json);

  Map<String, dynamic> toJson() => _$UiSettingsViewUserToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
