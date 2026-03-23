import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:paperless_mobile/api/models/method_enum.dart';

part 'bulk_edit_request.freezed.dart';
part 'bulk_edit_request.g.dart';

@Freezed(toJson: true, fromJson: false)
abstract class BulkEditRequest with _$BulkEditRequest {
  factory BulkEditRequest({
    required List<int> documents,
    required MethodEnum method,
    @Default({}) Map<String, Object>? parameters,
  }) = _BulkEditRequest;
}
