import 'package:fpdart/fpdart.dart' show Option;
import 'package:json_annotation/json_annotation.dart';
import 'package:paperless_mobile/api/converters/local_date_time_json_converter.dart';

/// A wrapper type that represents a value that can be:
/// 1. Not provided (field is `null` in Dart) - excluded from JSON
/// 2. Explicitly set to null (`PatchedValue(null)`) - included as `null` in JSON
/// 3. Set to a value (`PatchedValue(value)`) - included as `value` in JSON
///
/// This solves the common PATCH request problem where you need to differentiate
/// between "don't change this field" and "set this field to null".
class PatchedValue<T> {
  final T value;

  const PatchedValue(this.value);

  /// Returns the PatchedValue itself so that json_serializable can serialize it.
  /// The actual serialization is handled by [processPatchedValueJson].
  PatchedValue<T> toJson() => this;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PatchedValue<T> && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'PatchedValue($value)';
}

/// A custom JsonConverter for PatchedValue fields that properly handles:
/// - `null` field (PatchedValue not provided) -> excluded from JSON
/// - `PatchedValue(null)` -> serializes as `null` in JSON
/// - `PatchedValue(value)` -> serializes as `value` in JSON
class PatchedValueJsonConverter<T>
    implements JsonConverter<PatchedValue<T>?, Object?> {
  const PatchedValueJsonConverter();

  @override
  PatchedValue<T>? fromJson(Object? json) {
    // For PATCH requests, we typically don't need to deserialize
    // but if needed, treat any value as a PatchedValue
    return json == null ? null : PatchedValue(json as T);
  }

  @override
  Object? toJson(PatchedValue<T>? object) {
    if (object == null) {
      // Field not provided - will be excluded due to includeIfNull: false
      return null;
    }
    // Field explicitly provided (even if value is null)
    final value = object.value;
    if (value is DateTime) {
      return const LocalDateTimeJsonConverter().toJson(value);
    }
    if (value is List) {
      return value;
    }
    return value;
  }
}

/// Processes a JSON map and handles PatchedValue and Option serialization properly.
///
/// For PatchedValue:
/// - Fields where the PatchedValue itself is null are excluded (not provided)
/// - Fields where PatchedValue wraps null are included as null (explicitly set to null)
/// - Fields where PatchedValue wraps a value are included with that value
///
/// For Option (fpdart):
/// - Fields where Option is null are excluded (not provided)
/// - Fields where Option is None() are included as null (explicitly set to null)
/// - Fields where Option is Some(value) are included with that value
Map<String, dynamic> processPatchedValueJson(Map<String, dynamic> json) {
  final result = <String, dynamic>{};

  for (final entry in json.entries) {
    final key = entry.key;
    final value = entry.value;

    // Skip null values (field not provided)
    if (value == null) continue;

    if (value is PatchedValue) {
      // PatchedValue was explicitly set - include it (even if inner value is null)
      final innerValue = value.value;
      result[key] = _serializeValue(innerValue);
    } else if (value is Option) {
      // Option was explicitly set - include it based on Some/None
      value.match(
        () {
          // None - explicitly set to null
          result[key] = null;
        },
        (innerValue) {
          // Some - include the value
          result[key] = _serializeValue(innerValue);
        },
      );
    } else {
      // Regular value - include as-is
      result[key] = value;
    }
  }

  return result;
}

/// Helper to serialize values with special handling for DateTime
dynamic _serializeValue(dynamic value) {
  if (value is DateTime) {
    return const LocalDateTimeJsonConverter().toJson(value);
  }
  return value;
}
