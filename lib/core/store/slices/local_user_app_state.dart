import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:paperless_mobile/api/paperless_api.dart';
import 'package:paperless_mobile/features/settings/model/view_type.dart';

part 'local_user_app_state.freezed.dart';
part 'local_user_app_state.g.dart';

@freezed
abstract class LocalUserAppState with _$LocalUserAppState {
  const factory LocalUserAppState({
    @Default(DocumentFilter()) DocumentFilter currentDocumentFilter,
    @Default([]) List<String> documentSearchHistory,
    @Default(ViewType.list) ViewType documentsPageViewType,
    @Default(ViewType.list) ViewType savedViewsViewType,
    @Default(ViewType.list) ViewType documentSearchViewType,
  }) = _LocalUserAppState;

  factory LocalUserAppState.fromJson(Map<String, dynamic> json) =>
      _$LocalUserAppStateFromJson(json);
}
