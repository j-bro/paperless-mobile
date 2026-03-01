//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:paperless_api/generated/lib/src/model/file_version_enum.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'share_link_request.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ShareLinkRequest {
  /// Returns a new [ShareLinkRequest] instance.
  ShareLinkRequest({this.expiration, this.document, this.fileVersion});

  @JsonKey(name: r'expiration', required: false, includeIfNull: false)
  final DateTime? expiration;

  @JsonKey(name: r'document', required: false, includeIfNull: false)
  final int? document;

  @JsonKey(name: r'file_version', required: false, includeIfNull: false)
  final FileVersionEnum? fileVersion;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is ShareLinkRequest &&
            runtimeType == other.runtimeType &&
            equals(
              [expiration, document, fileVersion],
              [other.expiration, other.document, other.fileVersion],
            );
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      mapPropsToHashCode([expiration, document, fileVersion]);

  factory ShareLinkRequest.fromJson(Map<String, dynamic> json) =>
      _$ShareLinkRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ShareLinkRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
