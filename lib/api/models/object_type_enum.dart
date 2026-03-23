import 'package:json_annotation/json_annotation.dart';

@JsonEnum(fieldRename: FieldRename.snake)
enum ObjectTypeEnum {
  tags,
  correspondents,
  documentTypes,
  storagePaths;

  @override
  String toString() => name;
}
