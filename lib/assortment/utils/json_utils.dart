/// [Ju] represents JsonUtils
/// [gV] represents getValue
class Ju {
  static dynamic gV(Map<String, dynamic> json, String key) {
    final List<String> keys = key.split('.');
    dynamic value = json;

    for (final k in keys) {
      if (value is Map<String, dynamic> && value.containsKey(k)) {
        value = value[k];
      } else {
        return null;
      }
    }

    return value;
  }
}
