import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:paperless_mobile/api/utils/patched_value.dart';

part 'patched_user_request.g.dart';

@JsonSerializable(
  createFactory: false,
  createToJson: true,
  includeIfNull: false,
)
class PatchedUserRequest {
  /// Required. 150 characters or fewer. Letters, digits and @/./+/-/_ only.
  final PatchedValue<String?>? username;
  final PatchedValue<String?>? email;
  final PatchedValue<String?>? password;
  final PatchedValue<String?>? firstName;
  final PatchedValue<String?>? lastName;
  final PatchedValue<DateTime?>? dateJoined;

  /// Designates whether the user can log into this admin site.
  final PatchedValue<bool?>? isStaff;

  /// Designates whether this user should be treated as active. Unselect this instead of deleting accounts.
  final PatchedValue<bool?>? isActive;

  /// Designates that this user has all permissions without explicitly assigning them.
  final PatchedValue<bool?>? isSuperuser;

  /// The groups this user belongs to. A user will get all permissions granted to each of their groups.
  final PatchedValue<List<int>?>? groups;
  final PatchedValue<List<String>?>? userPermissions;

  PatchedUserRequest({
    this.username,
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

  Map<String, dynamic> toJson() =>
      processPatchedValueJson(_$PatchedUserRequestToJson(this));
}
