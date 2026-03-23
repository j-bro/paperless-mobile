import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:paperless_mobile/api/models/rule_type_enum.dart';

part 'saved_view_filter_rule_request.freezed.dart';
part 'saved_view_filter_rule_request.g.dart';

@Freezed(toJson: true, fromJson: false)
abstract class SavedViewFilterRuleRequest with _$SavedViewFilterRuleRequest {
  factory SavedViewFilterRuleRequest({
    // minimum: 0.0
    // maximum: 2.147483647E9
    required RuleTypeEnum ruleType,
    String? value,
  }) = _SavedViewFilterRuleRequest;
}
