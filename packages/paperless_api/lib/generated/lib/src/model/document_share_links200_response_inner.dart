//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'document_share_links200_response_inner.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class DocumentShareLinks200ResponseInner {
  /// Returns a new [DocumentShareLinks200ResponseInner] instance.
  DocumentShareLinks200ResponseInner({
    this.id,

    this.created,

    this.expiration,

    this.slug,
  });

  @JsonKey(name: r'id', required: false, includeIfNull: false)
  final int? id;

  @JsonKey(name: r'created', required: false, includeIfNull: false)
  final DateTime? created;

  @JsonKey(name: r'expiration', required: false, includeIfNull: false)
  final DateTime? expiration;

  @JsonKey(name: r'slug', required: false, includeIfNull: false)
  final String? slug;

  bool operator ==(Object other) {
    return identical(this, other) ||
        other is DocumentShareLinks200ResponseInner &&
            runtimeType == other.runtimeType &&
            equals(
              [id, created, expiration, slug],
              [other.id, other.created, other.expiration, other.slug],
            );
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      mapPropsToHashCode([id, created, expiration, slug]);

  factory DocumentShareLinks200ResponseInner.fromJson(
    Map<String, dynamic> json,
  ) => _$DocumentShareLinks200ResponseInnerFromJson(json);

  Map<String, dynamic> toJson() =>
      _$DocumentShareLinks200ResponseInnerToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
