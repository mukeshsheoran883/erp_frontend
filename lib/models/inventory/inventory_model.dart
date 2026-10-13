import 'package:invently/assortment/utils/json_utils.dart';
import 'package:invently/models/common/listing_model.dart';

class InventoryModel implements ListingModel {
  String inventoryId;
  String inventoryCode;
  String itemCode;
  String itemName;
  String description;
  String shopCode;
  String shopName;
  DateTime expiryDate;
  double price;
  int balanceQty;
  DateTime createdTime;
  String storeMapping;

  @override
  bool disabled;

  @override
  bool selected;

  InventoryModel({
    required this.inventoryId,
    required this.inventoryCode,
    required this.itemCode,
    required this.itemName,
    required this.description,
    required this.shopCode,
    required this.shopName,
    required this.expiryDate,
    required this.price,
    required this.balanceQty,
    required this.createdTime,
    required this.storeMapping,
    required this.disabled,
    required this.selected,
  });

  factory InventoryModel.fromJson(Map<String, dynamic> json) {
    return InventoryModel(
      inventoryId: json['inventoryId']?.toString() ?? '',
      inventoryCode: json['inventoryCode']?.toString() ?? '',
      itemCode: json['itemCode']?.toString() ?? '',
      itemName: json['itemName']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      shopCode: json['shopCode']?.toString() ?? '',
      shopName: json['shopName']?.toString() ?? '',

      expiryDate: _parseDateTime(
        json['expiryDate'],
      ),

      price: _parseDouble(
        json['price'],
      ),

      balanceQty: _parseInt(
        json['balanceQty'],
      ),

      createdTime: _parseDateTime(
        json['createdTime'],
      ),

      storeMapping: json['storeMapping']?.toString() ?? '',

      disabled: json['isActive'] == false,

      selected: false,
    );
  }

  Map<String, dynamic> toJson() => {
    'item_code': itemCode,
    'shop_code': shopCode,
    'expiry_date':
    '${expiryDate.year.toString().padLeft(4, '0')}-'
        '${expiryDate.month.toString().padLeft(2, '0')}-'
        '${expiryDate.day.toString().padLeft(2, '0')}',
    'price': price.toString(),
    'balance_qty': balanceQty,
    'store_mapping': storeMapping,
    'inventory_id': inventoryId,
  };

  static List<InventoryModel> listFromJson(
      Map<String, dynamic> json,
      ) =>
      List<InventoryModel>.from(
        (Ju.gV(json, 'data') ?? [])
            .map(
              (x) => InventoryModel.fromJson(
            Map<String, dynamic>.from(x),
          ),
        ),
      );

  // ============================================================
  // HELPERS
  // ============================================================

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;

    if (value is double) return value;

    if (value is int) {
      return value.toDouble();
    }

    return double.tryParse(
      value.toString().replaceAll(',', ''),
    ) ??
        0.0;
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;

    if (value is int) return value;

    if (value is double) {
      return value.toInt();
    }

    return int.tryParse(
      value.toString(),
    ) ??
        0;
  }

  static DateTime _parseDateTime(dynamic value) {
    if (value == null) {
      return DateTime.now();
    }

    if (value is DateTime) {
      return value;
    }

    return DateTime.tryParse(
      value.toString(),
    ) ??
        DateTime.now();
  }
}




class InventoryLogModel implements ListingModel {
  int logId;
  int inventoryId;
  String inventoryCode;
  DateTime changeDate;
  String eventType;
  String batchId;
  String status;
  String errorMessage;
  @override
  bool disabled;

  @override
  bool selected;

  InventoryLogModel({
    required this.logId,
    required this.inventoryId,
    required this.inventoryCode,
    required this.changeDate,
    required this.eventType,
    required this.batchId,
    required this.status,
    required this.errorMessage,
    required this.disabled,
    required this.selected,
  });

  factory InventoryLogModel.fromJson(Map<String, dynamic> json) => InventoryLogModel(
    logId: (json['log_id'] ?? 0).toInt(),
    inventoryId: (json['inventory_id'] ?? 0).toInt(),
    inventoryCode: json['inventory_code'] ?? '',
    changeDate: json['change_date'] != null ? DateTime.parse(json['change_date']) : DateTime.now(),
    eventType: json['eventtype'] ?? '',
    batchId: json['batch_id'] ?? '',
    status: json['status'] ?? '',
    errorMessage: json['error_message'] ?? '',
    disabled: json['isActive'] == false,
    selected: false,
  );

  static List<InventoryLogModel> listFromJson(Map<String, dynamic> json) =>
      List<InventoryLogModel>.from((Ju.gV(json, 'data') ?? []).map((x) => InventoryLogModel.fromJson(x)));
}