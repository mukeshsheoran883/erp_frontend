
import 'package:invently/assortment/extensions/string_extensions.dart';

class EmployeePermissionGroupModel {
  String moduleName;
  String description;
  String jsonKey;
  List<EmployeePermissionModel> subModules = [];

  EmployeePermissionGroupModel({required this.moduleName, required this.description, required this.jsonKey});

  bool hasPermission() => subModules.where((e) => e.hasPermission).isNotEmpty;

  bool isAllPermissionGranted() => !subModules.where((e) => !e.hasPermission).isNotEmpty;

  MapEntry<String, Map<String, bool>> toJsonEntry() =>
      MapEntry(jsonKey.toSnakeCase(), Map.fromEntries(subModules.map((r) => r.toJsonEntry())));

  void setPermissionFromJson(Map<String, dynamic> json) {
    for (final i in subModules) {
      i.setPermissionFromJson(Map<String, bool>.from(json[jsonKey.toCamelCase()] ?? {}));
    }
  }
}

class EmployeePermissionModel {
  String moduleName;
  String description;
  bool hasPermission;
  String jsonKey;

  EmployeePermissionModel({
    required this.moduleName,
    required this.description,
    required this.hasPermission,
    required this.jsonKey,
  });

  MapEntry<String, bool> toJsonEntry() => MapEntry(jsonKey.toSnakeCase(), hasPermission);

  void setPermissionFromJson(Map<String, bool> json) => hasPermission = json[jsonKey.toCamelCase()] ?? false;
}
