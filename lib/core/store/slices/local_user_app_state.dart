import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:paperless_mobile/api/paperless_api.dart';
import 'package:paperless_mobile/features/settings/model/view_type.dart';

part 'local_user_app_state.g.dart';

@CopyWith()
@JsonSerializable()
class LocalUserAppState {
  final DocumentFilter currentDocumentFilter;
  final List<String> documentSearchHistory;
  final ViewType documentsPageViewType;
  final ViewType savedViewsViewType;
  final ViewType documentSearchViewType;

  const LocalUserAppState({
    this.currentDocumentFilter = DocumentFilter.initial,
    this.documentSearchHistory = const [],
    this.documentsPageViewType = ViewType.list,
    this.savedViewsViewType = ViewType.list,
    this.documentSearchViewType = ViewType.list,
  });

  factory LocalUserAppState.fromJson(Map<String, dynamic> json) =>
      _$LocalUserAppStateFromJson(json);

  Map<String, dynamic> toJson() => _$LocalUserAppStateToJson(this);
}
