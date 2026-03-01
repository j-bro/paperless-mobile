part of 'document_print_cubit.dart';

sealed class DocumentPrintState {}

class DocumentPrintInitial extends DocumentPrintState {}

class DocumentPrintInProgress extends DocumentPrintState {
  final double progress;
  DocumentPrintInProgress(this.progress);
}

class DocumentPrintSuccess extends DocumentPrintState {}

class DocumentPrintError extends DocumentPrintState {
  final Object error;

  DocumentPrintError(this.error);
}
