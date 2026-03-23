import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:paperless_mobile/api/models/basic_user.dart';

part 'note.freezed.dart';
part 'note.g.dart';

@Freezed(toJson: true, fromJson: true)
abstract class Note with _$Note {
  factory Note({
    required int id,

    /// Note for the document
    String? note,
    DateTime? created,
    required BasicUser user,
  }) = _Note;

  factory Note.fromJson(Map<String, dynamic> json) => _$NoteFromJson(json);
}
