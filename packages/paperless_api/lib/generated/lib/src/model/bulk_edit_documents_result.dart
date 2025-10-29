//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'bulk_edit_documents_result.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class BulkEditDocumentsResult {
  /// Returns a new [BulkEditDocumentsResult] instance.
  BulkEditDocumentsResult({required this.result});

  @JsonKey(name: r'result', required: true, includeIfNull: false)
  final String result;

  bool operator ==(Object other) {
    return identical(this, other) ||
        other is BulkEditDocumentsResult &&
            runtimeType == other.runtimeType &&
            equals([result], [other.result]);
  }

  @override
  int get hashCode => runtimeType.hashCode ^ mapPropsToHashCode([result]);

  factory BulkEditDocumentsResult.fromJson(Map<String, dynamic> json) =>
      _$BulkEditDocumentsResultFromJson(json);

  Map<String, dynamic> toJson() => _$BulkEditDocumentsResultToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
