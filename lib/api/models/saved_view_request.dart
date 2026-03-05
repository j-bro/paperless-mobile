//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:paperless_mobile/api/models/display_mode_enum.dart';
import 'package:paperless_mobile/api/models/saved_view_filter_rule_request.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'saved_view_request.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class SavedViewRequest {
  /// Returns a new [SavedViewRequest] instance.
  SavedViewRequest({
    required this.name,

    required this.showOnDashboard,

    required this.showInSidebar,

    this.sortField,

    this.sortReverse,

    required this.filterRules,

    this.pageSize,

    this.displayMode,

    this.displayFields,

    this.owner,
  });

  @JsonKey(name: r'name', required: true, includeIfNull: false)
  final String name;

  @JsonKey(name: r'show_on_dashboard', required: true, includeIfNull: false)
  final bool showOnDashboard;

  @JsonKey(name: r'show_in_sidebar', required: true, includeIfNull: false)
  final bool showInSidebar;

  @JsonKey(name: r'sort_field', required: false, includeIfNull: false)
  final String? sortField;

  @JsonKey(name: r'sort_reverse', required: false, includeIfNull: false)
  final bool? sortReverse;

  @JsonKey(name: r'filter_rules', required: true, includeIfNull: false)
  final List<SavedViewFilterRuleRequest> filterRules;

  // minimum: 1
  // maximum: 2147483647
  @JsonKey(name: r'page_size', required: false, includeIfNull: false)
  final int? pageSize;

  @JsonKey(name: r'display_mode', required: false, includeIfNull: false)
  final DisplayModeEnum? displayMode;

  @JsonKey(name: r'display_fields', required: false, includeIfNull: false)
  final List<String>? displayFields;

  @JsonKey(name: r'owner', required: false, includeIfNull: false)
  final int? owner;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is SavedViewRequest &&
            runtimeType == other.runtimeType &&
            equals(
              [
                name,
                showOnDashboard,
                showInSidebar,
                sortField,
                sortReverse,
                filterRules,
                pageSize,
                displayMode,
                displayFields,
                owner,
              ],
              [
                other.name,
                other.showOnDashboard,
                other.showInSidebar,
                other.sortField,
                other.sortReverse,
                other.filterRules,
                other.pageSize,
                other.displayMode,
                other.displayFields,
                other.owner,
              ],
            );
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      mapPropsToHashCode([
        name,
        showOnDashboard,
        showInSidebar,
        sortField,
        sortReverse,
        filterRules,
        pageSize,
        displayMode,
        displayFields,
        owner,
      ]);

  factory SavedViewRequest.fromJson(Map<String, dynamic> json) =>
      _$SavedViewRequestFromJson(json);

  Map<String, dynamic> toJson() => _$SavedViewRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
