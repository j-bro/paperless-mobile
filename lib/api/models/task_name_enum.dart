import 'package:json_annotation/json_annotation.dart';

@JsonEnum(fieldRename: FieldRename.snake)
enum TaskNameEnum {
  consumeFile,

  trainClassifier,

  checkSanity,

  indexOptimize;

  @override
  String toString() => name;
}
