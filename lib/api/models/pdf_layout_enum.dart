import 'package:json_annotation/json_annotation.dart';

@JsonEnum(valueField: 'value')
enum PdfLayoutEnum {
  systemDefault(0),
  textThenHtml(1),
  htmlThenText(2),
  htmlOnly(3),
  textOnly(4);

  const PdfLayoutEnum(this.value);

  final int value;

  @override
  String toString() => name;
}
