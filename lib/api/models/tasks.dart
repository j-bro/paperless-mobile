import 'package:freezed_annotation/freezed_annotation.dart';

part 'tasks.freezed.dart';
part 'tasks.g.dart';

@Freezed(toJson: true, fromJson: true)
abstract class Tasks with _$Tasks {
  factory Tasks({
    required String redisUrl,
    required String redisStatus,
    required String redisError,
    required String celeryStatus,
  }) = _Tasks;

  factory Tasks.fromJson(Map<String, dynamic> json) => _$TasksFromJson(json);
}
