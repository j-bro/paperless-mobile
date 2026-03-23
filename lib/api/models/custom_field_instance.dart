import 'package:freezed_annotation/freezed_annotation.dart';

part 'custom_field_instance.freezed.dart';
part 'custom_field_instance.g.dart';

@Freezed(toJson: true, fromJson: true)
abstract class CustomFieldInstance with _$CustomFieldInstance {
  factory CustomFieldInstance({
    /// Given the *incoming* primitive data, return the value for this field that should be validated and transformed to a native value.
    required Object? value,
    required int field,
  }) = _CustomFieldInstance;

  factory CustomFieldInstance.fromJson(Map<String, dynamic> json) =>
      _$CustomFieldInstanceFromJson(json);
}
