//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'actor.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class Actor {
  /// Returns a new [Actor] instance.
  Actor({required this.id, required this.username});

  @JsonKey(name: r'id', required: true, includeIfNull: false)
  final int id;

  @JsonKey(name: r'username', required: true, includeIfNull: false)
  final String username;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Actor &&
            runtimeType == other.runtimeType &&
            equals([id, username], [other.id, other.username]);
  }

  @override
  int get hashCode => runtimeType.hashCode ^ mapPropsToHashCode([id, username]);

  factory Actor.fromJson(Map<String, dynamic> json) => _$ActorFromJson(json);

  Map<String, dynamic> toJson() => _$ActorToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
