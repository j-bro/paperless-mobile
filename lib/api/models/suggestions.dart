import 'package:freezed_annotation/freezed_annotation.dart';

part 'suggestions.freezed.dart';
part 'suggestions.g.dart';

@Freezed(toJson: false, fromJson: true)
abstract class Suggestions with _$Suggestions {
  factory Suggestions({
    required List<int> correspondents,
    required List<int> tags,
    required List<int> documentTypes,
    required List<int> storagePaths,
    required List<String> dates,
  }) = _Suggestions;

  factory Suggestions.fromJson(Map<String, dynamic> json) =>
      _$SuggestionsFromJson(json);
}
