import 'package:freezed_annotation/freezed_annotation.dart';

part 'correspondent_counts.freezed.dart';
part 'correspondent_counts.g.dart';

@Freezed(toJson: false, fromJson: true)
abstract class CorrespondentCounts with _$CorrespondentCounts {
  factory CorrespondentCounts({required int id, required int documentCount}) =
      _CorrespondentCounts;

  factory CorrespondentCounts.fromJson(Map<String, dynamic> json) =>
      _$CorrespondentCountsFromJson(json);
}
