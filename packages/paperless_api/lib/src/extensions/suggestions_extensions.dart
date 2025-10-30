import 'package:paperless_api/generated/lib/src/model/document.dart';
import 'package:paperless_api/generated/lib/src/model/suggestions.dart';

extension FieldSuggestionsExtensions on Suggestions {
  bool get hasSuggestions =>
      hasSuggestedCorrespondents ||
      hasSuggestedDates ||
      hasSuggestedTags ||
      hasSuggestedDocumentTypes;

  bool get hasSuggestedCorrespondents => correspondents.isNotEmpty;
  bool get hasSuggestedTags => tags.isNotEmpty;
  bool get hasSuggestedDocumentTypes => documentTypes.isNotEmpty;
  bool get hasSuggestedDates => dates.isNotEmpty;

  int get suggestionsCount =>
      (correspondents.isNotEmpty ? 1 : 0) +
      (tags.isNotEmpty ? 1 : 0) +
      (documentTypes.isNotEmpty ? 1 : 0) +
      (dates.isNotEmpty ? 1 : 0);

  ///
  /// Removes the suggestions given in the parameters.
  ///
  Suggestions difference({
    Iterable<int> tags = const {},
    Iterable<int> correspondents = const {},
    Iterable<int> documentTypes = const {},
    Iterable<DateTime> dates = const {},
  }) {
    return copyWith(
      tags: this.tags.toSet().difference(tags.toSet()).toList(),
      correspondents: this.correspondents
          .toSet()
          .difference(correspondents.toSet())
          .toList(),
      documentTypes: this.documentTypes
          .toSet()
          .difference(documentTypes.toSet())
          .toList(),
      dates: this.dates.toSet().difference(dates.toSet()).toList(),
    );
  }

  Suggestions documentDifference(Document document) {
    return difference(
      tags: document.tags,
      correspondents: [
        document.correspondent,
      ].where((e) => e != null).map((e) => e!),
      documentTypes: [
        document.documentType,
      ].where((e) => e != null).map((e) => e!),
      dates: [?document.created],
    );
  }
}
