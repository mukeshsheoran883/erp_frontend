class CommonKeyValueModel {
  CommonKeyValueModel({required this.id, required this.value});

  String id;
  String value;

  factory CommonKeyValueModel.fromJson(Map<String, dynamic> json) => CommonKeyValueModel(
        id: (json['id'] ?? ''),
        value: (json['name'] ?? ''),
      );

  Map<String, dynamic> toJson() => {'id': id, 'name': value};

  /// functions to compare to [CommonKeyValueModel].
  bool valueEquals(CommonKeyValueModel model) => model.value == value;
  bool idEquals(CommonKeyValueModel model) => model.id == id;
  bool equals(CommonKeyValueModel model) => (valueEquals(model)) && idEquals(model);
}
