import 'package:freezed_annotation/freezed_annotation.dart';

part 'tag_counts.freezed.dart';
part 'tag_counts.g.dart';

@Freezed(toJson: false, fromJson: true)
abstract class TagCounts with _$TagCounts {
  factory TagCounts({required int id, required int documentCount}) = _TagCounts;

  factory TagCounts.fromJson(Map<String, dynamic> json) =>
      _$TagCountsFromJson(json);
}
