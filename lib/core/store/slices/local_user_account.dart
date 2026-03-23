import 'package:paperless_mobile/core/store/slices/user_profile.dart';

class LocalUserAccount {
  final String appUserId;
  final String serverUrl;
  final int apiVersion;
  final UserProfile profile;

  LocalUserAccount({
    required this.appUserId,
    required this.serverUrl,
    required this.apiVersion,
    required this.profile,
  });

  String get displayName {
    final firstName = profile.profile.firstName ?? '';
    final lastName = profile.profile.lastName ?? '';
    final fullName = '$firstName $lastName'.trim();
    return fullName.isNotEmpty ? fullName : profile.uiSettings.user.username;
  }
}
