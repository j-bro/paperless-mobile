import 'dart:convert';
import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'client_certificate.freezed.dart';
part 'client_certificate.g.dart';

@freezed
abstract class ClientCertificate with _$ClientCertificate {
  factory ClientCertificate({
    // ignore: invalid_annotation_target
    @JsonKey(fromJson: base64Decode, toJson: base64Encode)
    required Uint8List bytes,
    required String filename,
    String? passphrase,
  }) = _ClientCertificate;

  factory ClientCertificate.fromJson(Map<String, dynamic> json) =>
      _$ClientCertificateFromJson(json);
}
