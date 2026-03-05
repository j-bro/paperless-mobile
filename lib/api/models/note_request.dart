//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'note_request.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class NoteRequest {
  /// Returns a new [NoteRequest] instance.
  NoteRequest({this.note, this.created});

  /// Note for the document
  @JsonKey(name: r'note', required: false, includeIfNull: false)
  final String? note;

  @JsonKey(name: r'created', required: false, includeIfNull: false)
  final DateTime? created;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is NoteRequest &&
            runtimeType == other.runtimeType &&
            equals([note, created], [other.note, other.created]);
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ mapPropsToHashCode([note, created]);

  factory NoteRequest.fromJson(Map<String, dynamic> json) =>
      _$NoteRequestFromJson(json);

  Map<String, dynamic> toJson() => _$NoteRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
