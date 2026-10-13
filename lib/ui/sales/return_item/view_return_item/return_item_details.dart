part of '../return_item_screen.dart';

class ReturnItemDetails extends StatefulWidget {
  final String returnItemCode;

  const ReturnItemDetails({super.key, required this.returnItemCode});

  @override
  State<ReturnItemDetails> createState() => _ReturnItemDetailsState();
}

class _ReturnItemDetailsState extends State<ReturnItemDetails> {
  Status returnItemStatus = Status.loading;
  String error = '';
  ReturnItemModel? returnItem;
  late ScrollController scrollController;

  @override
  void initState() {
    scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((s) => _getReturnItem());
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ReturnItemProvider>(
      builder: (context, provider, child) {
        return Container(
          color: Tm.color(Tc.comCardBg),
          width: context.percentWidth * 60,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AlertDialogTitleBar(
                title: 'Return Item Details',
                bottomHeight: 0,
              ),
              if (returnItemStatus == Status.success && returnItem != null)
                ReportsDetailsHeader(
                  children: _titlesTopDetails(returnItem!),
                ),
              Expanded(
                child: PageListView(
                  /// Table Title
                  onSelectAllTap: (a) {},
                  isAllSelected: false,
                  titles: _titlesDetails(),

                  /// Scrollview
                  controller: scrollController,
                  status: returnItemStatus,
                  list: returnItem?.items ?? [],
                  showCheckBox: false,
                  showMenuIcon: false,

                  /// List Tile
                  onMenuTap: (index, params) => {},
                  onSelectTap: (selected, index) => {},
                  tileSections: (index) => _tileSectionsDetails(returnItem!.items[index]),

                  /// Error
                  listingError: error,
                  listingName: 'Employees',
                  onReloadTap: _getReturnItem,
                ),
              ),
              if (returnItemStatus == Status.success && returnItem != null)
                PageListTitle(
                  isAllSelected: false,
                  onSelectAllTap: (p0) {},
                  titles: _titlesHeaderDetails(returnItem!.items),
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
                  onLeftTap: () => AppNavigator.pop()),
            ],
          ),
        );
      },
    );
  }

  Future<void> _getReturnItem() async {
    returnItemStatus = Status.loading;
    error = '';
    returnItem = null;
    _refresh();

    final response = await ReturnItemService.getReturnItem(returnItemCode: widget.returnItemCode);

    if (!response.responseType.success || response.data == null) {
      error = response.firstError();
      returnItemStatus = Status.error;
      _refresh();
      return;
    }

    returnItem = response.data!;
    returnItemStatus = Status.success;
    _refresh();
  }

  void _refresh() => mounted ? setState(() {}) : null;
}

List<ReportsDetailsHeaderModel> _titlesTopDetails(ReturnItemModel returnItem) => [
      ReportsDetailsHeaderModel(
        percentWidth: 23,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              // StaticValues.commonDateMonthFormat.format(purchase.createdTime),
              returnItem.customerName,
              style: Ts.rgRegular(color: Tm.color(Tc.tableConTxt)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              'Customer Name',
              style: Ts.mdRegular(color: Tm.color(Tc.tableConSubTxt)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
      ReportsDetailsHeaderModel(
        percentWidth: 23,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              // StaticValues.commonDateMonthFormat.format(purchase.createdTime),
              returnItem.date,
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
        percentWidth: 23,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              // StaticValues.commonDateMonthFormat.format(purchase.createdTime),
              returnItem.time,
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
        percentWidth: 23,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              returnItem.billNumber,
              style: Ts.rgRegular(color: Tm.color(Tc.tableConTxt)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              'Bill Number',
              style: Ts.mdRegular(color: Tm.color(Tc.tableConSubTxt)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    ];

List<DataTableItem> _titlesDetails() => [
      const DataTableItem(percentWidth: 25, label: 'Item Name'),
      const DataTableItem(percentWidth: 25, label: 'Return Reason'),
      const DataTableItem(percentWidth: 15, label: 'Qty'),
      const DataTableItem(percentWidth: 10, label: 'Price'),
      const DataTableItem(percentWidth: 10, label: 'Tax'),
      const DataTableItem(percentWidth: 15, label: 'Total Price'),
    ];

List<DataTableItem> _tileSectionsDetails(ItemModel item) => [
      DataTableItem(percentWidth: 25, label: item.itemName),
      DataTableItem(percentWidth: 25, label: item.returnReason),
      DataTableItem(percentWidth: 15, label: item.qty.toString()),
      DataTableItem(percentWidth: 10, label: StaticValues.currencySymbol(item.price.toString())),
      DataTableItem(percentWidth: 10, label: item.tax.toString()),
      DataTableItem(percentWidth: 15, label: StaticValues.currencySymbol(item.totalPrice.toString())),
    ];

List<DataTableItem> _titlesHeaderDetails(List<ItemModel> item) {
  final totalAmount = item.fold<double>(0.0, (previousValue, element) => previousValue + element.totalPrice);
  return [
    const DataTableItem(percentWidth: 13, label: 'Grand Total'),
    const DataTableItem(percentWidth: 72, child: Text('')),
    DataTableItem(percentWidth: 15, label: StaticValues.currencySymbol(totalAmount.toString())),
  ];
}
