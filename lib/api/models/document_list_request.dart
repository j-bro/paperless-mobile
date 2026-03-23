import 'package:freezed_annotation/freezed_annotation.dart';

part 'document_list_request.freezed.dart';
part 'document_list_request.g.dart';

@Freezed(toJson: true, fromJson: false)
abstract class DocumentListRequest with _$DocumentListRequest {
  factory DocumentListRequest({required List<int> documents}) =
      _DocumentListRequest;
}
