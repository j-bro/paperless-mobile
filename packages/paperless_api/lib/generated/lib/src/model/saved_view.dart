//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:paperless_api/generated/lib/src/model/display_mode_enum.dart';
import 'package:paperless_api/generated/lib/src/model/saved_view_filter_rule.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'saved_view.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class SavedView {
  /// Returns a new [SavedView] instance.
  SavedView({
    required this.id,

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

    required this.userCanChange,
  });

  @JsonKey(name: r'id', required: true, includeIfNull: false)
  final int id;

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
  final List<SavedViewFilterRule> filterRules;

  // minimum: 1
  // maximum: 2147483647
  @JsonKey(name: r'page_size', required: false, includeIfNull: false)
  final int? pageSize;

  @JsonKey(name: r'display_mode', required: false, includeIfNull: false)
  final DisplayModeEnum? displayMode;

  @JsonKey(name: r'display_fields', required: false, includeIfNull: false)
  final Object? displayFields;

  @JsonKey(name: r'owner', required: false, includeIfNull: false)
  final int? owner;

  @JsonKey(name: r'user_can_change', required: true, includeIfNull: false)
  final bool userCanChange;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is SavedView &&
            runtimeType == other.runtimeType &&
            equals(
              [
                id,
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
                userCanChange,
              ],
              [
                other.id,
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
        showOnDashboard,
        showInSidebar,
        sortField,
        sortReverse,
        filterRules,
        pageSize,
        displayMode,
        displayFields,
        owner,
        userCanChange,
      ]);

  factory SavedView.fromJson(Map<String, dynamic> json) =>
      _$SavedViewFromJson(json);

  Map<String, dynamic> toJson() => _$SavedViewToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
