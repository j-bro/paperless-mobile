//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'tasks.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class Tasks {
  /// Returns a new [Tasks] instance.
  Tasks({
    required this.redisUrl,

    required this.redisStatus,

    required this.redisError,

    required this.celeryStatus,
  });

  @JsonKey(name: r'redis_url', required: true, includeIfNull: false)
  final String redisUrl;

  @JsonKey(name: r'redis_status', required: true, includeIfNull: false)
  final String redisStatus;

  @JsonKey(name: r'redis_error', required: true, includeIfNull: false)
  final String redisError;

  @JsonKey(name: r'celery_status', required: true, includeIfNull: false)
  final String celeryStatus;

  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Tasks &&
            runtimeType == other.runtimeType &&
            equals(
              [redisUrl, redisStatus, redisError, celeryStatus],
              [
                other.redisUrl,
                other.redisStatus,
                other.redisError,
                other.celeryStatus,
              ],
            );
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      mapPropsToHashCode([redisUrl, redisStatus, redisError, celeryStatus]);

  factory Tasks.fromJson(Map<String, dynamic> json) => _$TasksFromJson(json);

  Map<String, dynamic> toJson() => _$TasksToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
