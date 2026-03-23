import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:paperless_mobile/api/models/models.dart';

part 'search_result.freezed.dart';
part 'search_result.g.dart';

@Freezed(toJson: false, fromJson: true)
abstract class SearchResult with _$SearchResult {
  factory SearchResult({
    required int total,
    required List<Document> documents,
    required List<SavedView> savedViews,
    required List<Tag> tags,
    required List<Correspondent> correspondents,
    required List<DocumentType> documentTypes,
    required List<StoragePath> storagePaths,
    required List<User> users,
    required List<Group> groups,
    required List<MailRule> mailRules,
    required List<MailAccount> mailAccounts,
    required List<Workflow> workflows,
    required List<CustomField> customFields,
  }) = _SearchResult;

  factory SearchResult.fromJson(Map<String, dynamic> json) =>
      _$SearchResultFromJson(json);
}
