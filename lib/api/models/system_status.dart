import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:paperless_mobile/api/models/classifier.dart';
import 'package:paperless_mobile/api/models/database.dart';
import 'package:paperless_mobile/api/models/index.dart';
import 'package:paperless_mobile/api/models/sanity_check.dart';
import 'package:paperless_mobile/api/models/storage.dart';
import 'package:paperless_mobile/api/models/tasks.dart';

part 'system_status.freezed.dart';
part 'system_status.g.dart';

@Freezed(toJson: false, fromJson: true)
abstract class SystemStatus with _$SystemStatus {
  factory SystemStatus({
    required String pngxVersion,
    required String serverOs,
    required String installType,
    required Storage storage,
    required Database database,
    required Tasks tasks,
    required Index index,
    required Classifier classifier,
    required SanityCheck sanityCheck,
  }) = _SystemStatus;

  factory SystemStatus.fromJson(Map<String, dynamic> json) =>
      _$SystemStatusFromJson(json);
}
