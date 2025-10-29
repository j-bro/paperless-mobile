//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'tag_counts.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class TagCounts {
  /// Returns a new [TagCounts] instance.
  TagCounts({required this.id, required this.documentCount});

  @JsonKey(name: r'id', required: true, includeIfNull: false)
  final int id;

  @JsonKey(name: r'document_count', required: true, includeIfNull: false)
  final int documentCount;

  bool operator ==(Object other) {
    return identical(this, other) ||
        other is TagCounts &&
            runtimeType == other.runtimeType &&
            equals([id, documentCount], [other.id, other.documentCount]);
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ mapPropsToHashCode([id, documentCount]);

  factory TagCounts.fromJson(Map<String, dynamic> json) =>
      _$TagCountsFromJson(json);

  Map<String, dynamic> toJson() => _$TagCountsToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
