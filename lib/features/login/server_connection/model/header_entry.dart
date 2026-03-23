// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'header_entry.g.dart';
part 'header_entry.freezed.dart';

@freezed
abstract class HeaderEntry with _$HeaderEntry {
  factory HeaderEntry({
    required String key,
    required String value,
    @Default(true) bool enabled,
  }) = _HeaderEntry;

  factory HeaderEntry.fromJson(Map<String, dynamic> json) =>
      _$HeaderEntryFromJson(json);
}
