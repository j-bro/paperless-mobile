import 'package:freezed_annotation/freezed_annotation.dart';

part 'bulk_edit_documents_result.freezed.dart';
part 'bulk_edit_documents_result.g.dart';

@Freezed(toJson: false, fromJson: true)
abstract class BulkEditDocumentsResult with _$BulkEditDocumentsResult {
  factory BulkEditDocumentsResult({required String result}) =
      _BulkEditDocumentsResult;

  factory BulkEditDocumentsResult.fromJson(Map<String, dynamic> json) =>
      _$BulkEditDocumentsResultFromJson(json);
}
