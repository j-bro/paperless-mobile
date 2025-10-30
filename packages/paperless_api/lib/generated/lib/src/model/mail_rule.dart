//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:paperless_api/generated/lib/src/model/pdf_layout_enum.dart';
import 'package:paperless_api/generated/lib/src/model/assign_title_from_enum.dart';
import 'package:paperless_api/generated/lib/src/model/consumption_scope_enum.dart';
import 'package:paperless_api/generated/lib/src/model/attachment_type_enum.dart';
import 'package:paperless_api/generated/lib/src/model/mail_rule_action_enum.dart';
import 'package:paperless_api/generated/lib/src/model/assign_correspondent_from_enum.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'mail_rule.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class MailRule {
  /// Returns a new [MailRule] instance.
  MailRule({
    required this.id,

    required this.name,

    required this.account,

    this.enabled,

    this.folder,

    this.filterFrom,

    this.filterTo,

    this.filterSubject,

    this.filterBody,

    this.filterAttachmentFilenameInclude,

    this.filterAttachmentFilenameExclude,

    this.maximumAge,

    this.action,

    this.actionParameter = '',

    this.assignTitleFrom,

    this.assignTags,

    this.assignCorrespondentFrom,

    this.assignCorrespondent,

    this.assignDocumentType,

    this.assignOwnerFromRule,

    this.order,

    this.attachmentType,

    this.consumptionScope,

    this.pdfLayout,

    this.owner,

    required this.userCanChange,
  });

  @JsonKey(name: r'id', required: true, includeIfNull: false)
  final int id;

  @JsonKey(name: r'name', required: true, includeIfNull: false)
  final String name;

  @JsonKey(name: r'account', required: true, includeIfNull: false)
  final int account;

  @JsonKey(name: r'enabled', required: false, includeIfNull: false)
  final bool? enabled;

  /// Subfolders must be separated by a delimiter, often a dot ('.') or slash ('/'), but it varies by mail server.
  @JsonKey(name: r'folder', required: false, includeIfNull: false)
  final String? folder;

  @JsonKey(name: r'filter_from', required: false, includeIfNull: false)
  final String? filterFrom;

  @JsonKey(name: r'filter_to', required: false, includeIfNull: false)
  final String? filterTo;

  @JsonKey(name: r'filter_subject', required: false, includeIfNull: false)
  final String? filterSubject;

  @JsonKey(name: r'filter_body', required: false, includeIfNull: false)
  final String? filterBody;

  /// Only consume documents which entirely match this filename if specified. Wildcards such as *.pdf or *invoice* are allowed. Case insensitive.
  @JsonKey(
    name: r'filter_attachment_filename_include',
    required: false,
    includeIfNull: false,
  )
  final String? filterAttachmentFilenameInclude;

  /// Do not consume documents which entirely match this filename if specified. Wildcards such as *.pdf or *invoice* are allowed. Case insensitive.
  @JsonKey(
    name: r'filter_attachment_filename_exclude',
    required: false,
    includeIfNull: false,
  )
  final String? filterAttachmentFilenameExclude;

  /// Specified in days.
  // minimum: 0
  // maximum: 2147483647
  @JsonKey(name: r'maximum_age', required: false, includeIfNull: false)
  final int? maximumAge;

  // minimum: 0.0
  // maximum: 2.147483647E9
  @JsonKey(name: r'action', required: false, includeIfNull: false)
  final MailRuleActionEnum? action;

  @JsonKey(
    defaultValue: '',
    name: r'action_parameter',
    required: false,
    includeIfNull: false,
  )
  final String? actionParameter;

  // minimum: 0.0
  // maximum: 2.147483647E9
  @JsonKey(name: r'assign_title_from', required: false, includeIfNull: false)
  final AssignTitleFromEnum? assignTitleFrom;

  @JsonKey(name: r'assign_tags', required: false, includeIfNull: false)
  final List<int>? assignTags;

  // minimum: 0.0
  // maximum: 2.147483647E9
  @JsonKey(
    name: r'assign_correspondent_from',
    required: false,
    includeIfNull: false,
  )
  final AssignCorrespondentFromEnum? assignCorrespondentFrom;

  @JsonKey(name: r'assign_correspondent', required: false, includeIfNull: false)
  final int? assignCorrespondent;

  @JsonKey(name: r'assign_document_type', required: false, includeIfNull: false)
  final int? assignDocumentType;

  @JsonKey(
    name: r'assign_owner_from_rule',
    required: false,
    includeIfNull: false,
  )
  final bool? assignOwnerFromRule;

  @JsonKey(name: r'order', required: false, includeIfNull: false)
  final int? order;

  /// Inline attachments include embedded images, so it's best to combine this option with a filename filter.  * `1` - Only process attachments. * `2` - Process all files, including 'inline' attachments.
  // minimum: 0.0
  // maximum: 2.147483647E9
  @JsonKey(name: r'attachment_type', required: false, includeIfNull: false)
  final AttachmentTypeEnum? attachmentType;

  // minimum: 0.0
  // maximum: 2.147483647E9
  @JsonKey(name: r'consumption_scope', required: false, includeIfNull: false)
  final ConsumptionScopeEnum? consumptionScope;

  // minimum: 0.0
  // maximum: 2.147483647E9
  @JsonKey(name: r'pdf_layout', required: false, includeIfNull: false)
  final PdfLayoutEnum? pdfLayout;

  @JsonKey(name: r'owner', required: false, includeIfNull: false)
  final int? owner;

  @JsonKey(name: r'user_can_change', required: true, includeIfNull: false)
  final bool userCanChange;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is MailRule &&
            runtimeType == other.runtimeType &&
            equals(
              [
                id,
                name,
                account,
                enabled,
                folder,
                filterFrom,
                filterTo,
                filterSubject,
                filterBody,
                filterAttachmentFilenameInclude,
                filterAttachmentFilenameExclude,
                maximumAge,
                action,
                actionParameter,
                assignTitleFrom,
                assignTags,
                assignCorrespondentFrom,
                assignCorrespondent,
                assignDocumentType,
                assignOwnerFromRule,
                order,
                attachmentType,
                consumptionScope,
                pdfLayout,
                owner,
                userCanChange,
              ],
              [
                other.id,
                other.name,
                other.account,
                other.enabled,
                other.folder,
                other.filterFrom,
                other.filterTo,
                other.filterSubject,
                other.filterBody,
                other.filterAttachmentFilenameInclude,
                other.filterAttachmentFilenameExclude,
                other.maximumAge,
                other.action,
                other.actionParameter,
                other.assignTitleFrom,
                other.assignTags,
                other.assignCorrespondentFrom,
                other.assignCorrespondent,
                other.assignDocumentType,
                other.assignOwnerFromRule,
                other.order,
                other.attachmentType,
                other.consumptionScope,
                other.pdfLayout,
                other.owner,
                other.userCanChange,
              ],
            );
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      mapPropsToHashCode([
        id,
        name,
        account,
        enabled,
        folder,
        filterFrom,
        filterTo,
        filterSubject,
        filterBody,
        filterAttachmentFilenameInclude,
        filterAttachmentFilenameExclude,
        maximumAge,
        action,
        actionParameter,
        assignTitleFrom,
        assignTags,
        assignCorrespondentFrom,
        assignCorrespondent,
        assignDocumentType,
        assignOwnerFromRule,
        order,
        attachmentType,
        consumptionScope,
        pdfLayout,
        owner,
        userCanChange,
      ]);

  factory MailRule.fromJson(Map<String, dynamic> json) =>
      _$MailRuleFromJson(json);

  Map<String, dynamic> toJson() => _$MailRuleToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
