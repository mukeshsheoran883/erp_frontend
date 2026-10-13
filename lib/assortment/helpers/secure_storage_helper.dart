import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageHelper {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  static Future<void> saveInt({required String key, required int dataToStore}) async {
    await _storage.write(key: key, value: dataToStore.toString());
  }

  static Future<int?> getInt({required String key}) async {
    final String? data = await _storage.read(key: key);
    if (data == null) return null;
    try {
      return int.parse(data);
    } catch (_) {
      return null;
    }
  }

  static Future<void> saveString({required String key, required String dataToStore}) async {
    await _storage.write(key: key, value: dataToStore);
  }

  static Future<String?> getString({required String key}) async {
    return _storage.read(key: key);
  }

  static Future<void> saveBool({required String key, required bool dataToStore}) async {
    await _storage.write(key: key, value: dataToStore.toString());
  }

  static Future<bool?> getBool({required String key}) async {
    final String? data = await _storage.read(key: key);
    if (data == 'true') return true;
    if (data == 'false') return false;

    return null;
  }

  static Future<void> saveList({required String key, required List dataToStore}) async {
    await _storage.write(key: key, value: json.encode(dataToStore));
  }

  static Future<List?> getList({required String key}) async {
    final String? data = await _storage.read(key: key);
    if (data == null) return null;
    try {
      return List.from(json.decode(data) as List);
    } catch (_) {
      return null;
    }
  }

  static Future<void> clear(String key) async {
    await _storage.delete(key: key);
  }

  static Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
