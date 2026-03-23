import 'package:freezed_annotation/freezed_annotation.dart';

part 'custom_field_instance_request.freezed.dart';
part 'custom_field_instance_request.g.dart';

@Freezed(toJson: true, fromJson: false)
abstract class CustomFieldInstanceRequest with _$CustomFieldInstanceRequest {
  factory CustomFieldInstanceRequest({
    /// Given the *incoming* primitive data, return the value for this field that should be validated and transformed to a native value.
    required Object? value,
    required int field,
  }) = _CustomFieldInstanceRequest;
}
