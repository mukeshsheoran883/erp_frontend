part of 'stock_pending_transfer_screen.dart';

Future<void> _viewCustomerDetails(String purchaseCode) async {
  // await showPopup(child: PurchaseDetails(purchaseCode: purchaseCode), canClose: true);
}

Future<void> _onMenuTap(StockPendingTransferModel stockPendingTransfer, AppMenuParams params) async {
  await showAppMenu(
    params: params,
    childrenBuilder: (closeFunction) {
      return [
        AppMenuButtons.viewButton(() => {closeFunction(), _viewCustomerDetails(stockPendingTransfer.slNo)}),
        AppMenuButtons.editButton(
          () => {
            closeFunction(),
            AppNavigator.navigate(
              AppRoutes.stockTransferEdit(
                data: AddEditStockPendingTransferScreen(stockPendingTransferCode: stockPendingTransfer.slNo),
              ),
            ),
          },
        ),
        AppMenuButtons.textButton(text: 'Accept'),
        AppMenuButtons.textButton(text: 'Reject'),
        AppMenuButtons.divider(),
        AppMenuButtons.deleteButton(
          () => {
            closeFunction(),
            _deletePurchase([stockPendingTransfer]),
          },
        ),
      ];
    },
  );
}

Future<bool> _deletePurchase(List<StockPendingTransferModel> stockPendingTransfer) async {
  bool confirmed = await showMultiDeletePopup(
    model: MultiSelectModel(
      items: stockPendingTransfer.map((e) => e.slNo.toPascalCase()).toList(),
      singleString: 'purchase',
      pluralString: 'purchases',
    ),
  );

  if (!confirmed) return false;

  String error = '';
  Status s = await handleFutureWithAlert(
    errorMessage: () => error,
    progressbarWaitDuration: Duration.zero,
    function: () async {
      // final response = await BranchService.multiDeleteBranch(deleteList: purchase.map((e) => e.purchaseCode).toList());

      // if (!response.responseType.success) {
      //   error = response.firstError();
      //   return Status.error;
      // }

      return Status.success;
    },
    // onSuccess: () {
    //   final context = Globals.context();
    //   AppSnackBar.showSnackBarWithText(text: '${purchase.length > 1 ? 'Purchases' : 'Purchase'} deleted');
    //   context.read<PurchaseProvider>().getPurchaseList();
    // },
  );

  if (s == Status.success) return true;
  return false;
}

Future<SearchResponseModel> _search(String a) async {
  final response = await StockPendingTransferService.getStockPendingTransferList(
    pageNumber: 1,
    searchKey: a,
  );
  return SearchResponseModel(
    status: (response.responseType.success && response.data != null) ? Status.success : Status.error,
    error: response.firstError(),
    items: (response.data ?? []).map((e) => CommonKeyValueModel(id: e.slNo, value: e.slNo)).toList(),
    searchResultsFor: a,
  );
}

// Future<void> _showFilter() async {
//   await showRightMenu(const PurchaseFilterSection());
// }
