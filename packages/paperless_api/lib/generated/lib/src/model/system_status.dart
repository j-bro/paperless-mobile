//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:paperless_api/generated/lib/src/model/sanity_check.dart';
import 'package:paperless_api/generated/lib/src/model/storage.dart';
import 'package:paperless_api/generated/lib/src/model/index.dart';
import 'package:paperless_api/generated/lib/src/model/classifier.dart';
import 'package:paperless_api/generated/lib/src/model/tasks.dart';
import 'package:paperless_api/generated/lib/src/model/database.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'system_status.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class SystemStatus {
  /// Returns a new [SystemStatus] instance.
  SystemStatus({
    required this.pngxVersion,

    required this.serverOs,

    required this.installType,

    required this.storage,

    required this.database,

    required this.tasks,

    required this.index,

    required this.classifier,

    required this.sanityCheck,
  });

  @JsonKey(name: r'pngx_version', required: true, includeIfNull: false)
  final String pngxVersion;

  @JsonKey(name: r'server_os', required: true, includeIfNull: false)
  final String serverOs;

  @JsonKey(name: r'install_type', required: true, includeIfNull: false)
  final String installType;

  @JsonKey(name: r'storage', required: true, includeIfNull: false)
  final Storage storage;

  @JsonKey(name: r'database', required: true, includeIfNull: false)
  final Database database;

  @JsonKey(name: r'tasks', required: true, includeIfNull: false)
  final Tasks tasks;

  @JsonKey(name: r'index', required: true, includeIfNull: false)
  final Index index;

  @JsonKey(name: r'classifier', required: true, includeIfNull: false)
  final Classifier classifier;

  @JsonKey(name: r'sanity_check', required: true, includeIfNull: false)
  final SanityCheck sanityCheck;

  bool operator ==(Object other) {
    return identical(this, other) ||
        other is SystemStatus &&
            runtimeType == other.runtimeType &&
            equals(
              [
                pngxVersion,
                serverOs,
                installType,
                storage,
                database,
                tasks,
                index,
                classifier,
                sanityCheck,
              ],
              [
                other.pngxVersion,
                other.serverOs,
                other.installType,
                other.storage,
                other.database,
                other.tasks,
                other.index,
                other.classifier,
                other.sanityCheck,
              ],
            );
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      mapPropsToHashCode([
        pngxVersion,
        serverOs,
        installType,
        storage,
        database,
        tasks,
        index,
        classifier,
        sanityCheck,
      ]);

  factory SystemStatus.fromJson(Map<String, dynamic> json) =>
      _$SystemStatusFromJson(json);

  Map<String, dynamic> toJson() => _$SystemStatusToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
