//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'sanity_check.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class SanityCheck {
  /// Returns a new [SanityCheck] instance.
  SanityCheck({
    required this.status,

    required this.error,

    required this.lastRun,
  });

  @JsonKey(name: r'status', required: true, includeIfNull: false)
  final String status;

  @JsonKey(name: r'error', required: true, includeIfNull: false)
  final String error;

  @JsonKey(name: r'last_run', required: true, includeIfNull: false)
  final DateTime lastRun;

  bool operator ==(Object other) {
    return identical(this, other) ||
        other is SanityCheck &&
            runtimeType == other.runtimeType &&
            equals(
              [status, error, lastRun],
              [other.status, other.error, other.lastRun],
            );
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ mapPropsToHashCode([status, error, lastRun]);

  factory SanityCheck.fromJson(Map<String, dynamic> json) =>
      _$SanityCheckFromJson(json);

  Map<String, dynamic> toJson() => _$SanityCheckToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
