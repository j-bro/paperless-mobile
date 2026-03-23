import 'package:json_annotation/json_annotation.dart';

@JsonEnum(valueField: 'value')
enum ContentEnum {
  archive(r'archive'),
  originals(r'originals'),
  both(r'both');

  const ContentEnum(this.value);

  final String value;

  @override
  String toString() => value;
}
