import 'package:json_annotation/json_annotation.dart';

@JsonEnum(valueField: 'value')
enum ColorConversionStrategyEnum {
  leaveColorUnchanged(r'LeaveColorUnchanged'),
  rgb(r'RGB'),
  useDeviceIndependentColor(r'UseDeviceIndependentColor'),
  gray(r'Gray'),
  cmyk(r'CMYK');

  const ColorConversionStrategyEnum(this.value);

  final String value;

  @override
  String toString() => value;
}
