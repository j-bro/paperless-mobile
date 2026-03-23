import 'package:freezed_annotation/freezed_annotation.dart';

part 'group.freezed.dart';
part 'group.g.dart';

@Freezed(toJson: false, fromJson: true)
abstract class Group with _$Group {
  factory Group({
    required int id,
    required String name,
    required List<String> permissions,
  }) = _Group;

  factory Group.fromJson(Map<String, dynamic> json) => _$GroupFromJson(json);
}
