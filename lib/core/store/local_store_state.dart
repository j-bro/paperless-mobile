part of 'local_store.dart';

@freezed
abstract class LocalStoreState with _$LocalStoreState {
  const factory LocalStoreState({
    String? loggedInUserId,
    @Default([]) List<String> readHints,
    required GlobalSettings globalSettings,
    @Default({}) Map<String, LocalUserData> localUserData,
  }) = _LocalStoreState;

  factory LocalStoreState.fromJson(Map<String, dynamic> json) =>
      _$LocalStoreStateFromJson(json);
}
