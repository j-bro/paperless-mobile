import 'package:freezed_annotation/freezed_annotation.dart';

part 'ui_settings_view_user.freezed.dart';
part 'ui_settings_view_user.g.dart';

@Freezed(toJson: true, fromJson: true)
abstract class UiSettingsViewUser with _$UiSettingsViewUser {
  factory UiSettingsViewUser({
    required int? id,
    required String username,
    String? firstName,
    String? lastName,
    List<int>? groups,
    bool? isStaff,
    bool? isSuperuser,
  }) = _UiSettingsViewUser;

  factory UiSettingsViewUser.fromJson(Map<String, dynamic> json) =>
      _$UiSettingsViewUserFromJson(json);
}
