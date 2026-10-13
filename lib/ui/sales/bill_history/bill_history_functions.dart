part of 'bill_history_screen.dart';

Future<void> _viewInvoiceDetails(
    String invoiceCode,
    ) async {
  await showRightMenu(InvoiceDetails(invoiceCode: invoiceCode));
}

Future<void> _onMenuTap(BillHistoryModel billHistory, AppMenuParams params) async {
  await showAppMenu(
    params: params,
    childrenBuilder: (closeFunction) {
      return [
        AppMenuButtons.viewButton(() => {closeFunction(), _viewInvoiceDetails(billHistory.billNumber)}),

        AppMenuButtons.textButton(text: 'Print'),
        AppMenuButtons.textButton(text: 'Download'),
        AppMenuButtons.divider(),
        AppMenuButtons.deleteButton(
          () => {
            closeFunction(),
            _deletePurchase([billHistory]),
          },
        ),
      ];
    },
  );
}

Future<bool> _deletePurchase(List<BillHistoryModel> billHistory) async {
  bool confirmed = await showMultiDeletePopup(
    model: MultiSelectModel(
      items: billHistory.map((e) => e.billNumber.toPascalCase()).toList(),
      singleString: 'billHistory',
      pluralString: 'billHistory',
    ),
  );

  if (!confirmed) return false;

  String error = '';
  Status s = await handleFutureWithAlert(
    errorMessage: () => error,
    progressbarWaitDuration: Duration.zero,
    function: () async {
      final response =
          await BranchService.multiDeleteBranch(deleteList: billHistory.map((e) => e.billNumber).toList());

      if (!response.responseType.success) {
        error = response.firstError();
        return Status.error;
      }

      return Status.success;
    },
    onSuccess: () {
      final context = Globals.context();
      AppSnackBar.showSnackBarWithText(text: '${billHistory.length > 1 ? 'Invoice' : 'Invoice'} deleted');
      context.read<BillHistoryProvider>().getBillHistoryList();
    },
  );

  if (s == Status.success) return true;
  return false;
}

Future<SearchResponseModel> _search(String a) async {
  final response = await BillHistoryService.getBillHistoryList(pageNumber: 1, searchKey: a, filter: null);
  return SearchResponseModel(
    status: (response.responseType.success && response.data != null) ? Status.success : Status.error,
    error: response.firstError(),
    items: (response.data ?? []).map((e) => CommonKeyValueModel(id: e.billNumber, value: e.billNumber)).toList(),
    searchResultsFor: a,
  );
}

Future<void> _showFilter() async {
  await showRightMenu(const PurchaseFilterSection());
}
