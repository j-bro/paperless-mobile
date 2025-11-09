import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:paperless_mobile/core/store/slices/user_credentials.dart';

part 'encrypted_local_store.freezed.dart';
part 'encrypted_local_store.g.dart';
part 'encrypted_local_store_state.dart';

abstract interface class EncryptedLocalStore {
  Future<bool> contains(String userId);
  Future<void> write(String userId, EncryptedLocalStoreState value);
  Future<EncryptedLocalStoreState?> read(String userId);
  Future<void> clear(String userId);
  Future<void> clearAll();
}
