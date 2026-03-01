part of 'document_share_cubit.dart';

sealed class DocumentShareState {
  const DocumentShareState();
}

class DocumentShareInitial extends DocumentShareState {
  const DocumentShareInitial();
}

class DocumentShareInProgress extends DocumentShareState {
  final double progress;
  const DocumentShareInProgress(this.progress);
}

class DocumentShareSuccess extends DocumentShareState {
  const DocumentShareSuccess();
}

class DocumentShareError extends DocumentShareState {
  final Object error;
  const DocumentShareError(this.error);
}
