part of '../returned_purchase_screen.dart';

class ReturnedPurchaseDetails extends StatefulWidget {
  final String returnedPurchaseCode;

  const ReturnedPurchaseDetails({super.key, required this.returnedPurchaseCode});

  @override
  State<ReturnedPurchaseDetails> createState() => _ReturnedPurchaseDetailsState();
}

class _ReturnedPurchaseDetailsState extends State<ReturnedPurchaseDetails> {
  Status returnedPurchaseStatus = Status.loading;
  String error = '';
  ReturnedPurchaseModel? returnedPurchase;
  late ScrollController scrollController;

  @override
  void initState() {
    scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((s) => _getPurchase());
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ReturnedPurchasesProvider>(
      builder: (context, provider, child) {
        return Container(
          color: Tm.color(Tc.comCardBg),
          width: context.percentWidth * 60,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AlertDialogTitleBar(
                title: 'Return Purchase Details',
                bottomHeight: 0,
              ),
              if (returnedPurchaseStatus == Status.success && returnedPurchase != null)
                ReportsDetailsHeader(
                  children: _titlesTopDetails(returnedPurchase!),
                ),
              Expanded(
                child: PageListView(
                  /// Table Title
                  onSelectAllTap: (a) {},
                  isAllSelected: false,
                  titles: _titlesDetails(),

                  /// Scrollview
                  controller: scrollController,
                  status: returnedPurchaseStatus,
                  list: returnedPurchase?.items ?? [],
                  showCheckBox: false,
                  showMenuIcon: false,

                  /// List Tile
                  onMenuTap: (index, params) => {},
                  onSelectTap: (selected, index) => {},
                  tileSections: (index) => _tileSectionsDetails(returnedPurchase!.items[index]),

                  /// Error
                  listingError: error,
                  listingName: 'Employees',
                  onReloadTap: _getPurchase,
                ),
              ),
              if (returnedPurchaseStatus == Status.success && returnedPurchase != null)
                PageListTitle(
                  isAllSelected: false,
                  onSelectAllTap: (p0) {},
                  titles: _titlesHeaderDetails(returnedPurchase!.items),
                  properties: DataTableProperties(
                    color: Tm.color(Tc.iconContainerFillPurple),
                    style: Ts.rgRegular(color: Tm.color(Tc.txtH3)),
                    showDivider: true,
                  ),
                  logBalance: false,
                  showCheckBox: false,
                  showMenuIcon: false,
                  height: 60,
                ),
              AlertBottomButton(
                leftText: 'Close',
                showUpperPadding: false,
                showLeftButton: true,
                onLeftTap: () => AppNavigator.pop(),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _getPurchase() async {
    returnedPurchaseStatus = Status.loading;
    error = '';
    returnedPurchase = null;
    _refresh();

    final response = await ReturnedPurchasesService.getReturnedPurchase(purchaseCode: widget.returnedPurchaseCode);

    if (!response.responseType.success || response.data == null) {
      error = response.firstError();
      returnedPurchaseStatus = Status.error;
      _refresh();
      return;
    }

    returnedPurchase = response.data!;
    returnedPurchaseStatus = Status.success;
    _refresh();
  }

  void _refresh() => mounted ? setState(() {}) : null;
}

List<ReportsDetailsHeaderModel> _titlesTopDetails(ReturnedPurchaseModel returnedPurchases) => [
      ReportsDetailsHeaderModel(
        percentWidth: 24,
        child: Row(
          children: [
            ClipOval(
              child: CachedImage(
                url: returnedPurchases.photoUrl,
                height: 40,
                width: 40,
                errorWidget: SvgImage(Assets.icons.personCircle, height: 40, width: 40, color: Tm.color(Tc.txtH4)),
              ),
            ),
            const SizedBox(width: 12),
            Flexible(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    returnedPurchases.customerName.toPascalCase(),
                    style: (DataTableProperties.props).style ?? Ts.rgRegular(color: Tm.color(Tc.txtH3)),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  Text(
                    'Customer Name',
                    style: (DataTableProperties.props).style ?? Ts.mdRegular(color: Tm.color(Tc.tableConSubTxt)),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      ReportsDetailsHeaderModel(
        percentWidth: 24,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              returnedPurchases.returnId,
              style: Ts.rgRegular(color: Tm.color(Tc.tableConTxt)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              'Return ID',
              style: Ts.mdRegular(color: Tm.color(Tc.tableConSubTxt)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
      ReportsDetailsHeaderModel(
        percentWidth: 24,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              returnedPurchases.returnIds,
              style: Ts.rgRegular(color: Tm.color(Tc.tableConTxt)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              'Return ID',
              style: Ts.mdRegular(color: Tm.color(Tc.tableConSubTxt)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
      ReportsDetailsHeaderModel(
          percentWidth: 24,
          child: Container(
            height: 48,
            width: 198,
            alignment: Alignment.center,
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Tm.color(Tc.iconContainerFillBlu),
              borderRadius: const BorderRadius.all(Radius.circular(12)),
            ),
            child: Text(
              returnedPurchases.date,
              style: Ts.rgRegular(color: Tm.color(Tc.secDef)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          )
          // Column(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: [
          //     Text(
          //       returnedPurchases.date,
          //       style: Ts.rgRegular(color: Tm.color(Tc.tableConTxt)),
          //       maxLines: 1,
          //       overflow: TextOverflow.ellipsis,
          //     ),
          //     Text(
          //       'date',
          //       style: Ts.mdRegular(color: Tm.color(Tc.tableConSubTxt)),
          //       maxLines: 1,
          //       overflow: TextOverflow.ellipsis,
          //     ),
          //   ],
          // ),
          ),
    ];

List<DataTableItem> _titlesDetails() => [
      const DataTableItem(percentWidth: 14, label: 'HSN Code'),
      const DataTableItem(percentWidth: 22, label: 'Item Name'),
      const DataTableItem(percentWidth: 16, label: 'Return Reason'),
      const DataTableItem(percentWidth: 16, label: 'Qty'),
      const DataTableItem(percentWidth: 16, label: 'Tax'),
      const DataTableItem(percentWidth: 16, label: 'Total Price'),
    ];

List<DataTableItem> _tileSectionsDetails(ReturnedItem returnedPurchases) => [
      DataTableItem(percentWidth: 14, label: returnedPurchases.hsnCode),
      DataTableItem(percentWidth: 22, label: returnedPurchases.itemName),
      DataTableItem(percentWidth: 16, label: returnedPurchases.returnReason),
      DataTableItem(percentWidth: 16, label: returnedPurchases.qty.toString()),
      DataTableItem(percentWidth: 16, label: returnedPurchases.tax.text),
      DataTableItem(percentWidth: 16, label: StaticValues.currencySymbol(returnedPurchases.totalPrice.text)),
    ];

List<DataTableItem> _titlesHeaderDetails(List<ReturnedItem> purchaseList) {
  final totalAmount =
      purchaseList.fold<double>(0.0, (previousValue, element) => previousValue + int.parse(element.totalPrice.text));
  return [
    const DataTableItem(percentWidth: 13, label: 'Grand Total'),
    const DataTableItem(percentWidth: 72, child: Text('')),
    DataTableItem(percentWidth: 15, label: StaticValues.currencySymbol(totalAmount.toString())),
  ];
}
