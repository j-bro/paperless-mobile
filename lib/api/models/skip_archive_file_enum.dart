import 'package:json_annotation/json_annotation.dart';

@JsonEnum(fieldRename: FieldRename.snake)
enum SkipArchiveFileEnum {
  never,
  withText,
  always;

  @override
  String toString() => name;
}
