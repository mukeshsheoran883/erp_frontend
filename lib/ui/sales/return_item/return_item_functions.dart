part of 'return_item_screen.dart';

Future<void> _viewCustomerDetails(String returnItemCode) async {
  await showPopup(child: ReturnItemDetails(returnItemCode: returnItemCode), canClose: true);
}

Future<void> _onMenuTap(ReturnItemModel returnItem, AppMenuParams params) async {
  await showAppMenu(
    params: params,
    childrenBuilder: (closeFunction) {
      return [
        AppMenuButtons.viewButton(() => {closeFunction(), _viewCustomerDetails(returnItem.customerName)}),
        AppMenuButtons.editButton(
          () => {
            closeFunction(),
            AppNavigator.navigate(
              AppRoutes.purchaseEdit(data: AddEditPurchaseScreen(purchaseCode: returnItem.customerName)),
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
            _deletePurchase([returnItem]),
          },
        ),
      ];
    },
  );
}

Future<bool> _deletePurchase(List<ReturnItemModel> returnItem) async {
  bool confirmed = await showMultiDeletePopup(
    model: MultiSelectModel(
      items: returnItem.map((e) => e.customerName.toPascalCase()).toList(),
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
          await BranchService.multiDeleteBranch(deleteList: returnItem.map((e) => e.customerName).toList());

      if (!response.responseType.success) {
        error = response.firstError();
        return Status.error;
      }

      return Status.success;
    },
    onSuccess: () {
      final context = Globals.context();
      AppSnackBar.showSnackBarWithText(text: '${returnItem.length > 1 ? 'Return Item' : 'Return Item'} deleted');
      context.read<ReturnItemProvider>().getReturnItemList();
    },
  );

  if (s == Status.success) return true;
  return false;
}

Future<SearchResponseModel> _search(String a) async {
  final response = await ReturnItemService.getReturnItemList(pageNumber: 1, searchKey: a, filter: null);
  return SearchResponseModel(
    status: (response.responseType.success && response.data != null) ? Status.success : Status.error,
    error: response.firstError(),
    items: (response.data ?? []).map((e) => CommonKeyValueModel(id: e.customerName, value: e.customerName)).toList(),
    searchResultsFor: a,
  );
}

Future<void> _showFilter() async {
  await showRightMenu(const PurchaseFilterSection());
}
