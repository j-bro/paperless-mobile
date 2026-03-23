import 'package:freezed_annotation/freezed_annotation.dart';

part 'group_request.freezed.dart';
part 'group_request.g.dart';

@Freezed(toJson: true, fromJson: false)
abstract class GroupRequest with _$GroupRequest {
  factory GroupRequest({
    required String name,
    required List<String> permissions,
  }) = _GroupRequest;
}
