part of 'returned_purchase_screen.dart';

Future<void> _viewCustomerDetails(String returnedPurchaseCode) async {
  await showPopup(child: ReturnedPurchaseDetails(returnedPurchaseCode: returnedPurchaseCode), canClose: true);
}

Future<void> _onMenuTap(ReturnedPurchaseModel returnedPurchase, AppMenuParams params) async {
  await showAppMenu(
    params: params,
    childrenBuilder: (closeFunction) {
      return [
        AppMenuButtons.viewButton(() => {closeFunction(), _viewCustomerDetails(returnedPurchase.returnCode)}),
        AppMenuButtons.editButton(
          () => {
            closeFunction(),
            AppNavigator.navigate(
              AppRoutes.returnedPurchaseEdit(
                  data: AddEditReturnedPurchaseScreen(returnedPurchaseCode: returnedPurchase.returnCode)),
            ),
          },
        ),
        AppMenuButtons.textButton(text: 'Print'),
        AppMenuButtons.textButton(text: 'Download'),
        AppMenuButtons.deleteButton(
          () => {
            closeFunction(),
            _deletePurchase([returnedPurchase]),
          },
        ),
      ];
    },
  );
}

Future<bool> _deletePurchase(List<ReturnedPurchaseModel> purchase) async {
  bool confirmed = await showMultiDeletePopup(
    model: MultiSelectModel(
      items: purchase.map((e) => e.purchaseId.toPascalCase()).toList(),
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
      final response =
          await ReturnedPurchasesService.multiDeletePurchase(deleteList: purchase.map((e) => e.purchaseId).toList());

      if (!response.responseType.success) {
        error = response.firstError();
        return Status.error;
      }

      return Status.success;
    },
    onSuccess: () {
      final context = Globals.context();
      AppSnackBar.showSnackBarWithText(text: '${purchase.length > 1 ? 'Purchases' : 'Purchase'} deleted');
      context.read<ReturnedPurchasesProvider>().getReturnedPurchaseList();
    },
  );

  if (s == Status.success) return true;
  return false;
}

Future<SearchResponseModel> _search(String a) async {
  final response = await ReturnedPurchasesService.getReturnedPurchaseList(pageNumber: 1, searchKey: a, filter: null);
  return SearchResponseModel(
    status: (response.responseType.success && response.data != null) ? Status.success : Status.error,
    error: response.firstError(),
    items: (response.data ?? []).map((e) => CommonKeyValueModel(id: e.purchaseId, value: e.purchaseId)).toList(),
    searchResultsFor: a,
  );
}

Future<void> _showFilter() async {
  await showRightMenu(const PurchaseFilterSection());
}
