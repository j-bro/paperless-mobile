//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'paperless_auth_token_request.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class PaperlessAuthTokenRequest {
  /// Returns a new [PaperlessAuthTokenRequest] instance.
  PaperlessAuthTokenRequest({
    required this.username,

    required this.password,

    this.code,
  });

  @JsonKey(name: r'username', required: true, includeIfNull: false)
  final String username;

  @JsonKey(name: r'password', required: true, includeIfNull: false)
  final String password;

  @JsonKey(name: r'code', required: false, includeIfNull: false)
  final String? code;

  bool operator ==(Object other) {
    return identical(this, other) ||
        other is PaperlessAuthTokenRequest &&
            runtimeType == other.runtimeType &&
            equals(
              [username, password, code],
              [other.username, other.password, other.code],
            );
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ mapPropsToHashCode([username, password, code]);

  factory PaperlessAuthTokenRequest.fromJson(Map<String, dynamic> json) =>
      _$PaperlessAuthTokenRequestFromJson(json);

  Map<String, dynamic> toJson() => _$PaperlessAuthTokenRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
