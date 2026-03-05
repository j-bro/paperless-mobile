//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:paperless_mobile/api/models/correspondent_permissions_view.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'document_permissions.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class DocumentPermissions {
  /// Returns a new [DocumentPermissions] instance.
  DocumentPermissions({this.view, this.change});

  @JsonKey(name: r'view', required: false, includeIfNull: false)
  final CorrespondentPermissionsView? view;

  @JsonKey(name: r'change', required: false, includeIfNull: false)
  final CorrespondentPermissionsView? change;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is DocumentPermissions &&
            runtimeType == other.runtimeType &&
            equals([view, change], [other.view, other.change]);
  }

  @override
  int get hashCode => runtimeType.hashCode ^ mapPropsToHashCode([view, change]);

  factory DocumentPermissions.fromJson(Map<String, dynamic> json) =>
      _$DocumentPermissionsFromJson(json);

  Map<String, dynamic> toJson() => _$DocumentPermissionsToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
