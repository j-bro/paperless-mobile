//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'suggestions.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class Suggestions {
  /// Returns a new [Suggestions] instance.
  Suggestions({
    required this.correspondents,

    required this.tags,

    required this.documentTypes,

    required this.storagePaths,

    required this.dates,
  });

  @JsonKey(name: r'correspondents', required: true, includeIfNull: false)
  final List<int> correspondents;

  @JsonKey(name: r'tags', required: true, includeIfNull: false)
  final List<int> tags;

  @JsonKey(name: r'document_types', required: true, includeIfNull: false)
  final List<int> documentTypes;

  @JsonKey(name: r'storage_paths', required: true, includeIfNull: false)
  final List<int> storagePaths;

  @JsonKey(name: r'dates', required: true, includeIfNull: false)
  final List<String> dates;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Suggestions &&
            runtimeType == other.runtimeType &&
            equals(
              [correspondents, tags, documentTypes, storagePaths, dates],
              [
                other.correspondents,
                other.tags,
                other.documentTypes,
                other.storagePaths,
                other.dates,
              ],
            );
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      mapPropsToHashCode([
        correspondents,
        tags,
        documentTypes,
        storagePaths,
        dates,
      ]);

  factory Suggestions.fromJson(Map<String, dynamic> json) =>
      _$SuggestionsFromJson(json);

  Map<String, dynamic> toJson() => _$SuggestionsToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
