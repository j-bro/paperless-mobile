part of 'document_open_in_system_cubit.dart';

sealed class DocumentOpenInSystemState {}

class DocumentOpenInSystemInitial extends DocumentOpenInSystemState {}

class DocumentOpenInSystemInProgress extends DocumentOpenInSystemState {
  final double progress;
  DocumentOpenInSystemInProgress(this.progress);
}

class DocumentOpenInSystemSuccess extends DocumentOpenInSystemState {
  final ResultType resultType;
  DocumentOpenInSystemSuccess(this.resultType);
}

class DocumentOpenInSystemError extends DocumentOpenInSystemState {
  final Object error;

  DocumentOpenInSystemError(this.error);
}
