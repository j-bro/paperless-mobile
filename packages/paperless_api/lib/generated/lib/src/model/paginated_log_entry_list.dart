//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:paperless_api/generated/lib/src/model/log_entry.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'paginated_log_entry_list.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class PaginatedLogEntryList {
  /// Returns a new [PaginatedLogEntryList] instance.
  PaginatedLogEntryList({
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
  final List<LogEntry> results;

  @JsonKey(name: r'all', required: false, includeIfNull: false)
  final List<int>? all;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is PaginatedLogEntryList &&
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

  factory PaginatedLogEntryList.fromJson(Map<String, dynamic> json) =>
      _$PaginatedLogEntryListFromJson(json);

  Map<String, dynamic> toJson() => _$PaginatedLogEntryListToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
