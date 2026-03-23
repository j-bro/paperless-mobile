import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@Freezed(toJson: true, fromJson: true)
abstract class User with _$User {
  factory User({
    required int id,

    /// Required. 150 characters or fewer. Letters, digits and @/./+/-/_ only.
    required String username,
    String? email,
    String? password,
    String? firstName,
    String? lastName,
    DateTime? dateJoined,

    /// Designates whether the user can log into this admin site.
    bool? isStaff,

    /// Designates whether this user should be treated as active. Unselect this instead of deleting accounts.
    bool? isActive,

    /// Designates that this user has all permissions without explicitly assigning them.
    bool? isSuperuser,

    /// The groups this user belongs to. A user will get all permissions granted to each of their groups.
    List<int>? groups,
    List<String>? userPermissions,
    required List<String> inheritedPermissions,
    required bool isMfaEnabled,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
