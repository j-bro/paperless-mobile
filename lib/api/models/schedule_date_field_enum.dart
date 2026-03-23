import 'package:json_annotation/json_annotation.dart';

@JsonEnum(fieldRename: FieldRename.snake)
enum ScheduleDateFieldEnum {
  added,
  created,
  modified,
  customField;

  @override
  String toString() => name;
}
