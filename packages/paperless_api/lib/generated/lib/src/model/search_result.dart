//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/src/equatable_utils.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:paperless_api/generated/lib/src/model/correspondent.dart';
import 'package:paperless_api/generated/lib/src/model/custom_field.dart';
import 'package:paperless_api/generated/lib/src/model/document.dart';
import 'package:paperless_api/generated/lib/src/model/document_type.dart';
// ignore_for_file: unused_element
import 'package:paperless_api/generated/lib/src/model/group.dart';
import 'package:paperless_api/generated/lib/src/model/mail_account.dart';
import 'package:paperless_api/generated/lib/src/model/mail_rule.dart';
import 'package:paperless_api/generated/lib/src/model/saved_view.dart';
import 'package:paperless_api/generated/lib/src/model/storage_path.dart';
import 'package:paperless_api/generated/lib/src/model/tag.dart';
import 'package:paperless_api/generated/lib/src/model/user.dart';
import 'package:paperless_api/generated/lib/src/model/workflow.dart';

part 'search_result.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class SearchResult {
  /// Returns a new [SearchResult] instance.
  SearchResult({
    required this.total,

    required this.documents,

    required this.savedViews,

    required this.tags,

    required this.correspondents,

    required this.documentTypes,

    required this.storagePaths,

    required this.users,

    required this.groups,

    required this.mailRules,

    required this.mailAccounts,

    required this.workflows,

    required this.customFields,
  });

  @JsonKey(name: r'total', required: true, includeIfNull: false)
  final int total;

  @JsonKey(name: r'documents', required: true, includeIfNull: false)
  final List<Document> documents;

  @JsonKey(name: r'saved_views', required: true, includeIfNull: false)
  final List<SavedView> savedViews;

  @JsonKey(name: r'tags', required: true, includeIfNull: false)
  final List<Tag> tags;

  @JsonKey(name: r'correspondents', required: true, includeIfNull: false)
  final List<Correspondent> correspondents;

  @JsonKey(name: r'document_types', required: true, includeIfNull: false)
  final List<DocumentType> documentTypes;

  @JsonKey(name: r'storage_paths', required: true, includeIfNull: false)
  final List<StoragePath> storagePaths;

  @JsonKey(name: r'users', required: true, includeIfNull: false)
  final List<User> users;

  @JsonKey(name: r'groups', required: true, includeIfNull: false)
  final List<Group> groups;

  @JsonKey(name: r'mail_rules', required: true, includeIfNull: false)
  final List<MailRule> mailRules;

  @JsonKey(name: r'mail_accounts', required: true, includeIfNull: false)
  final List<MailAccount> mailAccounts;

  @JsonKey(name: r'workflows', required: true, includeIfNull: false)
  final List<Workflow> workflows;

  @JsonKey(name: r'custom_fields', required: true, includeIfNull: false)
  final List<CustomField> customFields;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is SearchResult &&
            runtimeType == other.runtimeType &&
            equals(
              [
                total,
                documents,
                savedViews,
                tags,
                correspondents,
                documentTypes,
                storagePaths,
                users,
                groups,
                mailRules,
                mailAccounts,
                workflows,
                customFields,
              ],
              [
                other.total,
                other.documents,
                other.savedViews,
                other.tags,
                other.correspondents,
                other.documentTypes,
                other.storagePaths,
                other.users,
                other.groups,
                other.mailRules,
                other.mailAccounts,
                other.workflows,
                other.customFields,
              ],
            );
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      mapPropsToHashCode([
        total,
        documents,
        savedViews,
        tags,
        correspondents,
        documentTypes,
        storagePaths,
        users,
        groups,
        mailRules,
        mailAccounts,
        workflows,
        customFields,
      ]);

  factory SearchResult.fromJson(Map<String, dynamic> json) =>
      _$SearchResultFromJson(json);

  Map<String, dynamic> toJson() => _$SearchResultToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
