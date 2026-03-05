//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/src/equatable_utils.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:paperless_mobile/api/models/models.dart';

part 'paginated_storage_path_list.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class PaginatedStoragePathList {
  /// Returns a new [PaginatedStoragePathList] instance.
  PaginatedStoragePathList({
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
  final List<StoragePath> results;

  @JsonKey(name: r'all', required: false, includeIfNull: false)
  final List<int>? all;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is PaginatedStoragePathList &&
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

  factory PaginatedStoragePathList.fromJson(Map<String, dynamic> json) =>
      _$PaginatedStoragePathListFromJson(json);

  Map<String, dynamic> toJson() => _$PaginatedStoragePathListToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
