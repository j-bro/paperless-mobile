import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:paperless_mobile/api/models/file_version_enum.dart';
import 'package:paperless_mobile/api/utils/patched_value.dart';

part 'patched_share_link_request.g.dart';

@JsonSerializable(
  createFactory: false,
  createToJson: true,
  includeIfNull: false,
)
class PatchedShareLinkRequest {
  final PatchedValue<DateTime?>? expiration;
  final PatchedValue<int?>? document;
  final PatchedValue<FileVersionEnum?>? fileVersion;

  PatchedShareLinkRequest({this.expiration, this.document, this.fileVersion});

  Map<String, dynamic> toJson() =>
      processPatchedValueJson(_$PatchedShareLinkRequestToJson(this));
}
