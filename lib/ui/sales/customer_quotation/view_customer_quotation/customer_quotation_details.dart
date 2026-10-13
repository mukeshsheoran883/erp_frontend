part of '../customer_quotation_screen.dart';

class CustomerQuotationDetails extends StatefulWidget {
  final String shopCode;

  const CustomerQuotationDetails({super.key, required this.shopCode});

  @override
  State<CustomerQuotationDetails> createState() =>
      _CustomerQuotationDetailsState();
}

class _CustomerQuotationDetailsState extends State<CustomerQuotationDetails> {
  Status quotationStatus = Status.loading;
  String? error;
  CustomerQuotationModel? model;
  late ScrollController scrollController;

  @override
  void initState() {
    scrollController = ScrollController();
    WidgetsBinding.instance
        .addPostFrameCallback((s) => _getCustomerQuotation());
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewDetailsSkeleton(
      title: 'Customer Quotation Details',
      error: error,
      onRetry: _getCustomerQuotation,
      status: quotationStatus,
      builder: (context) {
        return CustomScrollBar(
          controller: scrollController,
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DetailsValueName(
                  label: 'Customer Quotation Code ',
                  childText:
                      model!.customerQuotationCode.toFirstLetterUpperCase(),
                ),
                DetailsValueName(
                    label: 'Name',
                    childText: model!.customerName.toFirstLetterUpperCase()),
                DetailsValueName(
                    label: 'Customer Phone', childText: model!.customerPhone),
                DetailsValueName(label: 'Status', childText: model!.status),
                ...model!.items.expand(
                  (item) => [
                    DetailsValueName(
                        label: 'Item Name', childText: item.itemName),
                    DetailsValueName(
                        label: 'Item Code', childText: item.itemCode),
                    DetailsValueName(
                        label: 'Quantity', childText: item.quantity.toString()),
                  ],
                ),
              ],
            ),
          ),
        );
      },
      bottomButtons: quotationStatus == Status.success
          ? [
              ViewDetailsButtonModel.closeButton(),
            ]
          : [],
    );
  }

  Future<void> _getCustomerQuotation() async {
    quotationStatus = Status.loading;
    error = null;
    model = null;
    _refresh();

    final response = await CustomerQuotationService.getCustomerQuotation(
        customerQuotationCode: widget.shopCode);

    if (!response.responseType.success || response.data == null) {
      error = response.firstError();
      quotationStatus = Status.error;
      _refresh();
      return;
    }

    model = response.data;
    quotationStatus = Status.success;
    _refresh();
  }

  void _refresh() => mounted ? setState(() {}) : null;
}
