//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/src/equatable_utils.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:paperless_mobile/api/models/models.dart';

part 'paginated_document_type_list.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class PaginatedDocumentTypeList {
  /// Returns a new [PaginatedDocumentTypeList] instance.
  PaginatedDocumentTypeList({
    required this.count,

    this.next,

    this.previous,

    required this.results,

    this.all,
  });

  @JsonKey(name: r'count', required: true, includeIfNull: false)
  final int count;

  @JsonKey(name: r'next', required: false, includeIfNull: false)
  final String? next;

  @JsonKey(name: r'previous', required: false, includeIfNull: false)
  final String? previous;

  @JsonKey(name: r'results', required: true, includeIfNull: false)
  final List<DocumentType> results;

  @JsonKey(name: r'all', required: false, includeIfNull: false)
  final List<int>? all;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is PaginatedDocumentTypeList &&
            runtimeType == other.runtimeType &&
            equals(
              [count, next, previous, results, all],
              [
                other.count,
                other.next,
                other.previous,
                other.results,
                other.all,
              ],
            );
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      mapPropsToHashCode([count, next, previous, results, all]);

  factory PaginatedDocumentTypeList.fromJson(Map<String, dynamic> json) =>
      _$PaginatedDocumentTypeListFromJson(json);

  Map<String, dynamic> toJson() => _$PaginatedDocumentTypeListToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
