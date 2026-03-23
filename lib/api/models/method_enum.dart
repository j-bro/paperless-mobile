import 'package:json_annotation/json_annotation.dart';

@JsonEnum(fieldRename: FieldRename.snake)
enum MethodEnum {
  setCorrespondent,
  setDocumentType,
  setStoragePath,
  addTag,
  removeTag,
  modifyTags,
  modifyCustomFields,
  delete,
  reprocess,
  setPermissions,
  rotate,
  merge,
  split,
  deletePages;

  @override
  String toString() => name;
}
