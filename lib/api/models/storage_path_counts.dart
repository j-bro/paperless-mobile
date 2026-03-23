import 'package:freezed_annotation/freezed_annotation.dart';

part 'storage_path_counts.freezed.dart';
part 'storage_path_counts.g.dart';

@Freezed(toJson: false, fromJson: true)
abstract class StoragePathCounts with _$StoragePathCounts {
  factory StoragePathCounts({required int id, required int documentCount}) =
      _StoragePathCounts;

  factory StoragePathCounts.fromJson(Map<String, dynamic> json) =>
      _$StoragePathCountsFromJson(json);
}
