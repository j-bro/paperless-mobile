//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'ui_settings_view_settings_update_checking.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class UiSettingsViewSettingsUpdateChecking {
  /// Returns a new [UiSettingsViewSettingsUpdateChecking] instance.
  UiSettingsViewSettingsUpdateChecking({this.backendSetting});

  @JsonKey(name: r'backend_setting', required: false, includeIfNull: false)
  final String? backendSetting;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is UiSettingsViewSettingsUpdateChecking &&
            runtimeType == other.runtimeType &&
            equals([backendSetting], [other.backendSetting]);
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ mapPropsToHashCode([backendSetting]);

  factory UiSettingsViewSettingsUpdateChecking.fromJson(
    Map<String, dynamic> json,
  ) => _$UiSettingsViewSettingsUpdateCheckingFromJson(json);

  Map<String, dynamic> toJson() =>
      _$UiSettingsViewSettingsUpdateCheckingToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
