//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:paperless_api/generated/lib/src/model/workflow_trigger_matching_algorithm_enum.dart';
import 'package:paperless_api/generated/lib/src/model/schedule_date_field_enum.dart';
import 'package:paperless_api/generated/lib/src/model/workflow_trigger_type_enum.dart';
import 'package:paperless_api/generated/lib/src/model/sources_enum.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'workflow_trigger_request.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class WorkflowTriggerRequest {
  /// Returns a new [WorkflowTriggerRequest] instance.
  WorkflowTriggerRequest({
    this.id,

    this.sources,

    required this.type,

    this.filterPath,

    this.filterFilename,

    this.filterMailrule,

    this.matchingAlgorithm,

    this.match,

    this.isInsensitive,

    this.filterHasTags,

    this.filterHasCorrespondent,

    this.filterHasDocumentType,

    this.scheduleOffsetDays,

    this.scheduleIsRecurring,

    this.scheduleRecurringIntervalDays,

    this.scheduleDateField,

    this.scheduleDateCustomField,
  });

  @JsonKey(name: r'id', required: false, includeIfNull: false)
  final int? id;

  @JsonKey(name: r'sources', required: false, includeIfNull: false)
  final List<SourcesEnum>? sources;

  @JsonKey(name: r'type', required: true, includeIfNull: false)
  final WorkflowTriggerTypeEnum type;

  /// Only consume documents with a path that matches this if specified. Wildcards specified as * are allowed. Case insensitive.
  @JsonKey(name: r'filter_path', required: false, includeIfNull: false)
  final String? filterPath;

  /// Only consume documents which entirely match this filename if specified. Wildcards such as *.pdf or *invoice* are allowed. Case insensitive.
  @JsonKey(name: r'filter_filename', required: false, includeIfNull: false)
  final String? filterFilename;

  @JsonKey(name: r'filter_mailrule', required: false, includeIfNull: false)
  final int? filterMailrule;

  // minimum: 0.0
  // maximum: 2.147483647E9
  @JsonKey(name: r'matching_algorithm', required: false, includeIfNull: false)
  final WorkflowTriggerMatchingAlgorithmEnum? matchingAlgorithm;

  @JsonKey(name: r'match', required: false, includeIfNull: false)
  final String? match;

  @JsonKey(name: r'is_insensitive', required: false, includeIfNull: false)
  final bool? isInsensitive;

  @JsonKey(name: r'filter_has_tags', required: false, includeIfNull: false)
  final List<int>? filterHasTags;

  @JsonKey(
    name: r'filter_has_correspondent',
    required: false,
    includeIfNull: false,
  )
  final int? filterHasCorrespondent;

  @JsonKey(
    name: r'filter_has_document_type',
    required: false,
    includeIfNull: false,
  )
  final int? filterHasDocumentType;

  /// The number of days to offset the schedule trigger by.
  // minimum: -2147483648
  // maximum: 2147483647
  @JsonKey(name: r'schedule_offset_days', required: false, includeIfNull: false)
  final int? scheduleOffsetDays;

  /// If the schedule should be recurring.
  @JsonKey(
    name: r'schedule_is_recurring',
    required: false,
    includeIfNull: false,
  )
  final bool? scheduleIsRecurring;

  /// The number of days between recurring schedule triggers.
  // minimum: 1
  // maximum: 2147483647
  @JsonKey(
    name: r'schedule_recurring_interval_days',
    required: false,
    includeIfNull: false,
  )
  final int? scheduleRecurringIntervalDays;

  /// The field to check for a schedule trigger.  * `added` - Added * `created` - Created * `modified` - Modified * `custom_field` - Custom Field
  @JsonKey(name: r'schedule_date_field', required: false, includeIfNull: false)
  final ScheduleDateFieldEnum? scheduleDateField;

  @JsonKey(
    name: r'schedule_date_custom_field',
    required: false,
    includeIfNull: false,
  )
  final int? scheduleDateCustomField;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is WorkflowTriggerRequest &&
            runtimeType == other.runtimeType &&
            equals(
              [
                id,
                sources,
                type,
                filterPath,
                filterFilename,
                filterMailrule,
                matchingAlgorithm,
                match,
                isInsensitive,
                filterHasTags,
                filterHasCorrespondent,
                filterHasDocumentType,
                scheduleOffsetDays,
                scheduleIsRecurring,
                scheduleRecurringIntervalDays,
                scheduleDateField,
                scheduleDateCustomField,
              ],
              [
                other.id,
                other.sources,
                other.type,
                other.filterPath,
                other.filterFilename,
                other.filterMailrule,
                other.matchingAlgorithm,
                other.match,
                other.isInsensitive,
                other.filterHasTags,
                other.filterHasCorrespondent,
                other.filterHasDocumentType,
                other.scheduleOffsetDays,
                other.scheduleIsRecurring,
                other.scheduleRecurringIntervalDays,
                other.scheduleDateField,
                other.scheduleDateCustomField,
              ],
            );
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      mapPropsToHashCode([
        id,
        sources,
        type,
        filterPath,
        filterFilename,
        filterMailrule,
        matchingAlgorithm,
        match,
        isInsensitive,
        filterHasTags,
        filterHasCorrespondent,
        filterHasDocumentType,
        scheduleOffsetDays,
        scheduleIsRecurring,
        scheduleRecurringIntervalDays,
        scheduleDateField,
        scheduleDateCustomField,
      ]);

  factory WorkflowTriggerRequest.fromJson(Map<String, dynamic> json) =>
      _$WorkflowTriggerRequestFromJson(json);

  Map<String, dynamic> toJson() => _$WorkflowTriggerRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
