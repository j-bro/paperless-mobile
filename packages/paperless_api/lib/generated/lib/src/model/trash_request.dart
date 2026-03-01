//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:paperless_api/generated/lib/src/model/trash_action_enum.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'trash_request.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class TrashRequest {
  /// Returns a new [TrashRequest] instance.
  TrashRequest({this.documents, required this.action});

  @JsonKey(name: r'documents', required: false, includeIfNull: false)
  final List<int>? documents;

  @JsonKey(name: r'action', required: true, includeIfNull: false)
  final TrashActionEnum action;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is TrashRequest &&
            runtimeType == other.runtimeType &&
            equals([documents, action], [other.documents, other.action]);
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ mapPropsToHashCode([documents, action]);

  factory TrashRequest.fromJson(Map<String, dynamic> json) =>
      _$TrashRequestFromJson(json);

  Map<String, dynamic> toJson() => _$TrashRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
