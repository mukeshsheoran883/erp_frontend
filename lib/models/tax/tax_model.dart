import 'package:invently/assortment/utils/json_utils.dart';
import 'package:invently/models/common/listing_model.dart';

class TaxModel implements ListingModel {
  String name;
  double totalTax;
  Map<String, double> taxSplits;
  String taxCode;

  @override
  bool disabled;

  @override
  bool selected;

  TaxModel({
    required this.name,
    required this.totalTax,
    required this.taxSplits,
    required this.taxCode,
    required this.disabled,
    required this.selected,
  });

  factory TaxModel.fromJson(Map<String, dynamic> json) => TaxModel(
    name: json['name'] ?? '',
    totalTax: (json['totalTax'] ?? 0).toDouble(),
    taxSplits: (json['taxSplits'] as Map<String, dynamic>?)?.map(
          (key, value) => MapEntry(key, (value ?? 0).toDouble()),
    ) ??
        {},
    taxCode: json['taxCode'] ?? '',
    disabled: json['isActive'] == false,
    selected: false,
  );

  // Naya helper: taxSplits ko "CGST: 90, SGST: 90" jaisa string bana dega
  String get taxSplitsLabel => taxSplits.entries
      .map((e) => '${e.key.toUpperCase()}: ${_formatNum(e.value)}')
      .join(', ');

  // totalTax ko bhi clean format me dikhane ke liye (agar .0 hata na ho to)
  String get totalTaxLabel => _formatNum(totalTax);

  String _formatNum(double v) =>
      v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toString();

  Map<String, dynamic> toJson() => {
    'name': name,
    'total_tax': totalTax,
    'tax_splits': taxSplits,
    'tax_code': taxCode,
  };

  static List<TaxModel> listFromJson(Map<String, dynamic> json) =>
      List<TaxModel>.from(
          (Ju.gV(json, 'data') ?? []).map((x) => TaxModel.fromJson(x)));
}