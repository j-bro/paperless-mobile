import 'package:freezed_annotation/freezed_annotation.dart';

part 'ui_settings_view_settings_update_checking.freezed.dart';
part 'ui_settings_view_settings_update_checking.g.dart';

@Freezed(toJson: true, fromJson: true)
abstract class UiSettingsViewSettingsUpdateChecking
    with _$UiSettingsViewSettingsUpdateChecking {
  factory UiSettingsViewSettingsUpdateChecking({
    /// This is dynamic because the backend can return either a string or a boolean due to a deprecated setting.
    dynamic backendSetting,
  }) = _UiSettingsViewSettingsUpdateChecking;

  factory UiSettingsViewSettingsUpdateChecking.fromJson(
    Map<String, dynamic> json,
  ) => _$UiSettingsViewSettingsUpdateCheckingFromJson(json);
}
