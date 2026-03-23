import 'package:freezed_annotation/freezed_annotation.dart';

part 'note_create_request_request.freezed.dart';
part 'note_create_request_request.g.dart';

@Freezed(toJson: true, fromJson: false)
abstract class NoteCreateRequestRequest with _$NoteCreateRequestRequest {
  factory NoteCreateRequestRequest({required String note}) =
      _NoteCreateRequestRequest;
}
