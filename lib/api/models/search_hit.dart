import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_hit.freezed.dart';
part 'search_hit.g.dart';

@Freezed(toJson: false, fromJson: true)
abstract class SearchHit with _$SearchHit {
  factory SearchHit({
    double? score,
    required String? highlights,
    required int? rank,
  }) = _SearchHit;

  factory SearchHit.fromJson(Map<String, dynamic> json) =>
      _$SearchHitFromJson(json);
}
