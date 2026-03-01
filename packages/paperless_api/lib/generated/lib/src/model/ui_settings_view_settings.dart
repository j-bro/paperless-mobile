//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:paperless_api/generated/lib/src/model/ui_settings_view_settings_update_checking.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'ui_settings_view_settings.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class UiSettingsViewSettings {
  /// Returns a new [UiSettingsViewSettings] instance.
  UiSettingsViewSettings({
    this.version,

    this.appLogo,

    this.appTitle,

    this.trashDelay,

    this.emailEnabled,

    this.tourComplete,

    this.updateChecking,

    this.auditlogEnabled,
  });

  @JsonKey(name: r'version', required: false, includeIfNull: false)
  final String? version;

  @JsonKey(name: r'app_logo', required: false, includeIfNull: false)
  final String? appLogo;

  @JsonKey(name: r'app_title', required: false, includeIfNull: false)
  final String? appTitle;

  @JsonKey(name: r'trash_delay', required: false, includeIfNull: false)
  final int? trashDelay;

  @JsonKey(name: r'email_enabled', required: false, includeIfNull: false)
  final bool? emailEnabled;

  @JsonKey(name: r'tour_complete', required: false, includeIfNull: false)
  final bool? tourComplete;

  @JsonKey(name: r'update_checking', required: false, includeIfNull: false)
  final UiSettingsViewSettingsUpdateChecking? updateChecking;

  @JsonKey(name: r'auditlog_enabled', required: false, includeIfNull: false)
  final bool? auditlogEnabled;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is UiSettingsViewSettings &&
            runtimeType == other.runtimeType &&
            equals(
              [
                version,
                appLogo,
                appTitle,
                trashDelay,
                emailEnabled,
                tourComplete,
                updateChecking,
                auditlogEnabled,
              ],
              [
                other.version,
                other.appLogo,
                other.appTitle,
                other.trashDelay,
                other.emailEnabled,
                other.tourComplete,
                other.updateChecking,
                other.auditlogEnabled,
              ],
            );
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      mapPropsToHashCode([
        version,
        appLogo,
        appTitle,
        trashDelay,
        emailEnabled,
        tourComplete,
        updateChecking,
        auditlogEnabled,
      ]);

  factory UiSettingsViewSettings.fromJson(Map<String, dynamic> json) =>
      _$UiSettingsViewSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$UiSettingsViewSettingsToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
