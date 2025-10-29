//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:paperless_api/generated/lib/src/model/object_type_enum.dart';
import 'package:paperless_api/generated/lib/src/model/operation_enum.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'bulk_edit_objects_request.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class BulkEditObjectsRequest {
  /// Returns a new [BulkEditObjectsRequest] instance.
  BulkEditObjectsRequest({
    required this.objects,

    required this.objectType,

    required this.operation,

    this.owner,

    this.permissions,

    this.merge = false,
  });

  @JsonKey(name: r'objects', required: true, includeIfNull: false)
  final List<int> objects;

  @JsonKey(name: r'object_type', required: true, includeIfNull: false)
  final ObjectTypeEnum objectType;

  @JsonKey(name: r'operation', required: true, includeIfNull: false)
  final OperationEnum operation;

  @JsonKey(name: r'owner', required: false, includeIfNull: false)
  final int? owner;

  @JsonKey(name: r'permissions', required: false, includeIfNull: false)
  final Map<String, Object>? permissions;

  @JsonKey(
    defaultValue: false,
    name: r'merge',
    required: false,
    includeIfNull: false,
  )
  final bool? merge;

  bool operator ==(Object other) {
    return identical(this, other) ||
        other is BulkEditObjectsRequest &&
            runtimeType == other.runtimeType &&
            equals(
              [objects, objectType, operation, owner, permissions, merge],
              [
                other.objects,
                other.objectType,
                other.operation,
                other.owner,
                other.permissions,
                other.merge,
              ],
            );
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      mapPropsToHashCode([
        objects,
        objectType,
        operation,
        owner,
        permissions,
        merge,
      ]);

  factory BulkEditObjectsRequest.fromJson(Map<String, dynamic> json) =>
      _$BulkEditObjectsRequestFromJson(json);

  Map<String, dynamic> toJson() => _$BulkEditObjectsRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
