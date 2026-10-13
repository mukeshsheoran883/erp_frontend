part of '../add_stock_pending_transfer_screen.dart';

Future<void> _getPurchase(_AddEditStockPendingTransferScreenState state) async {
  await _setInitialValues(state, null);
  state._refresh();
  final response = await Future.wait(
    [
      if (state.widget.stockPendingTransferCode != null)
        StockPendingTransferService.getStockPendingTransfer(
            stockPendingTransferCode: state.widget.stockPendingTransferCode!),
    ],
  );

  StockPendingTransferModel? editStockPendingTransfer;
  if (state.widget.stockPendingTransferCode != null) {
    ApiResponseModel<StockPendingTransferModel> purchaseResponse = response[0];
    if (!purchaseResponse.responseType.success || purchaseResponse.data == null) {
      state.params.returnedPurchase.setError(purchaseResponse.firstError());
      state.params.returnedPurchase.setStatus(Status.error);
      state._refresh();
      return;
    }

    editStockPendingTransfer = purchaseResponse.data!;
  }
  await _setInitialValues(state, editStockPendingTransfer);
  state.params.returnedPurchase.resetError();
  state.params.returnedPurchase.setStatus(Status.success);
  state._refresh();
}

Future<void> _setInitialValues(
    _AddEditStockPendingTransferScreenState state, StockPendingTransferModel? stockPendingTransfer) async {
  state.params.returnedPurchase.reset(stockPendingTransfer);
  state.params.returnedPurchaseList.reset(null);
  state.params.returnedPurchaseList.options = stockPendingTransfer?.items ?? [StockPendingTransferItemModel.empty()];
}

void _resetErrors(_AddEditStockPendingTransferScreenState state) =>
    state.params.allParams().forEach((d) => d.resetError());

void _dispose(_AddEditStockPendingTransferScreenState state) => state.params.allParams().forEach((d) => d.dispose());

Future<void> _onSaveTap(_AddEditStockPendingTransferScreenState state) async {
  String errorMessage = '';

  PurchaseModel? purchaseModel = _validate(state);
  state._refresh();
  if (purchaseModel == null) return;

  bool confirmed = await _askConfirmationToAddOrEdit(state);
  if (!confirmed) return;

  await handleFutureWithAlert(
    errorMessage: () => errorMessage,
    progressbarWaitDuration: Duration.zero,
    function: () async {
      // final createBranchResponse = state.widget.stockPendingTransferCode == null
      //     ? await PurchaseService.createPurchase(purchaseModel)
      //     : await PurchaseService.updatePurchase(purchaseModel);
      //
      // if (!createBranchResponse.responseType.success || createBranchResponse.data == null) {
      //   errorMessage = createBranchResponse.firstError();
      //   return Status.error;
      // }
      return Status.success;
    },
    onSuccess: () {
      AppSnackBar.showSnackBarWithText(
        text: state.widget.stockPendingTransferCode == null
            ? 'Purchase created successfully'
            : 'Purchase updated successfully',
        duration: state.widget.stockPendingTransferCode == null ? const Duration(seconds: 6) : null,
      );
      AppNavigator.navigate(AppRoutes.returnedPurchaseList);
    },
  );
}

PurchaseModel? _validate(_AddEditStockPendingTransferScreenState state) {
  _resetErrors(state);
  AddStockPendingTransferParams param = state.params;
  final itemList = param.returnedPurchaseList;

  bool isPersonalDetailsValid = Validator.validate(
    [
      // CustomValidators.typeValidator(
      //   field: 'Item',
      //   data: item,
      //   error: param.item.error,
      //   types: [CommonKeyValueModel],
      // ),
      for (final i in itemList.options) ...[
        CustomValidators.typeValidator(
          field: 'Item',
          data: i.item.value,
          types: [CommonKeyValueModel],
          error: i.item.error,
        ),
        CustomValidators.nameValidator(field: 'Tax', error: i.qty.error, data: i.qty.text),
        CustomValidators.nameValidator(field: 'Label', error: i.qty.error, data: i.qty.text),
        CustomValidators.moneyValidator(
          field: 'Total Price',
          amount: i.qty.text,
          error: i.qty.error,
        ),
        // CustomValidators.typeValidator(field: 'Unit', data: i.units.selected, types: [UnitModel], error: i.units.error),
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

  PurchaseModel branchModel = PurchaseModel(
    supplierName: '',
    billAmount: 0,
    createdTime: DateTime.now(),
    purchaseBillNumber: '',
    purchaseCode: '',
    landingCost: 0,
    buyingPrice: 0,
    itemCode: '',
    supplierCode: '',
    disabled: false,
    selected: false,
    itemName: '',
    quantity: 0,
    sellingPrice: 0,
    tax: 0,
    items: [],
  );
  return branchModel;
}

Future<void> _onCloseTap(_AddEditStockPendingTransferScreenState state) async {
  bool confirmed = false;

  await showDoubleButtonAlert(
    DoubleButtonAlertModel(
      onRightTap: () => {confirmed = true, AppNavigator.pop()},
      content:
          'Are you sure you want to cancel ${state.widget.stockPendingTransferCode == null ? 'adding' : 'editing'} this Stock Pending Transfer?',
    ),
    canClose: true,
  );

  if (!confirmed) return;

  AppNavigator.navigate(AppRoutes.stockTransfer);
}

Future<bool> _askConfirmationToAddOrEdit(_AddEditStockPendingTransferScreenState state) async {
  bool confirmed = false;

  await showDoubleButtonAlert(
    DoubleButtonAlertModel(
      onRightTap: () => {confirmed = true, AppNavigator.pop()},
      content:
          'Are you sure you want to ${state.widget.stockPendingTransferCode == null ? 'create' : 'update'} this Stock Pending Transfer?',
    ),
    canClose: true,
  );

  return confirmed;
}
