//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fpdart/fpdart.dart';
import 'package:paperless_api/generated/lib/src/model/display_mode_enum.dart';
import 'package:paperless_api/generated/lib/src/model/saved_view_filter_rule_request.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';
import 'package:paperless_api/src/utils/patched_value.dart';

part 'patched_saved_view_request.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
  includeIfNull: false,
)
class PatchedSavedViewRequest {
  /// Returns a new [PatchedSavedViewRequest] instance.
  PatchedSavedViewRequest({
    this.name,

    this.showOnDashboard,

    this.showInSidebar,

    this.sortField,

    this.sortReverse,

    this.filterRules,

    this.pageSize,

    this.displayMode,

    this.displayFields,

    this.owner,
  });

  @JsonKey(name: r'name', includeIfNull: false)
  final Option<String?>? name;

  @JsonKey(name: r'show_on_dashboard', includeIfNull: false)
  final Option<bool?>? showOnDashboard;

  @JsonKey(name: r'show_in_sidebar', includeIfNull: false)
  final Option<bool?>? showInSidebar;

  @JsonKey(name: r'sort_field', includeIfNull: false)
  final Option<String?>? sortField;

  @JsonKey(name: r'sort_reverse', includeIfNull: false)
  final Option<bool?>? sortReverse;

  @JsonKey(name: r'filter_rules', includeIfNull: false)
  final Option<List<SavedViewFilterRuleRequest>?>? filterRules;

  // minimum: 1
  // maximum: 2147483647
  @JsonKey(name: r'page_size', includeIfNull: false)
  final Option<int?>? pageSize;

  @JsonKey(name: r'display_mode', includeIfNull: false)
  final Option<DisplayModeEnum?>? displayMode;

  @JsonKey(name: r'display_fields', includeIfNull: false)
  final Option<List<String>?>? displayFields;

  @JsonKey(name: r'owner', includeIfNull: false)
  final Option<int?>? owner;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is PatchedSavedViewRequest &&
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

  factory PatchedSavedViewRequest.fromJson(Map<String, dynamic> json) =>
      _$PatchedSavedViewRequestFromJson(json);

  Map<String, dynamic> toJson() =>
      processPatchedValueJson(_$PatchedSavedViewRequestToJson(this));

  @override
  String toString() {
    return toJson().toString();
  }
}
