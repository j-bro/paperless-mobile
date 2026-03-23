import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:paperless_mobile/api/models/social_account.dart';

part 'profile.freezed.dart';
part 'profile.g.dart';

@Freezed(toJson: true, fromJson: true)
abstract class Profile with _$Profile {
  factory Profile({
    String? email,
    String? password,
    String? firstName,
    String? lastName,
    String? authToken,
    bool? hasUsablePassword,
    List<SocialAccount>? socialAccounts,
    bool? isMfaEnabled,
  }) = _Profile;

  factory Profile.fromJson(Map<String, dynamic> json) =>
      _$ProfileFromJson(json);
}
