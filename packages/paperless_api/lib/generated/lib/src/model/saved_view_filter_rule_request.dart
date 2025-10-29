//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:paperless_api/generated/lib/src/model/rule_type_enum.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'saved_view_filter_rule_request.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class SavedViewFilterRuleRequest {
  /// Returns a new [SavedViewFilterRuleRequest] instance.
  SavedViewFilterRuleRequest({required this.ruleType, this.value});

  // minimum: 0.0
  // maximum: 2.147483647E9
  @JsonKey(name: r'rule_type', required: true, includeIfNull: false)
  final RuleTypeEnum ruleType;

  @JsonKey(name: r'value', required: false, includeIfNull: false)
  final String? value;

  bool operator ==(Object other) {
    return identical(this, other) ||
        other is SavedViewFilterRuleRequest &&
            runtimeType == other.runtimeType &&
            equals([ruleType, value], [other.ruleType, other.value]);
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ mapPropsToHashCode([ruleType, value]);

  factory SavedViewFilterRuleRequest.fromJson(Map<String, dynamic> json) =>
      _$SavedViewFilterRuleRequestFromJson(json);

  Map<String, dynamic> toJson() => _$SavedViewFilterRuleRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
