import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:paperless_mobile/api/models/actor.dart';

part 'log_entry.freezed.dart';
part 'log_entry.g.dart';

@Freezed(toJson: true, fromJson: true)
abstract class LogEntry with _$LogEntry {
  factory LogEntry({
    required int id,
    required DateTime timestamp,
    required String action,
    required Map<String, Object> changes,
    required Actor actor,
  }) = _LogEntry;

  factory LogEntry.fromJson(Map<String, dynamic> json) =>
      _$LogEntryFromJson(json);
}
