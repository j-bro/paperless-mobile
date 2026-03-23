import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:paperless_mobile/api/models/migration_status.dart';

part 'database.freezed.dart';
part 'database.g.dart';

@Freezed(toJson: false, fromJson: true)
abstract class Database with _$Database {
  factory Database({
    required String type,
    required String url,
    required String status,
    required String error,
    required MigrationStatus migrationStatus,
  }) = _Database;

  factory Database.fromJson(Map<String, dynamic> json) =>
      _$DatabaseFromJson(json);
}
