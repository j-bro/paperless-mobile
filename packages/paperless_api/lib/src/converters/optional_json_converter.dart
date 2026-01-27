import 'package:paperless_api/src/utils/patched_value.dart';

///
/// Processes a JSON map and handles PatchedValue fields properly:
/// - Fields where the PatchedValue itself is null are excluded (not provided)
/// - Fields where PatchedValue wraps null are included as null (explicitly set to null)
/// - Fields where PatchedValue wraps a value are included with that value
///
/// @deprecated Use [processPatchedValueJson] from patched_value.dart instead.
Map<String, dynamic> convertPatchedValueJson(Map<String, dynamic> json) {
  return processPatchedValueJson(json);
}
