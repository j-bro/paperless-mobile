import 'package:paperless_mobile/api/paperless_api.dart';

class UserProfile {
  final Profile profile;
  final UiSettingsView uiSettings;

  const UserProfile({required this.profile, required this.uiSettings});

  int get id => uiSettings.user.id!;
}
