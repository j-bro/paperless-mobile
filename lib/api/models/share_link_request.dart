import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:paperless_mobile/api/models/file_version_enum.dart';

part 'share_link_request.freezed.dart';
part 'share_link_request.g.dart';

@Freezed(toJson: true, fromJson: false)
abstract class ShareLinkRequest with _$ShareLinkRequest {
  factory ShareLinkRequest({
    DateTime? expiration,
    int? document,
    FileVersionEnum? fileVersion,
  }) = _ShareLinkRequest;
}
