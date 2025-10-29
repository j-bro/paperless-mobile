//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'document_list_request.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class DocumentListRequest {
  /// Returns a new [DocumentListRequest] instance.
  DocumentListRequest({required this.documents});

  @JsonKey(name: r'documents', required: true, includeIfNull: false)
  final List<int> documents;

  bool operator ==(Object other) {
    return identical(this, other) ||
        other is DocumentListRequest &&
            runtimeType == other.runtimeType &&
            equals([documents], [other.documents]);
  }

  @override
  int get hashCode => runtimeType.hashCode ^ mapPropsToHashCode([documents]);

  factory DocumentListRequest.fromJson(Map<String, dynamic> json) =>
      _$DocumentListRequestFromJson(json);

  Map<String, dynamic> toJson() => _$DocumentListRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
