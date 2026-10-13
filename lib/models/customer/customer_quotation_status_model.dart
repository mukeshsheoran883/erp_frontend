class CustomerQuotationStatusModel {
  int customerQuotationId;
  String status;

  CustomerQuotationStatusModel({
    required this.customerQuotationId,
    required this.status,
  });

  factory CustomerQuotationStatusModel.fromJson(Map<String, dynamic> json) => CustomerQuotationStatusModel(
        customerQuotationId: (json['customer_quotation_id'] ?? 0).toInt(),
        status: json['status'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'customer_quotation_id': customerQuotationId,
        'status': status,
      };
}
