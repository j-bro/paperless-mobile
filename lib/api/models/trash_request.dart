import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:paperless_mobile/api/models/trash_action_enum.dart';

part 'trash_request.freezed.dart';
part 'trash_request.g.dart';

@Freezed(toJson: true, fromJson: false)
abstract class TrashRequest with _$TrashRequest {
  factory TrashRequest({
    List<int>? documents,
    required TrashActionEnum action,
  }) = _TrashRequest;
}
