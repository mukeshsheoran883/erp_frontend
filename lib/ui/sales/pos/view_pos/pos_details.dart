part of '../pos_screen.dart';

class PosDetails extends StatefulWidget {
  final String posCode;
  final String posId;

  const PosDetails({super.key, required this.posCode, required this.posId});

  @override
  State<PosDetails> createState() => _PosDetailsState();
}

class _PosDetailsState extends State<PosDetails> {
  Status posStatus = Status.loading;
  String? error;
  PosModel? model;
  late ScrollController scrollController;

  @override
  void initState() {
    scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((s) => _getPos());
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
      title: 'Performa Invoice Details',
      error: error,
      onRetry: _getPos,
      status: posStatus,
      builder: (context) {
        return CustomScrollBar(
          controller: scrollController,
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DetailsValueName(label: 'Pos Code', childText: model!.posCode),
                if (model!.customerName.isNotEmpty)
                  DetailsValueName(
                      label: 'Customer Name',
                      childText: model!.customerName.toFirstLetterUpperCase()),
                DetailsValueName(label: 'Status', childText: model!.status),
                DetailsValueName(
                    label: 'Payment Type',
                    childText:
                        model!.paymentType.isEmpty ? '-' : model!.paymentType),
                DetailsValueName(
                    label: 'Payment Status', childText: model!.paymentStatus),
                DetailsValueName(
                    label: 'Amount',
                    childText:
                        StaticValues.currencySymbol(model!.amount.toString())),
                DetailsValueName(
                  label: 'Discount',
                  childText: '${model!.discounts} ${model!.discountsUnit}',
                ),
                DetailsValueName(
                    label: 'Wave Off',
                    childText:
                        StaticValues.currencySymbol(model!.waveOff.toString())),
                if (model!.customerQuotationId != 0)
                  DetailsValueName(
                      label: 'Customer Quotation Id',
                      childText: model!.customerQuotationId.toString()),
                DetailsValueName(
                  label: 'Created Date',
                  childText: StaticValues.commonDateFormatSlash
                      .format(model!.createdDate),
                ),
                const SizedBox(height: 8),
                if (model!.dispatch.logisticsCharges != '' || model!.dispatch.logisticsCompany != '')...[
                  DetailsValueName(
                      label: 'Logistics Company',
                      childText: model!.dispatch.logisticsCompany.toString()), DetailsValueName(
                    label: 'Logistics Charges',
                    childText: model!.dispatch.logisticsCharges.toString()),],
                if (model!.items.isNotEmpty)
                  DetailsValueName(
                    label: 'Items',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: model!.items
                          .map(
                            (item) => Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.itemName.isEmpty
                                        ? item.itemCode
                                        : item.itemName,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Text('Item Code: ${item.itemCode}'),
                                  Text('Quantity: ${item.quantity}'),
                                  Text(
                                      'Price: ${StaticValues.currencySymbol(item.price.toString())}'),
                                  Text(
                                      'Tax: ${StaticValues.currencySymbol(item.tax.toString())}'),
                                  Text(
                                      'Discount: ${StaticValues.currencySymbol(item.discount.toString())}'),
                                  Text('Total: ${StaticValues.currencySymbol(
                                    item.total.toString(),
                                  )}'),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
      bottomButtons: posStatus == Status.success
          ? [
              ViewDetailsButtonModel.closeButton(),
            ]
          : [],
    );
  }

  Future<void> _getPos() async {
    posStatus = Status.loading;
    error = null;
    model = null;
    _refresh();

    final response =
        await PosService.getPos(posId: widget.posId, posCode: widget.posCode);

    if (!response.responseType.success || response.data == null) {
      error = response.firstError();
      posStatus = Status.error;
      _refresh();
      return;
    }

    model = response.data;
    posStatus = Status.success;
    _refresh();
  }

  void _refresh() => mounted ? setState(() {}) : null;
}
