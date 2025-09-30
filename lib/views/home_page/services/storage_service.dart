import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  // Create a single secure storage instance
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  /// Save data to secure storage
  Future<void> writeData(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  /// Read data from secure storage
  Future<String?> readData(String key) async {
    return await _storage.read(key: key);
  }

  /// Delete specific key from storage
  Future<void> deleteData(String key) async {
    await _storage.delete(key: key);
  }

  /// Clear all data in secure storage
  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
