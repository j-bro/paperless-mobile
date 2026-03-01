//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

/// * `tags` - tags * `correspondents` - correspondents * `document_types` - document_types * `storage_paths` - storage_paths
enum ObjectTypeEnum {
  /// * `tags` - tags * `correspondents` - correspondents * `document_types` - document_types * `storage_paths` - storage_paths
  @JsonValue(r'tags')
  tags(r'tags'),

  /// * `tags` - tags * `correspondents` - correspondents * `document_types` - document_types * `storage_paths` - storage_paths
  @JsonValue(r'correspondents')
  correspondents(r'correspondents'),

  /// * `tags` - tags * `correspondents` - correspondents * `document_types` - document_types * `storage_paths` - storage_paths
  @JsonValue(r'document_types')
  documentTypes(r'document_types'),

  /// * `tags` - tags * `correspondents` - correspondents * `document_types` - document_types * `storage_paths` - storage_paths
  @JsonValue(r'storage_paths')
  storagePaths(r'storage_paths');

  const ObjectTypeEnum(this.value);

  final String value;

  @override
  String toString() => value;
}
