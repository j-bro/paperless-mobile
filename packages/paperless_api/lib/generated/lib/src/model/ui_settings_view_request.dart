//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'ui_settings_view_request.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class UiSettingsViewRequest {
  /// Returns a new [UiSettingsViewRequest] instance.
  UiSettingsViewRequest({this.settings});

  @JsonKey(name: r'settings', required: false, includeIfNull: false)
  final Map<String, Object>? settings;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is UiSettingsViewRequest &&
            runtimeType == other.runtimeType &&
            equals([settings], [other.settings]);
  }

  @override
  int get hashCode => runtimeType.hashCode ^ mapPropsToHashCode([settings]);

  factory UiSettingsViewRequest.fromJson(Map<String, dynamic> json) =>
      _$UiSettingsViewRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UiSettingsViewRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
