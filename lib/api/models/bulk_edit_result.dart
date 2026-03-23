import 'package:freezed_annotation/freezed_annotation.dart';

part 'bulk_edit_result.freezed.dart';
part 'bulk_edit_result.g.dart';

@Freezed(toJson: false, fromJson: true)
abstract class BulkEditResult with _$BulkEditResult {
  factory BulkEditResult({required String result}) = _BulkEditResult;

  factory BulkEditResult.fromJson(Map<String, dynamic> json) =>
      _$BulkEditResultFromJson(json);
}
