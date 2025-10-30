//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'user_request.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class UserRequest {
  /// Returns a new [UserRequest] instance.
  UserRequest({
    required this.username,

    this.email,

    this.password,

    this.firstName,

    this.lastName,

    this.dateJoined,

    this.isStaff,

    this.isActive,

    this.isSuperuser,

    this.groups,

    this.userPermissions,
  });

  /// Required. 150 characters or fewer. Letters, digits and @/./+/-/_ only.
  @JsonKey(name: r'username', required: true, includeIfNull: false)
  final String username;

  @JsonKey(name: r'email', required: false, includeIfNull: false)
  final String? email;

  @JsonKey(name: r'password', required: false, includeIfNull: false)
  final String? password;

  @JsonKey(name: r'first_name', required: false, includeIfNull: false)
  final String? firstName;

  @JsonKey(name: r'last_name', required: false, includeIfNull: false)
  final String? lastName;

  @JsonKey(name: r'date_joined', required: false, includeIfNull: false)
  final DateTime? dateJoined;

  /// Designates whether the user can log into this admin site.
  @JsonKey(name: r'is_staff', required: false, includeIfNull: false)
  final bool? isStaff;

  /// Designates whether this user should be treated as active. Unselect this instead of deleting accounts.
  @JsonKey(name: r'is_active', required: false, includeIfNull: false)
  final bool? isActive;

  /// Designates that this user has all permissions without explicitly assigning them.
  @JsonKey(name: r'is_superuser', required: false, includeIfNull: false)
  final bool? isSuperuser;

  /// The groups this user belongs to. A user will get all permissions granted to each of their groups.
  @JsonKey(name: r'groups', required: false, includeIfNull: false)
  final List<int>? groups;

  @JsonKey(name: r'user_permissions', required: false, includeIfNull: false)
  final List<String>? userPermissions;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is UserRequest &&
            runtimeType == other.runtimeType &&
            equals(
              [
                username,
                email,
                password,
                firstName,
                lastName,
                dateJoined,
                isStaff,
                isActive,
                isSuperuser,
                groups,
                userPermissions,
              ],
              [
                other.username,
                other.email,
                other.password,
                other.firstName,
                other.lastName,
                other.dateJoined,
                other.isStaff,
                other.isActive,
                other.isSuperuser,
                other.groups,
                other.userPermissions,
              ],
            );
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      mapPropsToHashCode([
        username,
        email,
        password,
        firstName,
        lastName,
        dateJoined,
        isStaff,
        isActive,
        isSuperuser,
        groups,
        userPermissions,
      ]);

  factory UserRequest.fromJson(Map<String, dynamic> json) =>
      _$UserRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UserRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
