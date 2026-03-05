//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:paperless_mobile/api/models/migration_status.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'database.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class Database {
  /// Returns a new [Database] instance.
  Database({
    required this.type,

    required this.url,

    required this.status,

    required this.error,

    required this.migrationStatus,
  });

  @JsonKey(name: r'type', required: true, includeIfNull: false)
  final String type;

  @JsonKey(name: r'url', required: true, includeIfNull: false)
  final String url;

  @JsonKey(name: r'status', required: true, includeIfNull: false)
  final String status;

  @JsonKey(name: r'error', required: true, includeIfNull: false)
  final String error;

  @JsonKey(name: r'migration_status', required: true, includeIfNull: false)
  final MigrationStatus migrationStatus;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Database &&
            runtimeType == other.runtimeType &&
            equals(
              [type, url, status, error, migrationStatus],
              [
                other.type,
                other.url,
                other.status,
                other.error,
                other.migrationStatus,
              ],
            );
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      mapPropsToHashCode([type, url, status, error, migrationStatus]);

  factory Database.fromJson(Map<String, dynamic> json) =>
      _$DatabaseFromJson(json);

  Map<String, dynamic> toJson() => _$DatabaseToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
