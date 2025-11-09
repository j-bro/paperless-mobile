import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:paperless_api/generated/lib/src/model/user.dart';

part 'local_user_account.freezed.dart';
part 'local_user_account.g.dart';

@freezed
abstract class LocalUserAccount with _$LocalUserAccount {
  const factory LocalUserAccount({
    required String serverUrl,
    required User paperlessUser,
    required int apiVersion,
  }) = _LocalUserAccount;

  factory LocalUserAccount.fromJson(Map<String, dynamic> json) =>
      _$LocalUserAccountFromJson(json);
}
