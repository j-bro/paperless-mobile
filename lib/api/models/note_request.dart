import 'package:freezed_annotation/freezed_annotation.dart';

part 'note_request.freezed.dart';
part 'note_request.g.dart';

@Freezed(toJson: true, fromJson: false)
abstract class NoteRequest with _$NoteRequest {
  factory NoteRequest({
    /// Note for the document
    String? note,
    DateTime? created,
  }) = _NoteRequest;
}
