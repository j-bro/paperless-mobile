import 'package:json_annotation/json_annotation.dart';

@JsonEnum(valueField: 'value')
enum CompressionEnum {
  none(r'none'),
  deflated(r'deflated'),
  bzip2(r'bzip2'),
  lzma(r'lzma');

  const CompressionEnum(this.value);

  final String value;

  @override
  String toString() => value;
}
