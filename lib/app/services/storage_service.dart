import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/contracts/i_storage_service.dart';

class StorageService implements IStorageService {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  /// New/update key
  @override
  Future<void> write(String key, String value) async {
    await _secureStorage.write(key: key, value: value);
  }

  /// Read key
  @override
  Future<String?> read(String key) async {
    return await _secureStorage.read(key: key);
  }

  /// Delete key
  @override
  Future<void> delete(String key) async {
    await _secureStorage.delete(key: key);
  }

  /// Delete all key in storage
  @override
  Future<void> deleteAll() async {
    await _secureStorage.deleteAll();
  }
}
