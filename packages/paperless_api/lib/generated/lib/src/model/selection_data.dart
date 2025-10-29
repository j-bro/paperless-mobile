//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:paperless_api/generated/lib/src/model/document_type_counts.dart';
import 'package:paperless_api/generated/lib/src/model/custom_field_counts.dart';
import 'package:paperless_api/generated/lib/src/model/correspondent_counts.dart';
import 'package:paperless_api/generated/lib/src/model/storage_path_counts.dart';
import 'package:paperless_api/generated/lib/src/model/tag_counts.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'selection_data.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class SelectionData {
  /// Returns a new [SelectionData] instance.
  SelectionData({
    required this.selectedCorrespondents,

    required this.selectedTags,

    required this.selectedDocumentTypes,

    required this.selectedStoragePaths,

    required this.selectedCustomFields,
  });

  @JsonKey(
    name: r'selected_correspondents',
    required: true,
    includeIfNull: false,
  )
  final List<CorrespondentCounts> selectedCorrespondents;

  @JsonKey(name: r'selected_tags', required: true, includeIfNull: false)
  final List<TagCounts> selectedTags;

  @JsonKey(
    name: r'selected_document_types',
    required: true,
    includeIfNull: false,
  )
  final List<DocumentTypeCounts> selectedDocumentTypes;

  @JsonKey(
    name: r'selected_storage_paths',
    required: true,
    includeIfNull: false,
  )
  final List<StoragePathCounts> selectedStoragePaths;

  @JsonKey(
    name: r'selected_custom_fields',
    required: true,
    includeIfNull: false,
  )
  final List<CustomFieldCounts> selectedCustomFields;

  bool operator ==(Object other) {
    return identical(this, other) ||
        other is SelectionData &&
            runtimeType == other.runtimeType &&
            equals(
              [
                selectedCorrespondents,
                selectedTags,
                selectedDocumentTypes,
                selectedStoragePaths,
                selectedCustomFields,
              ],
              [
                other.selectedCorrespondents,
                other.selectedTags,
                other.selectedDocumentTypes,
                other.selectedStoragePaths,
                other.selectedCustomFields,
              ],
            );
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      mapPropsToHashCode([
        selectedCorrespondents,
        selectedTags,
        selectedDocumentTypes,
        selectedStoragePaths,
        selectedCustomFields,
      ]);

  factory SelectionData.fromJson(Map<String, dynamic> json) =>
      _$SelectionDataFromJson(json);

  Map<String, dynamic> toJson() => _$SelectionDataToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
