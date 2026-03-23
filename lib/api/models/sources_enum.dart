import 'package:json_annotation/json_annotation.dart';

@JsonEnum(valueField: 'value')
enum SourcesEnum {
  consumeFolder(1),
  apiUpload(2),
  mailFetch(3),
  webUI(4);

  const SourcesEnum(this.value);

  final int value;

  @override
  String toString() => name;
}
