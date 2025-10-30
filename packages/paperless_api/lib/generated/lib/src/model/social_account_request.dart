//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'social_account_request.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class SocialAccountRequest {
  /// Returns a new [SocialAccountRequest] instance.
  SocialAccountRequest({required this.provider});

  @JsonKey(name: r'provider', required: true, includeIfNull: false)
  final String provider;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is SocialAccountRequest &&
            runtimeType == other.runtimeType &&
            equals([provider], [other.provider]);
  }

  @override
  int get hashCode => runtimeType.hashCode ^ mapPropsToHashCode([provider]);

  factory SocialAccountRequest.fromJson(Map<String, dynamic> json) =>
      _$SocialAccountRequestFromJson(json);

  Map<String, dynamic> toJson() => _$SocialAccountRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
