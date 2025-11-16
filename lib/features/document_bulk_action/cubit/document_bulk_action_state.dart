part of 'document_bulk_action_cubit.dart';

class DocumentBulkActionState {
  final List<Document> selection;

  DocumentBulkActionState({required this.selection});

  Iterable<int> get selectedIds => selection.map((d) => d.id);
  DocumentBulkActionState copyWith({List<Document>? selection}) {
    return DocumentBulkActionState(selection: selection ?? this.selection);
  }
}
