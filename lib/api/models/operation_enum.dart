import 'package:json_annotation/json_annotation.dart';

@JsonEnum(fieldRename: FieldRename.snake)
enum OperationEnum {
  setPermissions,
  delete;

  @override
  String toString() => name;
}
