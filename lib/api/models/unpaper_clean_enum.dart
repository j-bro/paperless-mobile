import 'package:json_annotation/json_annotation.dart';

@JsonEnum(valueField: 'value')
enum UnpaperCleanEnum {
  clean('clean'),
  cleanFinal('clean-final'),
  none('none');

  const UnpaperCleanEnum(this.value);

  final String value;

  @override
  String toString() => value;
}
