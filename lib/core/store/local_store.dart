import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:paperless_mobile/core/store/slices/global_settings.dart';
import 'package:paperless_mobile/core/store/slices/local_user_data.dart';

part 'local_store.freezed.dart';
part 'local_store.g.dart';
part 'local_store_state.dart';

class LocalStore extends HydratedCubit<LocalStoreState> {
  LocalStore(String defaultPreferredLocaleSubtag)
    : super(
        LocalStoreState(
          globalSettings: GlobalSettings(
            preferredLocaleSubtag: defaultPreferredLocaleSubtag,
          ),
        ),
      );

  void setLoggedInUserId(String? userId) {
    emit(state.copyWith(loggedInUserId: userId));
  }

  void updateGlobalSettings(GlobalSettings newSettings) {
    emit(state.copyWith(globalSettings: newSettings));
  }

  void updateUserData(String userId, LocalUserData data) {
    emit(state.copyWith(localUserData: {...state.localUserData, userId: data}));
  }

  void removeUserData(String userId) {
    final newUserData = {...state.localUserData};
    newUserData.remove(userId);
    emit(state.copyWith(localUserData: newUserData));
  }

  @override
  LocalStoreState? fromJson(Map<String, dynamic> json) {
    return LocalStoreState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(LocalStoreState state) => state.toJson();
}
