import 'package:json_annotation/json_annotation.dart';

@JsonEnum(valueField: 'value')
enum OutputTypeEnum {
  pdf(r'pdf'),
  pdfa(r'pdfa'),
  pdfa1(r'pdfa-1'),
  pdfa2(r'pdfa-2'),
  pdfa3(r'pdfa-3');

  const OutputTypeEnum(this.value);

  final String value;

  @override
  String toString() => value;
}
