import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_totp_create_request.freezed.dart';
part 'profile_totp_create_request.g.dart';

@Freezed(toJson: true, fromJson: false)
abstract class ProfileTotpCreateRequest with _$ProfileTotpCreateRequest {
  factory ProfileTotpCreateRequest({
    required String secret,
    required String code,
  }) = _ProfileTotpCreateRequest;
}
