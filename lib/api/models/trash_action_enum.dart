import 'package:json_annotation/json_annotation.dart';

@JsonEnum(fieldRename: FieldRename.snake)
enum TrashActionEnum {
  restore,

  empty;

  @override
  String toString() => name;
}
