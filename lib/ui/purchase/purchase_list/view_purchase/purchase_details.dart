part of '../purchase_screen.dart';

class PurchaseDetails extends StatefulWidget {
  final String purchaseCode;

  const PurchaseDetails({super.key, required this.purchaseCode});

  @override
  State<PurchaseDetails> createState() => _PurchaseDetailsState();
}

class _PurchaseDetailsState extends State<PurchaseDetails> {
  Status purchaseStatus = Status.loading;
  String error = '';
  PurchaseDetailModel? purchase;
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
    return Consumer<PurchaseProvider>(
        builder: (context, provider, child) {
          return Container(
      color: Tm.color(Tc.comCardBg),
      width: context.percentWidth * 60,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AlertDialogTitleBar(title: 'Purchase Details',bottomHeight: 0,),
          if(purchaseStatus == Status.success && purchase != null)
            ReportsDetailsHeader(children: _titlesTopDetails(purchase!),),
          Expanded(
            child: PageListView(
              /// Table Title
              onSelectAllTap: (a) {},
              isAllSelected: false,
              titles: _titlesDetails(),

              /// Scrollview
              controller: scrollController,
              status: purchaseStatus,
              list: purchase?.items ?? [],
              showCheckBox: false,
              showMenuIcon: false,


              /// List Tile
              onMenuTap: (index, params) => {},
              onSelectTap: (selected, index) => {},
              tileSections: (index) => _tileSectionsDetails(purchase!.items[index]),

              /// Error
              listingError: error,
              listingName: 'Employees',
              onReloadTap: _getPurchase,
            ),
          ),
          if(purchaseStatus == Status.success && purchase != null)
            PageListTitle(
              isAllSelected: false,
              onSelectAllTap: (p0) {},
              titles: _titlesHeaderDetails(purchase!.items),
              properties: DataTableProperties(
                color: Tm.color(Tc.iconContainerFillPurple),
                style: Ts.rgRegular(color: Tm.color(Tc.txtH3)),
                showDivider: true,
              ),
              logBalance: false,
              showCheckBox: false,
              showMenuIcon: false,height: 60,
            ) ,
          AlertBottomButton(leftText: 'Close',showUpperPadding: false, showLeftButton: true, onLeftTap: () => AppNavigator.pop()),
        ],
      ),
    );},);
  }

  Future<void> _getPurchase() async {
    purchaseStatus = Status.loading;
    error = '';
    purchase = null;
    _refresh();

    final response = await PurchaseService.getPurchases(purchaseCode: widget.purchaseCode);

    if (!response.responseType.success || response.data == null) {
      error = response.firstError();
      purchaseStatus = Status.error;
      _refresh();
      return;
    }

    purchase = response.data!;
    purchaseStatus = Status.success;
    _refresh();
  }

  void _refresh() => mounted ? setState(() {}) : null;
}

List<ReportsDetailsHeaderModel> _titlesTopDetails(PurchaseDetailModel purchase) => [
  ReportsDetailsHeaderModel(
    percentWidth: 13,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          // StaticValues.commonDateMonthFormat.format(purchase.createdTime),
          purchase.date,
          style: Ts.rgRegular(color: Tm.color(Tc.tableConTxt)),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          'Date',
          style: Ts.mdRegular(color: Tm.color(Tc.tableConSubTxt)),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    ),
  ),
  ReportsDetailsHeaderModel(
    percentWidth: 13,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          // StaticValues.commonDateMonthFormat.format(purchase.createdTime),
          purchase.time,
          style: Ts.rgRegular(color: Tm.color(Tc.tableConTxt)),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          'Time',
          style: Ts.mdRegular(color: Tm.color(Tc.tableConSubTxt)),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    ),
  ),
  ReportsDetailsHeaderModel(
    percentWidth: 25,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          purchase.purchaseNumber,
          style: Ts.rgRegular(color: Tm.color(Tc.tableConTxt)),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          'Purchase Number',
          style: Ts.mdRegular(color: Tm.color(Tc.tableConSubTxt)),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    ),
  ),
  ReportsDetailsHeaderModel(
    percentWidth: 25,
    child: Row(
      children: [
        ClipOval(
          child: CachedImage(
            url: purchase.photoUrl,
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
                purchase.supplier.toPascalCase(),
                style: (DataTableProperties.props).style ?? Ts.rgRegular(color: Tm.color(Tc.txtH3)),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              Text(
                'Supplier',
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
];


List<DataTableItem> _titlesDetails() => [
  const DataTableItem(percentWidth: 20, label: 'Item Name'),
  const DataTableItem(percentWidth: 10, label: 'Qty'),
  const DataTableItem(percentWidth: 15, label: 'Buying Price'),
  const DataTableItem(percentWidth: 15, label: 'Landing Cost'),
  const DataTableItem(percentWidth: 15, label: 'Selling Price'),
  const DataTableItem(percentWidth: 10, label: 'Tax'),
  const DataTableItem(percentWidth: 15, label: 'Total'),
];

List<DataTableItem> _tileSectionsDetails(PurchaseItemModel purchase) => [
  DataTableItem(
    percentWidth: 20,
    child: Text(
      purchase.itemName,
      style: Ts.rgRegular(color: Tm.color(Tc.tableConTxt)),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    ),
  ),
  DataTableItem(percentWidth: 10, label: purchase.qty.toString()),
  DataTableItem(percentWidth: 15, label: StaticValues.currencySymbol(purchase.buyingPrice.toString())),
  DataTableItem(percentWidth: 15, label: StaticValues.currencySymbol(purchase.landingCost.toString())),
  DataTableItem(percentWidth: 15, label: StaticValues.currencySymbol(purchase.sellingPrice.toString())),
  DataTableItem(percentWidth: 10, label: '${purchase.tax.toStringAsFixed(0)}%'),
  DataTableItem(percentWidth: 15, label: StaticValues.currencySymbol(purchase.totalPrice.toString())),
];

List<DataTableItem> _titlesHeaderDetails(List<PurchaseItemModel> purchaseList) {
  final totalAmount =
  purchaseList.fold<double>(0.0, (previousValue, element) => previousValue + element.totalPrice);
  return [
    const DataTableItem(percentWidth: 13, label: 'Grand Total'),
    const DataTableItem(percentWidth: 72, child: Text('')),
    DataTableItem(percentWidth: 15, label: StaticValues.currencySymbol(totalAmount.toString())),
  ];
}