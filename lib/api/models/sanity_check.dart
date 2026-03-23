import 'package:freezed_annotation/freezed_annotation.dart';

part 'sanity_check.freezed.dart';
part 'sanity_check.g.dart';

@Freezed(toJson: false, fromJson: true)
abstract class SanityCheck with _$SanityCheck {
  factory SanityCheck({
    required String status,
    required String error,
    required DateTime lastRun,
  }) = _SanityCheck;

  factory SanityCheck.fromJson(Map<String, dynamic> json) =>
      _$SanityCheckFromJson(json);
}
