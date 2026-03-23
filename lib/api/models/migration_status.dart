import 'package:freezed_annotation/freezed_annotation.dart';

part 'migration_status.freezed.dart';
part 'migration_status.g.dart';

@Freezed(toJson: false, fromJson: true)
abstract class MigrationStatus with _$MigrationStatus {
  factory MigrationStatus({
    required String latestMigration,
    required List<String> unappliedMigrations,
  }) = _MigrationStatus;

  factory MigrationStatus.fromJson(Map<String, dynamic> json) =>
      _$MigrationStatusFromJson(json);
}
