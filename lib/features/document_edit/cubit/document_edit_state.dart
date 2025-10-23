part of 'document_edit_cubit.dart';

@freezed
abstract class DocumentEditState with _$DocumentEditState {
  const factory DocumentEditState({
    required DocumentModel document,
    FieldSuggestions? suggestions,
  }) = _DocumentEditState;
}
