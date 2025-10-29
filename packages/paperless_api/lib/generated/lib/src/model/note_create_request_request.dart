//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'note_create_request_request.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class NoteCreateRequestRequest {
  /// Returns a new [NoteCreateRequestRequest] instance.
  NoteCreateRequestRequest({required this.note});

  @JsonKey(name: r'note', required: true, includeIfNull: false)
  final String note;

  bool operator ==(Object other) {
    return identical(this, other) ||
        other is NoteCreateRequestRequest &&
            runtimeType == other.runtimeType &&
            equals([note], [other.note]);
  }

  @override
  int get hashCode => runtimeType.hashCode ^ mapPropsToHashCode([note]);

  factory NoteCreateRequestRequest.fromJson(Map<String, dynamic> json) =>
      _$NoteCreateRequestRequestFromJson(json);

  Map<String, dynamic> toJson() => _$NoteCreateRequestRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
