//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'social_account.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class SocialAccount {
  /// Returns a new [SocialAccount] instance.
  SocialAccount({required this.id, required this.provider, required this.name});

  @JsonKey(name: r'id', required: true, includeIfNull: false)
  final int id;

  @JsonKey(name: r'provider', required: true, includeIfNull: false)
  final String provider;

  @JsonKey(name: r'name', required: true, includeIfNull: false)
  final String name;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is SocialAccount &&
            runtimeType == other.runtimeType &&
            equals(
              [id, provider, name],
              [other.id, other.provider, other.name],
            );
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ mapPropsToHashCode([id, provider, name]);

  factory SocialAccount.fromJson(Map<String, dynamic> json) =>
      _$SocialAccountFromJson(json);

  Map<String, dynamic> toJson() => _$SocialAccountToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
