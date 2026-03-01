//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'basic_user.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class BasicUser {
  /// Returns a new [BasicUser] instance.
  BasicUser({
    required this.id,

    required this.username,

    this.firstName,

    this.lastName,
  });

  @JsonKey(name: r'id', required: true, includeIfNull: false)
  final int id;

  /// Required. 150 characters or fewer. Letters, digits and @/./+/-/_ only.
  @JsonKey(name: r'username', required: true, includeIfNull: false)
  final String username;

  @JsonKey(name: r'first_name', required: false, includeIfNull: false)
  final String? firstName;

  @JsonKey(name: r'last_name', required: false, includeIfNull: false)
  final String? lastName;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is BasicUser &&
            runtimeType == other.runtimeType &&
            equals(
              [id, username, firstName, lastName],
              [other.id, other.username, other.firstName, other.lastName],
            );
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      mapPropsToHashCode([id, username, firstName, lastName]);

  factory BasicUser.fromJson(Map<String, dynamic> json) =>
      _$BasicUserFromJson(json);

  Map<String, dynamic> toJson() => _$BasicUserToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
