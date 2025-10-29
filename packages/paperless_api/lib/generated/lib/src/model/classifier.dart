//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'classifier.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class Classifier {
  /// Returns a new [Classifier] instance.
  Classifier({
    required this.status,

    required this.error,

    required this.lastTrained,
  });

  @JsonKey(name: r'status', required: true, includeIfNull: false)
  final String status;

  @JsonKey(name: r'error', required: true, includeIfNull: false)
  final String error;

  @JsonKey(name: r'last_trained', required: true, includeIfNull: false)
  final DateTime lastTrained;

  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Classifier &&
            runtimeType == other.runtimeType &&
            equals(
              [status, error, lastTrained],
              [other.status, other.error, other.lastTrained],
            );
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ mapPropsToHashCode([status, error, lastTrained]);

  factory Classifier.fromJson(Map<String, dynamic> json) =>
      _$ClassifierFromJson(json);

  Map<String, dynamic> toJson() => _$ClassifierToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
