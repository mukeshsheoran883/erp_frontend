part of '../add_inventory_screen.dart';

Future<void> _getInventory(_AddEditInventoryScreenState state) async {
  _setInitialValues(state, [], [], null);
  state._refresh();

  final response = await Future.wait([
    ItemService.getItemsList(pageNumber: 1, searchKey: '', filter: null),
    BranchService.getBranchList(pageNumber: 1, searchKey: '', filter: null),
    if (state.widget.inventoryCode != null)
      InventoryService.getInventory(inventoryName: state.widget.inventoryCode!, inventoryCode: state.widget.inventoryName!),
  ]);

  ApiResponseModel<List<ItemModel>> itemResponse = response[0] as ApiResponseModel<List<ItemModel>>;
  ApiResponseModel<List<BranchModel>> branchResponse = response[1] as ApiResponseModel<List<BranchModel>>;

  InventoryModel? editInventory;
  if (state.widget.inventoryCode != null) {
    ApiResponseModel<InventoryModel> inventoryResponse = response[2] as ApiResponseModel<InventoryModel>;
    if (!inventoryResponse.responseType.success || inventoryResponse.data == null) {
      state.params.inventory.setError(inventoryResponse.firstError());
      state.params.inventory.setStatus(Status.error);
      state._refresh();
      return;
    }
    editInventory = inventoryResponse.data!;
  }

  if (!itemResponse.responseType.success || itemResponse.data == null) {
    state.params.inventory.setError(itemResponse.firstError());
    state.params.inventory.setStatus(Status.error);
    state._refresh();
    return;
  }

  if (!branchResponse.responseType.success || branchResponse.data == null) {
    state.params.inventory.setError(branchResponse.firstError());
    state.params.inventory.setStatus(Status.error);
    state._refresh();
    return;
  }

  await _setInitialValues(state, itemResponse.data!, branchResponse.data!, editInventory);
  state.params.inventory.resetError();
  state.params.inventory.setStatus(Status.success);
  state._refresh();
}

Future<void> _setInitialValues(
    _AddEditInventoryScreenState state,
    List<ItemModel> items,
    List<BranchModel> branches,
    InventoryModel? inventory,
    ) async {
  state.params.inventory.reset(inventory);

  state.params.item.reset(
    inventory == null ? null : CommonKeyValueModel(id: inventory.itemCode, value: inventory.itemName),
  );
  state.params.item.options = ValueNotifier(
    items.map((i) => CommonKeyValueModel(id: i.itemCode, value: i.name)).toList(),
  );

  state.params.shop.reset(
    inventory == null ? null : CommonKeyValueModel(id: inventory.shopCode, value: inventory.shopName),
  );
  state.params.shop.options = ValueNotifier(
    branches.map((b) => CommonKeyValueModel(id: b.shopCode, value: b.name)).toList(),
  );

  state.params.expiryDate.reset(inventory?.expiryDate);
  state.params.price.controller.text = inventory?.price.toString() ?? '';
  state.params.balanceQty.controller.text = inventory?.balanceQty.toString() ?? '0';

  _resetErrors(state);
}

void _resetErrors(_AddEditInventoryScreenState state) => state.params.allParams().forEach((d) => d.resetError());

void _dispose(_AddEditInventoryScreenState state) => state.params.allParams().forEach((d) => d.dispose());

Future<void> _onSaveTap(_AddEditInventoryScreenState state) async {
  String errorMessage = '';

  InventoryModel? inventoryModel = _validate(state);
  state._refresh();
  if (inventoryModel == null) return;

  bool confirmed = await _askConfirmationToAddOrEdit(state);
  if (!confirmed) return;

  await handleFutureWithAlert(
    errorMessage: () => errorMessage,
    progressbarWaitDuration: Duration.zero,
    function: () async {
      final response = state.widget.inventoryCode == null
          ? await InventoryService.createInventory(inventoryModel)
          : await InventoryService.updateInventory(inventoryModel);

      if (!response.responseType.success || response.data == null) {
        errorMessage = response.firstError();
        return Status.error;
      }
      return Status.success;
    },
    onSuccess: () {
      AppSnackBar.showSnackBarWithText(
        text: state.widget.inventoryCode == null ? 'Inventory created successfully' : 'Inventory updated successfully',
        duration: state.widget.inventoryCode == null ? const Duration(seconds: 6) : null,
      );
      AppNavigator.navigate(AppRoutes.inventoryList);
    },
  );
}

InventoryModel? _validate(_AddEditInventoryScreenState state) {
  _resetErrors(state);
  AddInventoryParams param = state.params;

  DateTime? expiry = param.expiryDate.dateTime?.convertToDateAlone();

  bool isValid = Validator.validate([
    CustomValidators.typeValidator(
      field: 'Item',
      data: param.item.selected,
      error: param.item.error,
      types: [CommonKeyValueModel],
    ),
    CustomValidators.typeValidator(
      field: 'Shop',
      data: param.shop.selected,
      error: param.shop.error,
      types: [CommonKeyValueModel],
    ),
    CustomValidators.dateValidator(
      field: 'Expiry date',
      date: expiry,
      maxDate: DateTime.now().add(const Duration(days: 3650)),
      error: param.expiryDate.error,
    ),
    CustomValidators.moneyValidator(field: 'Price', amount: param.price.text, error: param.price.error),
    CustomValidators.moneyValidator(field: 'Balance Quantity', amount: param.balanceQty.text, error: param.balanceQty.error),

  ]);

  if (!isValid) return null;

  return InventoryModel(
    inventoryId: state.params.inventory.value?.inventoryId ?? '',
    inventoryCode: state.widget.inventoryCode ?? '',
    itemCode: param.item.selected!.id,
    itemName: param.item.selected!.value,
    description: state.params.inventory.value?.description ?? '',
    shopCode: param.shop.selected!.id,
    shopName: param.shop.selected!.value,
    expiryDate: expiry ?? DateTime.now(),
    price: double.tryParse(param.price.text) ?? 0,
    balanceQty: (double.tryParse(param.balanceQty.text) ?? 0).toInt(),
    createdTime: state.params.inventory.value?.createdTime ?? DateTime.now(),
    storeMapping: state.params.inventory.value?.storeMapping ?? '',
    disabled: false,
    selected: false,
  );
}

Future<void> _onCloseTap(_AddEditInventoryScreenState state) async {
  bool confirmed = false;

  await showDoubleButtonAlert(
    DoubleButtonAlertModel(
      onRightTap: () => {confirmed = true, AppNavigator.pop()},
      content:
      'Are you sure you want to cancel ${state.widget.inventoryCode == null ? 'adding' : 'editing'} this inventory?',
    ),
    canClose: true,
  );

  if (!confirmed) return;

  AppNavigator.navigate(AppRoutes.stockAvailableList);
}

Future<bool> _askConfirmationToAddOrEdit(_AddEditInventoryScreenState state) async {
  bool confirmed = false;

  await showDoubleButtonAlert(
    DoubleButtonAlertModel(
      onRightTap: () => {confirmed = true, AppNavigator.pop()},
      content: 'Are you sure you want to ${state.widget.inventoryCode == null ? 'create' : 'update'} this inventory?',
    ),
    canClose: true,
  );

  return confirmed;
}