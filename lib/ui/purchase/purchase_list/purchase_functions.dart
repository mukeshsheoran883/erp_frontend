part of 'purchase_screen.dart';

Future<void> _viewCustomerDetails(String purchaseCode) async {
  await showPopup(child: PurchaseDetails(purchaseCode: purchaseCode), canClose: true);
}

Future<void> _onMenuTap(PurchaseModel purchase, AppMenuParams params) async {
  await showAppMenu(
    params: params,
    childrenBuilder: (closeFunction) {
      return [
        AppMenuButtons.viewButton(() => {closeFunction(), _viewCustomerDetails(purchase.purchaseCode)}),
        AppMenuButtons.editButton(
          () => {
            closeFunction(),
            AppNavigator.navigate(
              AppRoutes.purchaseEdit(data: AddEditPurchaseScreen(purchaseCode: purchase.purchaseCode)),
            ),
          },
        ),
        AppMenuButtons.textButton(text: 'Print'),
        AppMenuButtons.textButton(text: 'Download'),
        AppMenuButtons.textButton(text: 'Convert To Stock'),
        AppMenuButtons.divider(),
        AppMenuButtons.deleteButton(
          () => {
            closeFunction(),
            _deletePurchase([purchase]),
          },
        ),
      ];
    },
  );
}

Future<bool> _deletePurchase(List<PurchaseModel> purchase) async {
  bool confirmed = await showMultiDeletePopup(
    model: MultiSelectModel(
      items: purchase.map((e) => e.purchaseBillNumber.toPascalCase()).toList(),
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
      final response = await BranchService.multiDeleteBranch(deleteList: purchase.map((e) => e.purchaseCode).toList());

      if (!response.responseType.success) {
        error = response.firstError();
        return Status.error;
      }

      return Status.success;
    },
    onSuccess: () {
      final context = Globals.context();
      AppSnackBar.showSnackBarWithText(text: '${purchase.length > 1 ? 'Purchases' : 'Purchase'} deleted');
      context.read<PurchaseProvider>().getPurchaseList();
    },
  );

  if (s == Status.success) return true;
  return false;
}

Future<SearchResponseModel> _search(String a) async {
  final response = await PurchaseService.getPurchaseList(pageNumber: 1, searchKey: a, filter: null);
  return SearchResponseModel(
    status: (response.responseType.success && response.data != null) ? Status.success : Status.error,
    error: response.firstError(),
    items:
        (response.data ?? []).map((e) => CommonKeyValueModel(id: e.purchaseCode, value: e.purchaseBillNumber)).toList(),
    searchResultsFor: a,
  );
}

Future<void> _showFilter() async {
  await showRightMenu(const PurchaseFilterSection());
}
