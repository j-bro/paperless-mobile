import 'package:json_annotation/json_annotation.dart';

@JsonEnum(fieldRename: FieldRename.snake)
enum ModeEnum {
  skip,
  redo,
  force,
  skipNoarchive;

  @override
  String toString() => name;
}
