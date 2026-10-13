part of '../add_stock_available_screen.dart';

Future<void> _getStockAvailable(_AddEditStockAvailableScreenState state) async {
  await _setInitialValues(state, null, null);
  state._refresh();
  final response = await Future.wait(
    [
      if (state.widget.stockAvailableCode != null)
        StockAvailableService.getStockAvailable(stockAvailableCode: state.widget.stockAvailableCode!)
    ],
  );

  StockAvailableModel? editStockAvailable;
  List<StockAvailableItemModel>? editStockAvailableItem;

  if (state.widget.stockAvailableCode != null) {
    ApiResponseModel<StockAvailableModel> stockAvailableResponse = response[0];
    if (!stockAvailableResponse.responseType.success || stockAvailableResponse.data == null) {
      state.params.stockAvailable.setError(stockAvailableResponse.firstError());
      state.params.stockAvailable.setStatus(Status.error);
      state._refresh();
      return;
    }

    editStockAvailable = stockAvailableResponse.data!;
    editStockAvailableItem = stockAvailableResponse.data!.items;
  }
  await _setInitialValues(state, editStockAvailable, editStockAvailableItem);
  state.params.stockAvailable.resetError();
  state.params.stockAvailable.setStatus(Status.success);
  state._refresh();
}

Future<void> _setInitialValues(
  _AddEditStockAvailableScreenState state,
  StockAvailableModel? stockAvailable,
  List<StockAvailableItemModel>? editItem,
) async {
  state.params.stockAvailable.reset(stockAvailable);
  state.params.stockAvailableList.reset(null);
  state.params.stockAvailableList.options = editItem ?? [StockAvailableItemModel.empty()];
  state.params.items.options = [];
  state.params.items.reset(
    stockAvailable == null ? null : CommonKeyValueModel(id: stockAvailable.itemCode, value: stockAvailable.itemName),
  );
  state.params.purchaseId.controller.text = stockAvailable?.purchaseId ?? '';
  state.params.unit.selected = CommonKeyValueModel(id: stockAvailable?.unit ?? '', value: stockAvailable?.unit ?? '');
  state.params.quantity.controller.text = stockAvailable?.quantity ?? '';
  state.params.expiryDate.reset(stockAvailable?.expiryDate);
  state.params.createdON.reset(stockAvailable?.createdOn);
  state.params.vendorCost.controller.text = stockAvailable?.vendorCost ?? '';
  state.params.sellingPrice.controller.text = stockAvailable?.sellingPrice ?? '';
}

void _resetErrors(_AddEditStockAvailableScreenState state) => state.params.allParams().forEach((d) => d.resetError());

void _dispose(_AddEditStockAvailableScreenState state) => state.params.allParams().forEach((d) => d.dispose());

Future<void> _onSaveTap(_AddEditStockAvailableScreenState state) async {
  String errorMessage = '';

  StockAvailableModel? stockAvailableModel = _validate(state);
  state._refresh();
  if (StockAvailableModel == null) return;

  bool confirmed = await _askConfirmationToAddOrEdit(state);
  if (!confirmed) return;

  await handleFutureWithAlert(
    errorMessage: () => errorMessage,
    progressbarWaitDuration: Duration.zero,
    function: () async {
      final createBranchResponse = state.widget.stockAvailableCode == null
          ? await StockAvailableService.createStockAvailable(stockAvailableModel!)
          : await StockAvailableService.updateStockAvailable(stockAvailableModel!);

      if (!createBranchResponse.responseType.success || createBranchResponse.data == null) {
        errorMessage = createBranchResponse.firstError();
        return Status.error;
      }
      return Status.success;
    },
    onSuccess: () {
      AppSnackBar.showSnackBarWithText(
        text: state.widget.stockAvailableCode == null
            ? 'Stock Available created successfully'
            : 'Stock Available updated successfully',
        duration: state.widget.stockAvailableCode == null ? const Duration(seconds: 6) : null,
      );
      AppNavigator.navigate(AppRoutes.stockAvailableList);
    },
  );
}

StockAvailableModel? _validate(_AddEditStockAvailableScreenState state) {
  _resetErrors(state);
  AddStockAvailableVariables param = state.params;
  CommonKeyValueModel? item = param.items.selected;
  String? purchaseId = param.purchaseId.text;
  CommonKeyValueModel? unit = param.unit.selected;
  String? quantity = param.quantity.text;
  DateTime? expiryDate = param.expiryDate.dateTime?.convertToDateAlone();
  DateTime? createdON = param.createdON.dateTime?.convertToDateAlone();
  String? vendorCost = param.vendorCost.text;
  String? sellingPrice = param.sellingPrice.text;
  final itemList = param.stockAvailableList;

  bool isPersonalDetailsValid = Validator.validate(
    [
      CustomValidators.typeValidator(field: 'Item', data: item, error: param.items.error, types: [CommonKeyValueModel]),
      CustomValidators.nameValidator(field: 'Purchase Id', data: purchaseId, error: param.purchaseId.error),
      CustomValidators.typeValidator(field: 'Unit', data: unit, types: [UnitModel], error: param.unit.error),
      CustomValidators.nameValidator(field: 'Vendor Cost', data: vendorCost, error: param.vendorCost.error),
      CustomValidators.moneyValidator(field: 'Selling Price', error: param.sellingPrice.error, amount: sellingPrice),
      CustomValidators.nameValidator(field: 'Quantity', data: quantity, error: param.quantity.error),
      CustomValidators.dateValidator(
        field: 'Expiry Date',
        date: expiryDate,
        maxDate: DateTime.now(),
        error: param.expiryDate.error,
        required: false,
      ),
      CustomValidators.dateValidator(
        field: 'Created On',
        date: createdON,
        maxDate: DateTime.now(),
        error: param.createdON.error,
        required: false,
      ),
      for (final i in itemList.options) ...[
        CustomValidators.typeValidator(
          field: 'Item',
          data: i.branch.value,
          types: [CommonKeyValueModel],
          error: i.branch.error,
        ),
        CustomValidators.nameValidator(field: 'Label', error: i.qty.error, data: i.qty.text),
        CustomValidators.minMaxValidator(
          field: '',
          value: double.tryParse(i.qty.text) ?? 0,
          error: i.qty.error,
          min: 0,
        ),
      ],
    ],
  );

  if (!isPersonalDetailsValid) return null;

  StockAvailableModel stockAvailableModel = StockAvailableModel(
    supplierName: '',
    itemCode: '',
    disabled: false,
    selected: false,
    itemName: '',
    quantity: '',
    sellingPrice: '',
    items: [],
    returnId: '',
    purchaseId: '',
    date: '',
    amount: '',
    unit: '',
    createdOn: DateTime.now(),
    expiryDate: DateTime.now(),
    vendorCost: '',
    time: '',
  );
  return stockAvailableModel;
}

Future<void> _onCloseTap(_AddEditStockAvailableScreenState state) async {
  bool confirmed = false;

  await showDoubleButtonAlert(
    DoubleButtonAlertModel(
      onRightTap: () => {confirmed = true, AppNavigator.pop()},
      content:
          'Are you sure you want to cancel ${state.widget.stockAvailableCode == null ? 'adding' : 'editing'} this Stock Available?',
    ),
    canClose: true,
  );

  if (!confirmed) return;

  AppNavigator.navigate(AppRoutes.stockAvailableList);
}

Future<bool> _askConfirmationToAddOrEdit(_AddEditStockAvailableScreenState state) async {
  bool confirmed = false;

  await showDoubleButtonAlert(
    DoubleButtonAlertModel(
      onRightTap: () => {confirmed = true, AppNavigator.pop()},
      content:
          'Are you sure you want to ${state.widget.stockAvailableCode == null ? 'create' : 'update'} this Stock AvailableModel?',
    ),
    canClose: true,
  );

  return confirmed;
}
