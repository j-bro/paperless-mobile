import 'package:freezed_annotation/freezed_annotation.dart';

part 'social_account.freezed.dart';
part 'social_account.g.dart';

@Freezed(toJson: true, fromJson: true)
abstract class SocialAccount with _$SocialAccount {
  factory SocialAccount({
    required int id,
    required String provider,
    required String name,
  }) = _SocialAccount;

  factory SocialAccount.fromJson(Map<String, dynamic> json) =>
      _$SocialAccountFromJson(json);
}
