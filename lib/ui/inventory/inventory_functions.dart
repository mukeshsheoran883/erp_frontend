part of 'inventory_screen.dart';

Future<void> _onMenuTap(InventoryModel inventory, AppMenuParams params) async {
  await showAppMenu(
    params: params,
    childrenBuilder: (closeFunction) {
      return [
        AppMenuButtons.viewButton(
          () => {
            closeFunction(), _viewInventoryDetails(inventory.inventoryCode,inventory.inventoryId.toString())
          },
        ),
        AppMenuButtons.editButton(
          () => {
            closeFunction(),
            AppNavigator.navigate(AppRoutes.inventoryEdit(data: AddEditInventoryScreen(inventoryName: inventory.itemName, inventoryCode: inventory.inventoryCode,))),
          },
        ),
        AppMenuButtons.textButton(text: 'Print'),
        AppMenuButtons.textButton(text: 'Download'),
        AppMenuButtons.textButton(text: 'Convert To Stock'),
        AppMenuButtons.deleteButton(
          () => {
            closeFunction(),
            _deletePurchase([inventory]),
          },
        ),
      ];
    },
  );
}

Future<void> _viewInventoryDetails(String inventoryCode,String inventoryName) async {
  await showRightMenu(InventoryDetails(inventoryCode: inventoryCode, inventoryName: inventoryName,));
}

Future<bool> _deletePurchase(List<InventoryModel> user) async {
  bool confirmed = await showMultiDeletePopup(
    model: MultiSelectModel(
      items: user.map((e) => e.itemName.toPascalCase()).toList(),
      singleString: 'Inventory',
      pluralString: 'Inventories',
    ),
  );

  if (!confirmed) return false;

  String error = '';
  Status s = await handleFutureWithAlert(
    errorMessage: () => error,
    progressbarWaitDuration: Duration.zero,
    function: () async {
      final response = await InventoryService.multiDeleteInventory(deleteList: user.map((e) => e.inventoryCode).toList());

      if (!response.responseType.success) {
        error = response.firstError();
        return Status.error;
      }

      return Status.success;
    },
    onSuccess: () {
      final context = Globals.context();
      AppSnackBar.showSnackBarWithText(text: '${user.length > 1 ? 'Inventory' : 'Inventories'} deleted');
      context.read<EmployeeProvider>().getEmployeeList();
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
