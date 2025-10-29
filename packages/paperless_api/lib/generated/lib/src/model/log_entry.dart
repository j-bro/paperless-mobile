//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:paperless_api/generated/lib/src/model/actor.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'log_entry.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class LogEntry {
  /// Returns a new [LogEntry] instance.
  LogEntry({
    required this.id,

    required this.timestamp,

    required this.action,

    required this.changes,

    required this.actor,
  });

  @JsonKey(name: r'id', required: true, includeIfNull: false)
  final int id;

  @JsonKey(name: r'timestamp', required: true, includeIfNull: false)
  final DateTime timestamp;

  @JsonKey(name: r'action', required: true, includeIfNull: false)
  final String action;

  @JsonKey(name: r'changes', required: true, includeIfNull: false)
  final Map<String, Object> changes;

  @JsonKey(name: r'actor', required: true, includeIfNull: false)
  final Actor actor;

  bool operator ==(Object other) {
    return identical(this, other) ||
        other is LogEntry &&
            runtimeType == other.runtimeType &&
            equals(
              [id, timestamp, action, changes, actor],
              [
                other.id,
                other.timestamp,
                other.action,
                other.changes,
                other.actor,
              ],
            );
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      mapPropsToHashCode([id, timestamp, action, changes, actor]);

  factory LogEntry.fromJson(Map<String, dynamic> json) =>
      _$LogEntryFromJson(json);

  Map<String, dynamic> toJson() => _$LogEntryToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
