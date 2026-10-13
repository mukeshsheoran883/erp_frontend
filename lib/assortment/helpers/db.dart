import 'dart:convert';

import 'package:invently/utils/static_keys.dart';

import 'hive_helper.dart';

class DB {
  factory DB() => _instance;
  DB._privateConstructor();

  static final DB _instance = DB._privateConstructor();

  ///[clearAllDB] clears all the hive boxes and is called at logout
  static Future<void> clearAllDB() async {
    try {
      await CommonDB().deleteFromDisk();
      await LogDB().deleteFromDisk();
    } catch (_) {}
  }
}

class CommonDB {
  factory CommonDB() => _instance;
  CommonDB._privateConstructor();

  static final CommonDB _instance = CommonDB._privateConstructor();
  final String _location = StaticKeys.commonDbLocation();

  Future<dynamic> getValue({required String key}) async {
    final (success, box) = await HiveHelper.open(_location);
    if (!success) return null;

    if (!box!.containsKey(key)) {
      return null;
    }
    final record = await HiveHelper.get(box, key);

    /// This code checks whether the saved data is a Map and if its a Map then [Map.from] method is used to
    /// avoid type errors which happen when retrieving a saved map from Hive.
    // ignore: avoid_dynamic_calls
    if (record.$2.runtimeType.toString().contains('Map<')) {
      return jsonDecode(jsonEncode(record.$2).replaceAll('{}', 'null'));
    }

    return record.$2;
  }

  Future<bool> saveValue({required String key, required dynamic value}) async {
    final (success, box) = await HiveHelper.open(_location);
    if (!success || box == null) return false;

    return await HiveHelper.put(box, key, value);
  }

  Future<bool> clearValue({required String key}) async {
    final (success, box) = await HiveHelper.open(_location);
    if (!success || box == null) return false;
    if (box.containsKey(key)) return await HiveHelper.clearValue(box, key);

    return false;
  }

  Future<bool> deleteFromDisk() async {
    final (success, box) = await HiveHelper.open(_location);
    if (!success || box == null) return false;
    return await HiveHelper.deleteFromDisk(box);
  }
}

class LogDB {
  factory LogDB() => _instance;
  LogDB._privateConstructor();

  static final LogDB _instance = LogDB._privateConstructor();
  final String _location = StaticKeys.logDbLocation();

  Future<dynamic> getValue({required String key}) async {
    final (success, box) = await HiveHelper.open(_location);
    if (!success) return null;

    if (!box!.containsKey(key)) {
      return null;
    }
    final record = await HiveHelper.get(box, key);

    /// This code checks whether the saved data is a Map and if its a Map then [Map.from] method is used to
    /// avoid type errors which happen when retrieving a saved map from Hive.
    // ignore: avoid_dynamic_calls
    if (record.$2.runtimeType.toString().contains('Map<')) {
      return jsonDecode(jsonEncode(record.$2).replaceAll('{}', 'null'));
    }

    return record.$2;
  }

  Future<List> getAllValue() async {
    final (success, box) = await HiveHelper.open(_location);
    if (!success || box == null) return [];

    final record = await HiveHelper.getAll(box);
    return record.$2;
  }

  Future<bool> saveValue({required String key, required dynamic value}) async {
    final (success, box) = await HiveHelper.open(_location);
    if (!success || box == null) return false;

    return await HiveHelper.put(box, key, value);
  }

  Future<bool> addValue({required dynamic value}) async {
    final (success, box) = await HiveHelper.open(_location);
    if (!success || box == null) return false;

    return (await HiveHelper.add(box, value)).$1;
  }

  Future<bool> clearValue({required String key}) async {
    final (success, box) = await HiveHelper.open(_location);
    if (!success || box == null) return false;
    if (box.containsKey(key)) return await HiveHelper.clearValue(box, key);

    return false;
  }

  Future<bool> deleteFromDisk() async {
    final (success, box) = await HiveHelper.open(_location);
    if (!success || box == null) return false;
    return await HiveHelper.deleteFromDisk(box);
  }
}
