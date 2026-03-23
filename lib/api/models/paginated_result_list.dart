import 'package:freezed_annotation/freezed_annotation.dart';

part 'paginated_result_list.freezed.dart';
part 'paginated_result_list.g.dart';

@Freezed(toJson: false, fromJson: true, genericArgumentFactories: true)
abstract class PaginatedResultList<T> with _$PaginatedResultList<T> {
  factory PaginatedResultList({
    required int count,
    String? next,
    String? previous,
    List<int>? all,
    required List<T> results,
  }) = _PaginatedResultList<T>;

  factory PaginatedResultList.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) fromJsonT,
  ) => _$PaginatedResultListFromJson(json, fromJsonT);
}
