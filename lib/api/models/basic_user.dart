import 'package:freezed_annotation/freezed_annotation.dart';

part 'basic_user.freezed.dart';
part 'basic_user.g.dart';

@Freezed(toJson: true, fromJson: true)
abstract class BasicUser with _$BasicUser {
  factory BasicUser({
    required int id,

    /// Required. 150 characters or fewer. Letters, digits and @/./+/-/_ only.
    required String username,
    String? firstName,
    String? lastName,
  }) = _BasicUser;

  factory BasicUser.fromJson(Map<String, dynamic> json) =>
      _$BasicUserFromJson(json);
}
