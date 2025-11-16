import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/store/slices/global_settings.dart';
import 'package:paperless_mobile/core/store/slices/local_user_app_state.dart';
import 'package:paperless_mobile/core/store/slices/local_user_data.dart';
import 'package:paperless_mobile/features/logging/data/logger.dart';

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

  void acknowledgeHint(String hintKey) {
    if (!state.readHints.contains(hintKey)) {
      final updatedHints = List<String>.from(state.readHints)..add(hintKey);
      emit(state.copyWith(readHints: updatedHints));
    }
  }

  void updateCurrentDocumentFilter(
    DocumentFilter Function(DocumentFilter) updater,
  ) {
    updateLoggedInUserAppState(
      (appState) => appState.copyWith(
        currentDocumentFilter: updater(appState.currentDocumentFilter),
      ),
    );
  }

  void setLoggedInUserId(String? userId) {
    emit(state.copyWith(loggedInUserId: userId));
  }

  void updateGlobalSettings(GlobalSettings newSettings) {
    emit(state.copyWith(globalSettings: newSettings));
  }

  void updateLoggedInUserAppState(
    LocalUserAppState Function(LocalUserAppState) updater,
  ) {
    if (state.loggedInUserId == null) {
      logger.fw(
        'could not update app state of logged in user because no user is logged in',
        className: runtimeType.toString(),
        methodName: 'updateLoggedInUserAppState',
      );
    }
    state.loggedInUserId;
  }

  void updateUserData(
    String userId,
    LocalUserData Function(LocalUserData?) updater,
  ) {
    emit(
      state.copyWith(
        localUserData: {
          ...state.localUserData,
          userId: updater(state.localUserData[userId]),
        },
      ),
    );
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
