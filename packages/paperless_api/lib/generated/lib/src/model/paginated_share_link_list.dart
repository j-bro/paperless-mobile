//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:paperless_api/generated/lib/src/model/share_link.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'paginated_share_link_list.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class PaginatedShareLinkList {
  /// Returns a new [PaginatedShareLinkList] instance.
  PaginatedShareLinkList({
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
  final List<ShareLink> results;

  @JsonKey(name: r'all', required: false, includeIfNull: false)
  final List<int>? all;

  bool operator ==(Object other) {
    return identical(this, other) ||
        other is PaginatedShareLinkList &&
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

  factory PaginatedShareLinkList.fromJson(Map<String, dynamic> json) =>
      _$PaginatedShareLinkListFromJson(json);

  Map<String, dynamic> toJson() => _$PaginatedShareLinkListToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
