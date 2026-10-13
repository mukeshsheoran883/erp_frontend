part of '../add_returned_purchase_screen.dart';

Future<void> _getPurchase(_AddEditReturnedPurchaseScreenState state) async {
  await _setInitialValues(state, null, null);
  state._refresh();
  final response = await Future.wait(
    [
      if (state.widget.returnedPurchaseCode != null)
        ReturnedPurchasesService.getReturnedPurchaseDummy(purchaseCode: state.widget.returnedPurchaseCode!)
    ],
  );

  ReturnedPurchaseModel? editReturnedPurchase;
  List<ReturnedItem>? editReturnedItem;

  if (state.widget.returnedPurchaseCode != null) {
    ApiResponseModel<ReturnedPurchaseModel> purchaseResponse = response[0];
    if (!purchaseResponse.responseType.success || purchaseResponse.data == null) {
      state.params.returnedPurchase.setError(purchaseResponse.firstError());
      state.params.returnedPurchase.setStatus(Status.error);
      state._refresh();
      return;
    }

    editReturnedPurchase = purchaseResponse.data!;
    editReturnedItem = purchaseResponse.data!.items;
  }
  await _setInitialValues(state, editReturnedPurchase, editReturnedItem);
  state.params.returnedPurchase.resetError();
  state.params.returnedPurchase.setStatus(Status.success);
  state._refresh();
}

Future<void> _setInitialValues(_AddEditReturnedPurchaseScreenState state, ReturnedPurchaseModel? returnedPurchase,
    List<ReturnedItem>? editItem) async {
  state.params.returnedPurchase.reset(returnedPurchase);
  state.params.purchaseId.options = [];
  state.params.purchaseId.reset(returnedPurchase == null
      ? null
      : CommonKeyValueModel(id: returnedPurchase.purchaseCode, value: returnedPurchase.purchaseId));
  state.params.returnedPurchaseList.reset(null);
  state.params.returnedPurchaseList.options = editItem ?? [ReturnedItem.empty()];
  state.params.item.options = [];
  state.params.item.reset(returnedPurchase == null
      ? null
      : CommonKeyValueModel(id: returnedPurchase.itemCode, value: returnedPurchase.itemName));
}

void _resetErrors(_AddEditReturnedPurchaseScreenState state) => state.params.allParams().forEach((d) => d.resetError());

void _dispose(_AddEditReturnedPurchaseScreenState state) => state.params.allParams().forEach((d) => d.dispose());

Future<void> _onSaveTap(_AddEditReturnedPurchaseScreenState state) async {
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
      // final createBranchResponse = state.widget.returnedPurchaseCode == null
      //     ? await PurchaseService.createPurchase(purchaseModel)
      //     : await PurchaseService.updatePurchase(purchaseModel);

      // if (!createBranchResponse.responseType.success || createBranchResponse.data == null) {
      //   errorMessage = createBranchResponse.firstError();
      //   return Status.error;
      // }
      return Status.success;
    },
    onSuccess: () {
      AppSnackBar.showSnackBarWithText(
        text: state.widget.returnedPurchaseCode == null
            ? 'Purchase created successfully'
            : 'Purchase updated successfully',
        duration: state.widget.returnedPurchaseCode == null ? const Duration(seconds: 6) : null,
      );
      AppNavigator.navigate(AppRoutes.returnedPurchaseList);
    },
  );
}

PurchaseModel? _validate(_AddEditReturnedPurchaseScreenState state) {
  _resetErrors(state);
  AddReturnedPurchaseParams param = state.params;
  CommonKeyValueModel? item = param.item.selected;
  CommonKeyValueModel? purchaseId = param.purchaseId.selected;
  final itemList = param.returnedPurchaseList;

  bool isPersonalDetailsValid = Validator.validate(
    [
      CustomValidators.typeValidator(
        field: 'Purchase Id',
        data: purchaseId,
        error: param.purchaseId.error,
        types: [CommonKeyValueModel],
      ),
      CustomValidators.typeValidator(
        field: 'Item',
        data: item,
        error: param.item.error,
        types: [CommonKeyValueModel],
      ),
      for (final i in itemList.options) ...[
        CustomValidators.typeValidator(
          field: 'Item',
          data: i.item.value,
          types: [CommonKeyValueModel],
          error: i.item.error,
        ),
        CustomValidators.nameValidator(field: 'Tax', error: i.tax.error, data: i.tax.text),
        CustomValidators.nameValidator(field: 'Label', error: i.label.error, data: i.label.text),
        CustomValidators.moneyValidator(
          field: 'Total Price',
          amount: i.totalPrice.text,
          error: i.totalPrice.error,
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

Future<void> _onCloseTap(_AddEditReturnedPurchaseScreenState state) async {
  bool confirmed = false;

  await showDoubleButtonAlert(
    DoubleButtonAlertModel(
      onRightTap: () => {confirmed = true, AppNavigator.pop()},
      content:
          'Are you sure you want to cancel ${state.widget.returnedPurchaseCode == null ? 'adding' : 'editing'} this purchase?',
    ),
    canClose: true,
  );

  if (!confirmed) return;

  AppNavigator.navigate(AppRoutes.returnedPurchaseList);
}

Future<bool> _askConfirmationToAddOrEdit(_AddEditReturnedPurchaseScreenState state) async {
  bool confirmed = false;

  await showDoubleButtonAlert(
    DoubleButtonAlertModel(
      onRightTap: () => {confirmed = true, AppNavigator.pop()},
      content:
          'Are you sure you want to ${state.widget.returnedPurchaseCode == null ? 'create' : 'update'} this purchase?',
    ),
    canClose: true,
  );

  return confirmed;
}
