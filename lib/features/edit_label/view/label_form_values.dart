import 'package:paperless_mobile/api/paperless_api.dart';

/// Type-safe representation of the common label form field values.
///
/// Extracted from [FormBuilderState] by [LabelForm] and passed to the
/// [buildRequest] callback so that concrete pages can construct their
/// [LabelRequest] subclass without any JSON round-tripping.
class LabelFormValues {
  final String name;
  final String? match;
  final MatchingAlgorithm? matchingAlgorithm;
  final bool? isInsensitive;

  /// Preserved from the initial value — not shown in the form but needed
  /// for edit round-trips.
  final int? owner;

  const LabelFormValues({
    required this.name,
    this.match,
    this.matchingAlgorithm,
    this.isInsensitive,
    this.owner,
  });
}
