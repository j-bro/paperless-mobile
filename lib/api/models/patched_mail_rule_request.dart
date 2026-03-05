//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fpdart/fpdart.dart';
import 'package:paperless_mobile/api/models/pdf_layout_enum.dart';
import 'package:paperless_mobile/api/models/assign_title_from_enum.dart';
import 'package:paperless_mobile/api/models/consumption_scope_enum.dart';
import 'package:paperless_mobile/api/models/attachment_type_enum.dart';
import 'package:paperless_mobile/api/models/mail_rule_action_enum.dart';
import 'package:paperless_mobile/api/models/assign_correspondent_from_enum.dart';
import 'package:paperless_mobile/api/models/correspondent_request_set_permissions.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';
import 'package:paperless_mobile/api/utils/patched_value.dart';

part 'patched_mail_rule_request.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
  includeIfNull: false,
)
class PatchedMailRuleRequest {
  /// Returns a new [PatchedMailRuleRequest] instance.
  PatchedMailRuleRequest({
    this.name,

    this.account,

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

    this.actionParameter,

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

    this.setPermissions,
  });

  @JsonKey(name: r'name', required: false)
  final Option<String?>? name;

  @JsonKey(name: r'account', required: false)
  final Option<int?>? account;

  @JsonKey(name: r'enabled', required: false)
  final Option<bool?>? enabled;

  /// Subfolders must be separated by a delimiter, often a dot ('.') or slash ('/'), but it varies by mail server.
  @JsonKey(name: r'folder', required: false)
  final Option<String?>? folder;

  @JsonKey(name: r'filter_from', required: false)
  final Option<String?>? filterFrom;

  @JsonKey(name: r'filter_to', required: false)
  final Option<String?>? filterTo;

  @JsonKey(name: r'filter_subject', required: false)
  final Option<String?>? filterSubject;

  @JsonKey(name: r'filter_body', required: false)
  final Option<String?>? filterBody;

  /// Only consume documents which entirely match this filename if specified. Wildcards such as *.pdf or *invoice* are allowed. Case insensitive.
  @JsonKey(name: r'filter_attachment_filename_include', required: false)
  final Option<String?>? filterAttachmentFilenameInclude;

  /// Do not consume documents which entirely match this filename if specified. Wildcards such as *.pdf or *invoice* are allowed. Case insensitive.
  @JsonKey(name: r'filter_attachment_filename_exclude', required: false)
  final Option<String?>? filterAttachmentFilenameExclude;

  /// Specified in days.
  // minimum: 0
  // maximum: 2147483647
  @JsonKey(name: r'maximum_age', required: false)
  final Option<int?>? maximumAge;

  // minimum: 0.0
  // maximum: 2.147483647E9
  @JsonKey(name: r'action', required: false)
  final Option<MailRuleActionEnum?>? action;

  @JsonKey(name: r'action_parameter', required: false)
  final Option<String?>? actionParameter;

  // minimum: 0.0
  // maximum: 2.147483647E9
  @JsonKey(name: r'assign_title_from', required: false)
  final Option<AssignTitleFromEnum?>? assignTitleFrom;

  @JsonKey(name: r'assign_tags', required: false)
  final Option<List<int>?>? assignTags;

  // minimum: 0.0
  // maximum: 2.147483647E9
  @JsonKey(
    name: r'assign_correspondent_from',
    required: false,
    includeIfNull: false,
  )
  final Option<AssignCorrespondentFromEnum?>? assignCorrespondentFrom;

  @JsonKey(name: r'assign_correspondent', required: false)
  final Option<int?>? assignCorrespondent;

  @JsonKey(name: r'assign_document_type', required: false)
  final Option<int?>? assignDocumentType;

  @JsonKey(
    name: r'assign_owner_from_rule',
    required: false,
    includeIfNull: false,
  )
  final Option<bool?>? assignOwnerFromRule;

  @JsonKey(name: r'order', required: false)
  final Option<int?>? order;

  /// Inline attachments include embedded images, so it's best to combine this option with a filename filter.  * `1` - Only process attachments. * `2` - Process all files, including 'inline' attachments.
  // minimum: 0.0
  // maximum: 2.147483647E9
  @JsonKey(name: r'attachment_type', required: false)
  final Option<AttachmentTypeEnum?>? attachmentType;

  // minimum: 0.0
  // maximum: 2.147483647E9
  @JsonKey(name: r'consumption_scope', required: false)
  final Option<ConsumptionScopeEnum?>? consumptionScope;

  // minimum: 0.0
  // maximum: 2.147483647E9
  @JsonKey(name: r'pdf_layout', required: false)
  final Option<PdfLayoutEnum?>? pdfLayout;

  @JsonKey(name: r'owner', required: false)
  final Option<int?>? owner;

  @JsonKey(name: r'set_permissions', required: false)
  final Option<CorrespondentRequestSetPermissions?>? setPermissions;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is PatchedMailRuleRequest &&
            runtimeType == other.runtimeType &&
            equals(
              [
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
                setPermissions,
              ],
              [
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
                other.setPermissions,
              ],
            );
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      mapPropsToHashCode([
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
        setPermissions,
      ]);

  factory PatchedMailRuleRequest.fromJson(Map<String, dynamic> json) =>
      _$PatchedMailRuleRequestFromJson(json);

  Map<String, dynamic> toJson() =>
      processPatchedValueJson(_$PatchedMailRuleRequestToJson(this));

  @override
  String toString() {
    return toJson().toString();
  }
}
