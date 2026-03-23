import 'package:freezed_annotation/freezed_annotation.dart';

part 'social_account_request.freezed.dart';
part 'social_account_request.g.dart';

@Freezed(toJson: true, fromJson: false)
abstract class SocialAccountRequest with _$SocialAccountRequest {
  factory SocialAccountRequest({required String provider}) =
      _SocialAccountRequest;
}
