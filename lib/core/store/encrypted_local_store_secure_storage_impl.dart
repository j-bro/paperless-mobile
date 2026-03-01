import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:paperless_mobile/core/store/encrypted_local_store.dart';

class EncryptedLocalStoreSecureStorageImpl implements EncryptedLocalStore {
  final FlutterSecureStorage _secureStorage;

  EncryptedLocalStoreSecureStorageImpl(this._secureStorage);

  @override
  Future<void> write(String userId, EncryptedLocalStoreState value) async {
    await _secureStorage.write(key: userId, value: jsonEncode(value.toJson()));
  }

  @override
  Future<EncryptedLocalStoreState?> read(String userId) async {
    if (!await _secureStorage.containsKey(key: userId)) {
      return null;
    }
    final jsonString = await _secureStorage.read(key: userId);
    if (jsonString != null) {
      return EncryptedLocalStoreState.fromJson(jsonDecode(jsonString));
    }
    return null;
  }

  @override
  Future<void> clear(String userId) async {
    await _secureStorage.delete(key: userId);
  }

  @override
  Future<void> clearAll() async {
    await _secureStorage.deleteAll();
  }

  @override
  Future<bool> contains(String userId) {
    return _secureStorage.containsKey(key: userId);
  }
}
