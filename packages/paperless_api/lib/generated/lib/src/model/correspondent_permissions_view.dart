//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'correspondent_permissions_view.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class CorrespondentPermissionsView {
  /// Returns a new [CorrespondentPermissionsView] instance.
  CorrespondentPermissionsView({this.users, this.groups});

  @JsonKey(name: r'users', required: false, includeIfNull: false)
  final List<int>? users;

  @JsonKey(name: r'groups', required: false, includeIfNull: false)
  final List<int>? groups;

  bool operator ==(Object other) {
    return identical(this, other) ||
        other is CorrespondentPermissionsView &&
            runtimeType == other.runtimeType &&
            equals([users, groups], [other.users, other.groups]);
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ mapPropsToHashCode([users, groups]);

  factory CorrespondentPermissionsView.fromJson(Map<String, dynamic> json) =>
      _$CorrespondentPermissionsViewFromJson(json);

  Map<String, dynamic> toJson() => _$CorrespondentPermissionsViewToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
