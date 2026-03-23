import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:paperless_mobile/api/models/ui_settings_view_settings_update_checking.dart';

part 'ui_settings_view_settings.freezed.dart';
part 'ui_settings_view_settings.g.dart';

@Freezed(toJson: true, fromJson: true)
abstract class UiSettingsViewSettings with _$UiSettingsViewSettings {
  factory UiSettingsViewSettings({
    String? version,
    String? appLogo,
    String? appTitle,
    int? trashDelay,
    bool? emailEnabled,
    bool? tourComplete,
    UiSettingsViewSettingsUpdateChecking? updateChecking,
    bool? auditlogEnabled,
  }) = _UiSettingsViewSettings;

  factory UiSettingsViewSettings.fromJson(Map<String, dynamic> json) =>
      _$UiSettingsViewSettingsFromJson(json);
}
