part of '../bill_history_screen.dart';

class InvoiceDetails extends StatefulWidget {
  final String invoiceCode;

  const InvoiceDetails({super.key, required this.invoiceCode});

  @override
  State<InvoiceDetails> createState() => _InvoiceDetailsState();
}

class _InvoiceDetailsState extends State<InvoiceDetails> {
  Status invoiceStatus = Status.loading;
  String? error;
  BillHistoryModel? invoice;
  late ScrollController scrollController;
  List<String> permissionList = [];

  @override
  void initState() {
    scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((s) => _getInvoice());
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
      title: 'Invoice Details',
      error: error,
      onRetry: _getInvoice,
      status: invoiceStatus,
      builder: (context) {
        return CustomScrollBar(
          controller: scrollController,
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DetailsValueName(label: 'Bill Number', childText: invoice!.billNumber),
                DetailsValueName(label: 'Shop Code', childText: invoice!.shopCode),
                DetailsValueName(label: 'Billed By', childText: invoice!.billedBy),
                DetailsValueName(
                  label: 'Date & Time',
                  childText:
                  '${StaticValues.commonDateFormatSlash.format(invoice!.date)}  ${StaticValues.commonTimeFormat.format(invoice!.date)}',
                ),
                DetailsValueName(
                  label: 'Discount',
                  childText: invoice!.discountsUnit == 'percentage'
                      ? '${invoice!.discounts}%'
                      : StaticValues.currencySymbol(invoice!.discounts.toString()),
                ),
                DetailsValueName(label: 'Wave Off', childText: StaticValues.currencySymbol(invoice!.waveOff.toString())),
                DetailsValueName(label: 'Amount', childText: StaticValues.currencySymbol(invoice!.amount.toString())),

                // DetailsValueName(label: 'Name', childText: invoice!.itemCode.toFirstLetterUpperCase()),
                // DetailsValueName(label: 'Email', childText: invoice!.itemCode),
                // DetailsValueName(
                //   label: 'Phone',
                //   childText: StaticValues.mobileFormatter(
                //     code: invoice!.mobileNumberDailCode,
                //     number: invoice!.mobileNumber,
                //   ),
                // ),
                // DetailsValueName(label: 'ID Unique Number', childText: '${invoice!.idType}: ${invoice!.idNumber}'),
                // DetailsValueName(label: 'Organisation Name', childText: invoice!.organisationName),
                // DetailsValueName(label: 'Occupation', childText: invoice!.occupation),
                // DetailsValueName(
                //   label: 'Date of Birth',
                //   childText: StaticValues.commonDateFormatSlash.format(invoice!.dateOfBirth),
                // ),
                // DetailsValueName(label: 'Education', childText: customer!.education),
                // DetailsValueName(label: 'Religion', childText: customer!.religion),
                // DetailsValueName(label: 'Blood group', childText: customer!.bloodGroup),
                // DetailsValueName(label: 'Marital Status', childText: customer!.martialStatus),
                // DetailsValueName(
                //   label: 'Added Date & Time',
                //   childText: StaticValues.commonDateFormatSlash.format(customer!.createdDateTime),
                // ),
                // DetailsValueName(label: 'Country', childText: customer!.country),
                // DetailsValueName(label: 'State of Province', childText: customer!.state),
                // DetailsValueName(label: 'Address', childText: customer!.street),

                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text('Items', style: Ts.mdBold(color: Tm.color(Tc.txtH3))),
                ),
                const SizedBox(height: 8),

                ...invoice!.items.map(
                      (item) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.itemName, style: Ts.rgRegular(color: Tm.color(Tc.tableConTxt))),
                              Text(item.itemCode, style: Ts.mdRegular(color: Tm.color(Tc.tableConSubTxt))),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'Qty: ${item.quantity.toStringAsFixed(0)}',
                            style: Ts.rgRegular(color: Tm.color(Tc.tableConTxt)),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            StaticValues.currencySymbol(item.totalPrice.toString()),
                            style: Ts.rgRegular(color: Tm.color(Tc.tableConTxt)),
                            textAlign: TextAlign.end,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      bottomButtons: invoiceStatus == Status.success
          ? [
        ViewDetailsButtonModel.closeButton(),
        ViewDetailsButtonModel.deleteButton(() async {
          // bool deleted = await _deleteCustomer([customer!]);
          // if (deleted) AppNavigator.pop();
        }),
        ViewDetailsButtonModel.editButton(() {
          AppNavigator.pop();
          // AppNavigator.navigate(
          // AppRoutes.customersEdit(data: AddEditCustomerScreen(customerCode: widget.customerCode)),
          // );
        }),
      ]
          : [],
    );
  }

  Future<void> _getInvoice() async {
    invoiceStatus = Status.loading;
    error = null;
    invoice = null;
    _refresh();

    final response = await BillHistoryService.getBillHistory(billHistoryCode: widget.invoiceCode);

    if (!response.responseType.success || response.data == null) {
      error = response.firstError();
      invoiceStatus = Status.error;
      _refresh();
      return;
    }

    invoice = response.data;
    invoiceStatus = Status.success;
    _refresh();
  }

  void _refresh() => mounted ? setState(() {}) : null;
}