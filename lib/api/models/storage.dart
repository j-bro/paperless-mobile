//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'storage.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class Storage {
  /// Returns a new [Storage] instance.
  Storage({required this.total, required this.available});

  @JsonKey(name: r'total', required: true, includeIfNull: false)
  final int total;

  @JsonKey(name: r'available', required: true, includeIfNull: false)
  final int available;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Storage &&
            runtimeType == other.runtimeType &&
            equals([total, available], [other.total, other.available]);
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ mapPropsToHashCode([total, available]);

  factory Storage.fromJson(Map<String, dynamic> json) =>
      _$StorageFromJson(json);

  Map<String, dynamic> toJson() => _$StorageToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
