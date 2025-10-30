//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:paperless_api/generated/lib/src/model/basic_user.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'notes.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class Notes {
  /// Returns a new [Notes] instance.
  Notes({required this.id, this.note, this.created, required this.user});

  @JsonKey(name: r'id', required: true, includeIfNull: false)
  final int id;

  /// Note for the document
  @JsonKey(name: r'note', required: false, includeIfNull: false)
  final String? note;

  @JsonKey(name: r'created', required: false, includeIfNull: false)
  final DateTime? created;

  @JsonKey(name: r'user', required: true, includeIfNull: false)
  final BasicUser user;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Notes &&
            runtimeType == other.runtimeType &&
            equals(
              [id, note, created, user],
              [other.id, other.note, other.created, other.user],
            );
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ mapPropsToHashCode([id, note, created, user]);

  factory Notes.fromJson(Map<String, dynamic> json) => _$NotesFromJson(json);

  Map<String, dynamic> toJson() => _$NotesToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
