import 'package:freezed_annotation/freezed_annotation.dart';

part 'basic_user_request.freezed.dart';
part 'basic_user_request.g.dart';

@Freezed(toJson: true, fromJson: false)
abstract class BasicUserRequest with _$BasicUserRequest {
  factory BasicUserRequest({
    /// Required. 150 characters or fewer. Letters, digits and @/./+/-/_ only.
    required String username,
    String? firstName,
    String? lastName,
  }) = _BasicUserRequest;
}
