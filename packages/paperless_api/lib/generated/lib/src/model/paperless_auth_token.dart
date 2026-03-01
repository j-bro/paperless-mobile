//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'paperless_auth_token.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class PaperlessAuthToken {
  /// Returns a new [PaperlessAuthToken] instance.
  PaperlessAuthToken({required this.token});

  @JsonKey(name: r'token', required: true, includeIfNull: false)
  final String token;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is PaperlessAuthToken &&
            runtimeType == other.runtimeType &&
            equals([token], [other.token]);
  }

  @override
  int get hashCode => runtimeType.hashCode ^ mapPropsToHashCode([token]);

  factory PaperlessAuthToken.fromJson(Map<String, dynamic> json) =>
      _$PaperlessAuthTokenFromJson(json);

  Map<String, dynamic> toJson() => _$PaperlessAuthTokenToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
