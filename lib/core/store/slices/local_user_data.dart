import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:paperless_mobile/core/store/slices/local_user_account.dart';
import 'package:paperless_mobile/core/store/slices/local_user_app_state.dart';

part 'local_user_data.freezed.dart';
part 'local_user_data.g.dart';

@freezed
abstract class LocalUserData with _$LocalUserData {
  const factory LocalUserData({
    required String userId,
    required LocalUserAccount remoteUser,
    @Default(false) bool isBiometricAuthenticationEnabled,
    @Default(LocalUserAppState()) LocalUserAppState? appState,
  }) = _UserSettings;

  factory LocalUserData.fromJson(Map<String, dynamic> json) =>
      _$LocalUserDataFromJson(json);
}
