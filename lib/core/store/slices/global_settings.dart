// ignore_for_file: invalid_annotation_target

import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:paperless_mobile/features/settings/model/color_scheme_option.dart';
import 'package:paperless_mobile/features/settings/model/file_download_type.dart';

part 'global_settings.freezed.dart';
part 'global_settings.g.dart';

@freezed
abstract class GlobalSettings with _$GlobalSettings {
  const factory GlobalSettings({
    required String preferredLocaleSubtag,
    @Default(ThemeMode.system)
    @JsonKey(fromJson: _themeModeFromJson, toJson: _themeModeToJson)
    @Default(ThemeMode.system)
    ThemeMode preferredThemeMode,
    @Default(ColorSchemeOption.classic)
    ColorSchemeOption preferredColorSchemeOption,
    @Default(true) bool showOnboarding,
    @Default(FileDownloadType.alwaysAsk) FileDownloadType defaultDownloadType,
    @Default(FileDownloadType.alwaysAsk) FileDownloadType defaultShareType,
    @Default(false) bool enforceSinglePagePdfUpload,
    @Default(false) bool skipDocumentPreprarationOnUpload,
    @Default(false) bool disableAnimations,
    @Default([]) List<String> knownHosts,
  }) = _GlobalSettings;

  factory GlobalSettings.fromJson(Map<String, dynamic> json) =>
      _$GlobalSettingsFromJson(json);
}

String _themeModeToJson(ThemeMode mode) {
  return mode.name;
}

ThemeMode _themeModeFromJson(String mode) {
  return ThemeMode.values.firstWhere(
    (e) => e.name == mode,
    orElse: () => ThemeMode.system,
  );
}
