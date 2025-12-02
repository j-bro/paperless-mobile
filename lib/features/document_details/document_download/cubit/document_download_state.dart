part of 'document_download_cubit.dart';

sealed class DocumentDownloadState {
  const DocumentDownloadState();
}

class DocumentDownloadInitial extends DocumentDownloadState {
  const DocumentDownloadInitial();
}

class DocumentDownloadInProgress extends DocumentDownloadState {
  final double progress;

  const DocumentDownloadInProgress(this.progress);
}

class DocumentDownloadSuccess extends DocumentDownloadState {
  final String filePath;

  const DocumentDownloadSuccess(this.filePath);
}

class DocumentDownloadError extends DocumentDownloadState {
  final Object error;

  const DocumentDownloadError(this.error);
}
