import 'package:invently/utils/globals.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class HiveHelper {
  static bool init(String? path) {
    try {
      Hive.init(path);

      return true;
    } catch (e, s) {
      Globals.logger.log(e.toString());
      debugPrintStack(stackTrace: s);

      return false;
    }
  }

  static Future<bool> deleteFromDisk(Box box) async {
    try {
      await box.clear();

      return true;
    } catch (e, s) {
      Globals.logger.log(e.toString());
      debugPrintStack(stackTrace: s);

      return false;
    }
  }

  static Future<(bool, Box?)> open(String boxName) async {
    try {
      final Box box = await Hive.openBox(boxName);

      return (true, box);
    } catch (e, s) {
      Globals.logger.log(e.toString());
      debugPrintStack(stackTrace: s);

      return (false, null);
    }
  }

  static Future<(bool, int?)> add(Box box, dynamic value) async {
    try {
      final int index = await box.add(value);

      return (true, index);
    } catch (e, s) {
      Globals.logger.log(e.toString());
      debugPrintStack(stackTrace: s);

      return (false, null);
    }
  }

  static Future<bool> put(Box box, String key, dynamic value) async {
    try {
      await box.put(key, value);

      return true;
    } catch (e, s) {
      Globals.logger.log(e.toString());
      debugPrintStack(stackTrace: s);

      return false;
    }
  }

  static Future<(bool, dynamic)> get(Box box, String key) async {
    try {
      final dynamic value = await box.get(key);

      Map<String, dynamic> d = {};

      /// This code checks whether the saved data is a Map and if its a Map then [Map.from] method is used to
      /// avoid type errors which happen when retrieving a saved map from Hive.
      if (value.runtimeType.toString().contains('Map<')) {
        d = Map<String, dynamic>.from(value as Map);

        return (true, d);
      }

      return (true, value);
    } catch (e, s) {
      Globals.logger.log(e.toString());
      debugPrintStack(stackTrace: s);

      return (false, null);
    }
  }

  static Future<(bool, List)> getAll(Box box) async {
    try {
      bool hasError = false;
      List itemList = [];
      for (int i = 0; i < box.length; i++) {
        final data = await getAt(box, i);

        if (data.$1) {
          itemList.add(data.$2);
        } else {
          hasError = true;
        }
      }

      return (hasError, itemList);
    } catch (e, s) {
      Globals.logger.log(e.toString());
      debugPrintStack(stackTrace: s);

      return (false, []);
    }
  }

  static Future<(bool, dynamic)> getAt(Box box, int index) async {
    try {
      final dynamic value = await box.getAt(index);

      return (true, value);
    } catch (e, s) {
      Globals.logger.log(e.toString());
      debugPrintStack(stackTrace: s);

      return (false, null);
    }
  }

  static Future<bool> clearValue(Box box, String key) async {
    try {
      await box.delete(key);

      return true;
    } catch (e, s) {
      Globals.logger.log(e.toString());
      debugPrintStack(stackTrace: s);

      return false;
    }
  }
}
