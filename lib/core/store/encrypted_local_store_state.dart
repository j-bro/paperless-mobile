part of 'encrypted_local_store.dart';

@freezed
abstract class EncryptedLocalStoreState with _$EncryptedLocalStoreState {
  factory EncryptedLocalStoreState({required UserCredentials credentials}) =
      _EncryptedLocalStoreState;

  factory EncryptedLocalStoreState.fromJson(Map<String, dynamic> json) =>
      _$EncryptedLocalStoreStateFromJson(json);
}
