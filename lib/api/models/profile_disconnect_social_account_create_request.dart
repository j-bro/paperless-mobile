import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_disconnect_social_account_create_request.freezed.dart';
part 'profile_disconnect_social_account_create_request.g.dart';

@Freezed(toJson: true, fromJson: false)
abstract class ProfileDisconnectSocialAccountCreateRequest
    with _$ProfileDisconnectSocialAccountCreateRequest {
  factory ProfileDisconnectSocialAccountCreateRequest({required int id}) =
      _ProfileDisconnectSocialAccountCreateRequest;
}
