//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'storage_path_counts.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class StoragePathCounts {
  /// Returns a new [StoragePathCounts] instance.
  StoragePathCounts({required this.id, required this.documentCount});

  @JsonKey(name: r'id', required: true, includeIfNull: false)
  final int id;

  @JsonKey(name: r'document_count', required: true, includeIfNull: false)
  final int documentCount;

  bool operator ==(Object other) {
    return identical(this, other) ||
        other is StoragePathCounts &&
            runtimeType == other.runtimeType &&
            equals([id, documentCount], [other.id, other.documentCount]);
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ mapPropsToHashCode([id, documentCount]);

  factory StoragePathCounts.fromJson(Map<String, dynamic> json) =>
      _$StoragePathCountsFromJson(json);

  Map<String, dynamic> toJson() => _$StoragePathCountsToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
