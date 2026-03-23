import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:paperless_mobile/api/models/rule_type_enum.dart';

part 'saved_view_filter_rule.freezed.dart';
part 'saved_view_filter_rule.g.dart';

@Freezed(toJson: false, fromJson: true)
abstract class SavedViewFilterRule with _$SavedViewFilterRule {
  factory SavedViewFilterRule({
    // minimum: 0.0
    // maximum: 2.147483647E9
    required RuleTypeEnum ruleType,
    String? value,
  }) = _SavedViewFilterRule;

  factory SavedViewFilterRule.fromJson(Map<String, dynamic> json) =>
      _$SavedViewFilterRuleFromJson(json);
}
