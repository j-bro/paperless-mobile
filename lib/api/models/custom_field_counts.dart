import 'package:freezed_annotation/freezed_annotation.dart';

part 'custom_field_counts.freezed.dart';
part 'custom_field_counts.g.dart';

@Freezed(toJson: false, fromJson: true)
abstract class CustomFieldCounts with _$CustomFieldCounts {
  factory CustomFieldCounts({required int id, required int documentCount}) =
      _CustomFieldCounts;

  factory CustomFieldCounts.fromJson(Map<String, dynamic> json) =>
      _$CustomFieldCountsFromJson(json);
}
