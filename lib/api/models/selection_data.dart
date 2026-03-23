import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:paperless_mobile/api/models/correspondent_counts.dart';
import 'package:paperless_mobile/api/models/custom_field_counts.dart';
import 'package:paperless_mobile/api/models/document_type_counts.dart';
import 'package:paperless_mobile/api/models/storage_path_counts.dart';
import 'package:paperless_mobile/api/models/tag_counts.dart';

part 'selection_data.freezed.dart';
part 'selection_data.g.dart';

@Freezed(toJson: false, fromJson: true)
abstract class SelectionData with _$SelectionData {
  factory SelectionData({
    required List<CorrespondentCounts> selectedCorrespondents,
    required List<TagCounts> selectedTags,
    required List<DocumentTypeCounts> selectedDocumentTypes,
    required List<StoragePathCounts> selectedStoragePaths,
    required List<CustomFieldCounts> selectedCustomFields,
  }) = _SelectionData;

  factory SelectionData.fromJson(Map<String, dynamic> json) =>
      _$SelectionDataFromJson(json);
}
