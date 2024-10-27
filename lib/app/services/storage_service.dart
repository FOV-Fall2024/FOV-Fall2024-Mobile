import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  /// New/update key
  Future<void> write(String key, String value) async {
    await _secureStorage.write(key: key, value: value);
  }

  /// Read key
  Future<String?> read(String key) async {
    return await _secureStorage.read(key: key);
  }

  /// Delete key
  Future<void> delete(String key) async {
    await _secureStorage.delete(key: key);
  }

  /// Delete all key in storage
  Future<void> deleteAll() async {
    await _secureStorage.deleteAll();
  }
}
