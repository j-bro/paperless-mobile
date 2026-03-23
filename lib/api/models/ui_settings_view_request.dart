import 'package:freezed_annotation/freezed_annotation.dart';

part 'ui_settings_view_request.freezed.dart';
part 'ui_settings_view_request.g.dart';

@Freezed(toJson: true, fromJson: false)
abstract class UiSettingsViewRequest with _$UiSettingsViewRequest {
  factory UiSettingsViewRequest({Map<String, Object>? settings}) =
      _UiSettingsViewRequest;
}
