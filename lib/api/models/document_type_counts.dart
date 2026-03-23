import 'package:freezed_annotation/freezed_annotation.dart';

part 'document_type_counts.freezed.dart';
part 'document_type_counts.g.dart';

@Freezed(toJson: false, fromJson: true)
abstract class DocumentTypeCounts with _$DocumentTypeCounts {
  factory DocumentTypeCounts({required int id, required int documentCount}) =
      _DocumentTypeCounts;

  factory DocumentTypeCounts.fromJson(Map<String, dynamic> json) =>
      _$DocumentTypeCountsFromJson(json);
}
