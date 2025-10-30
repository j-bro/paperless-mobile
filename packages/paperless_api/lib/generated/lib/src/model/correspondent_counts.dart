//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'correspondent_counts.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class CorrespondentCounts {
  /// Returns a new [CorrespondentCounts] instance.
  CorrespondentCounts({required this.id, required this.documentCount});

  @JsonKey(name: r'id', required: true, includeIfNull: false)
  final int id;

  @JsonKey(name: r'document_count', required: true, includeIfNull: false)
  final int documentCount;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is CorrespondentCounts &&
            runtimeType == other.runtimeType &&
            equals([id, documentCount], [other.id, other.documentCount]);
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ mapPropsToHashCode([id, documentCount]);

  factory CorrespondentCounts.fromJson(Map<String, dynamic> json) =>
      _$CorrespondentCountsFromJson(json);

  Map<String, dynamic> toJson() => _$CorrespondentCountsToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
