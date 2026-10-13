import 'package:invently/assortment/utils/json_utils.dart';
import 'package:invently/models/common/listing_model.dart';

class StockRejectedTransferModel implements ListingModel {
  String slNo;
  String requestId;
  String raisedBy;
  String date;
  String time;

  StockRejectedTransferModel({
    required this.slNo,
    required this.requestId,
    required this.raisedBy,
    required this.date,
    required this.time,
    required this.disabled,
    required this.selected,
  });

  factory StockRejectedTransferModel.fromJson(Map<String, dynamic> json) => StockRejectedTransferModel(
        slNo: json['slNo'] ?? '',
        requestId: json['requestId'] ?? '',
        raisedBy: json['raisedBy'] ?? '',
        date: json['date'] ?? '',
        time: json['time'] ?? '',
        disabled: json['isActive'] == false,
        selected: false,
      );

  Map<String, dynamic> toJson() => {
        'purchase_id': requestId,
        'supplier_name': slNo,
      };

  static List<StockRejectedTransferModel> listFromJson(Map<String, dynamic> json) =>
      List<StockRejectedTransferModel>.from(
        (Ju.gV(json, 'data') ?? []).map((x) => StockRejectedTransferModel.fromJson(x)),
      );

  @override
  bool disabled;

  @override
  bool selected;
}
