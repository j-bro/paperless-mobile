import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:paperless_mobile/api/models/schedule_date_field_enum.dart';
import 'package:paperless_mobile/api/models/sources_enum.dart';
import 'package:paperless_mobile/api/models/workflow_trigger_matching_algorithm_enum.dart';
import 'package:paperless_mobile/api/models/workflow_trigger_type_enum.dart';
import 'package:paperless_mobile/api/utils/patched_value.dart';

part 'patched_workflow_trigger_request.g.dart';

@JsonSerializable(
  createFactory: false,
  createToJson: true,
  includeIfNull: false,
)
class PatchedWorkflowTriggerRequest {
  final PatchedValue<int?>? id;
  final PatchedValue<List<SourcesEnum>?>? sources;
  final PatchedValue<WorkflowTriggerTypeEnum?>? type;

  /// Only consume documents with a path that matches this if specified. Wildcards specified as * are allowed. Case insensitive.
  final PatchedValue<String?>? filterPath;

  /// Only consume documents which entirely match this filename if specified. Wildcards such as *.pdf or *invoice* are allowed. Case insensitive.
  final PatchedValue<String?>? filterFilename;
  final PatchedValue<int?>? filterMailrule;

  // minimum: 0.0
  // maximum: 2.147483647E9
  final PatchedValue<WorkflowTriggerMatchingAlgorithmEnum?>? matchingAlgorithm;
  final PatchedValue<String?>? match;
  final PatchedValue<bool?>? isInsensitive;
  final PatchedValue<List<int>?>? filterHasTags;
  final PatchedValue<int?>? filterHasCorrespondent;
  final PatchedValue<int?>? filterHasDocumentType;

  /// The number of days to offset the schedule trigger by.
  // minimum: -2147483648
  // maximum: 2147483647
  final PatchedValue<int?>? scheduleOffsetDays;

  /// If the schedule should be recurring.
  final PatchedValue<bool?>? scheduleIsRecurring;

  /// The number of days between recurring schedule triggers.
  // minimum: 1
  // maximum: 2147483647
  final PatchedValue<int?>? scheduleRecurringIntervalDays;

  /// The field to check for a schedule trigger.  * `added` - Added * `created` - Created * `modified` - Modified * `custom_field` - Custom Field
  final PatchedValue<ScheduleDateFieldEnum?>? scheduleDateField;
  final PatchedValue<int?>? scheduleDateCustomField;

  PatchedWorkflowTriggerRequest({
    this.id,
    this.sources,
    this.type,
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

  Map<String, dynamic> toJson() =>
      processPatchedValueJson(_$PatchedWorkflowTriggerRequestToJson(this));
}
