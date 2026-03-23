import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:paperless_mobile/api/utils/patched_value.dart';

part 'patched_profile_request.g.dart';

@JsonSerializable(
  createFactory: false,
  createToJson: true,
  includeIfNull: false,
)
class PatchedProfileRequest {
  final PatchedValue<String?>? email;
  final PatchedValue<String?>? password;
  final PatchedValue<String?>? firstName;
  final PatchedValue<String?>? lastName;

  PatchedProfileRequest({
    this.email,
    this.password,
    this.firstName,
    this.lastName,
  });

  Map<String, dynamic> toJson() =>
      processPatchedValueJson(_$PatchedProfileRequestToJson(this));
}
