//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'migration_status.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class MigrationStatus {
  /// Returns a new [MigrationStatus] instance.
  MigrationStatus({
    required this.latestMigration,

    required this.unappliedMigrations,
  });

  @JsonKey(name: r'latest_migration', required: true, includeIfNull: false)
  final String latestMigration;

  @JsonKey(name: r'unapplied_migrations', required: true, includeIfNull: false)
  final List<String> unappliedMigrations;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is MigrationStatus &&
            runtimeType == other.runtimeType &&
            equals(
              [latestMigration, unappliedMigrations],
              [other.latestMigration, other.unappliedMigrations],
            );
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      mapPropsToHashCode([latestMigration, unappliedMigrations]);

  factory MigrationStatus.fromJson(Map<String, dynamic> json) =>
      _$MigrationStatusFromJson(json);

  Map<String, dynamic> toJson() => _$MigrationStatusToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
