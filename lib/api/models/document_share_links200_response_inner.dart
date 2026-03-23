import 'package:freezed_annotation/freezed_annotation.dart';

part 'document_share_links200_response_inner.freezed.dart';
part 'document_share_links200_response_inner.g.dart';

@Freezed(toJson: false, fromJson: true)
abstract class DocumentShareLinks200ResponseInner
    with _$DocumentShareLinks200ResponseInner {
  factory DocumentShareLinks200ResponseInner({
    int? id,
    DateTime? created,
    DateTime? expiration,
    String? slug,
  }) = _DocumentShareLinks200ResponseInner;

  factory DocumentShareLinks200ResponseInner.fromJson(
    Map<String, dynamic> json,
  ) => _$DocumentShareLinks200ResponseInnerFromJson(json);
}
