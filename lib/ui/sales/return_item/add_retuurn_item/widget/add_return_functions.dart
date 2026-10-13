part of '../add_return_item_screen.dart';

Future<void> _getReturnItem(_AddEditReturnItemScreenState state) async {
  await _setInitialValues(state, null);
  state._refresh();
  final response = await Future.wait(
    [if (state.widget.returnItemCode != null) ReturnItemService.getReturnItem(returnItemCode: state.widget.returnItemCode!)],
  );

  ReturnItemModel? editReturn;
  if (state.widget.returnItemCode != null) {
    ApiResponseModel<ReturnItemModel> returnResponse = response[0];
    if (!returnResponse.responseType.success || returnResponse.data == null) {
      state.params.returnItem.setError(returnResponse.firstError());
      state.params.returnItem.setStatus(Status.error);
      state._refresh();
      return;
    }
    editReturn = returnResponse.data!;
  }
  await _setInitialValues(state, editReturn);
  state.params.returnItem.resetError();
  state.params.returnItem.setStatus(Status.success);
  state._refresh();
}

// NOTE: `ReturnItemModel` (list/display shape) doesn't carry item_code / supplier_code /
// a single flat quantity-price-tax — it only has customerName + a nested items[] with
// itemName/qty/tax/price. So this prefill is a BEST-GUESS using the first item in that
// list, with item/supplier "name" used as a placeholder id. Once you share the actual
// GET-single-return JSON, this mapping needs to be corrected to use real codes.
Future<void> _setInitialValues(_AddEditReturnItemScreenState state, ReturnItemModel? returnItem) async {
  state.params.returnItem.reset(returnItem);
  state.params.purchaseBillNumberField.reset(returnItem?.billNumber);
  state.params.returnReason.reset(returnItem?.returnReason);

  state.params.supplier.options = [];
  state.params.supplier.reset(
    returnItem == null ? null : CommonKeyValueModel(id: returnItem.customerName, value: returnItem.customerName),
  );

  final firstItem = (returnItem != null && returnItem.items.isNotEmpty) ? returnItem.items.first : null;
  state.params.item.reset(
    firstItem == null ? null : CommonKeyValueModel(id: firstItem.itemName, value: firstItem.itemName),
  );
  state.params.quantity.reset(firstItem?.qty.toString() ?? '1');
  state.params.price.controller.text = firstItem?.price.toString() ?? '';
  state.params.tax.controller.text = firstItem?.tax.toString() ?? '';
}

void _resetErrors(_AddEditReturnItemScreenState state) => state.params.allParams().forEach((d) => d.resetError());

void _dispose(_AddEditReturnItemScreenState state) => state.params.allParams().forEach((d) => d.dispose());

Future<void> _onSaveTap(_AddEditReturnItemScreenState state) async {
  String errorMessage = '';

  ReturnCreateModel? returnModel = _validate(state);
  state._refresh();
  if (returnModel == null) return;

  bool confirmed = await _askConfirmationToAddOrEdit(state);
  if (!confirmed) return;

  await handleFutureWithAlert(
    errorMessage: () => errorMessage,
    progressbarWaitDuration: Duration.zero,
    function: () async {
      final response = state.widget.returnItemCode == null
          ? await ReturnItemService.createReturnItem(returnModel)
          : await ReturnItemService.updateReturnItem(returnModel);

      if (!response.responseType.success || response.data == null) {
        errorMessage = response.firstError();
        return Status.error;
      }
      return Status.success;
    },
    onSuccess: () {
      AppSnackBar.showSnackBarWithText(
        text: state.widget.returnItemCode == null ? 'Return created successfully' : 'Return updated successfully',
        duration: state.widget.returnItemCode == null ? const Duration(seconds: 6) : null,
      );
      AppNavigator.navigate(AppRoutes.returnItemList);
    },
  );
}

ReturnCreateModel? _validate(_AddEditReturnItemScreenState state) {
  _resetErrors(state);
  AddReturnParams param = state.params;

  String billNumber = param.purchaseBillNumberField.text;
  CommonKeyValueModel? supplier = param.supplier.selected;
  CommonKeyValueModel? item = param.item.value;

  bool isValid = Validator.validate([
    CustomValidators.nameValidator(
      field: 'Purchase bill number',
      data: billNumber,
      error: param.purchaseBillNumberField.error,
    ),
    CustomValidators.typeValidator(
      field: 'Supplier',
      data: supplier,
      error: param.supplier.error,
      types: [CommonKeyValueModel],
    ),
    CustomValidators.typeValidator(
      field: 'Item',
      data: item,
      error: param.item.error,
      types: [CommonKeyValueModel],
    ),
    CustomValidators.nameValidator(
      field: 'Return reason',
      data: param.returnReason.text,
      error: param.returnReason.error,
    ),
    CustomValidators.minMaxValidator(
      field: '',
      value: double.tryParse(param.quantity.text) ?? 0,
      error: param.quantity.error,
      min: 0,
    ),
    CustomValidators.moneyValidator(field: 'Price', amount: param.price.text, error: param.price.error),
    CustomValidators.moneyValidator(field: 'Tax', amount: param.tax.text, error: param.tax.error),
  ]);

  if (!isValid) return null;

  return ReturnCreateModel(
    purchaseBillNumber: billNumber,
    supplierCode: supplier!.id,
    itemCode: item!.id,
    returnReason: param.returnReason.text,
    quantity: double.tryParse(param.quantity.text) ?? 0,
    price: double.tryParse(param.price.text) ?? 0,
    tax: double.tryParse(param.tax.text) ?? 0,
  );
}

Future<void> _onCloseTap(_AddEditReturnItemScreenState state) async {
  bool confirmed = false;

  await showDoubleButtonAlert(
    DoubleButtonAlertModel(
      onRightTap: () => {confirmed = true, AppNavigator.pop()},
      content:
      'Are you sure you want to cancel ${state.widget.returnItemCode == null ? 'adding' : 'editing'} this return?',
    ),
    canClose: true,
  );

  if (!confirmed) return;

  AppNavigator.navigate(AppRoutes.returnItemList); // NOTE: confirm this route name
}

Future<bool> _askConfirmationToAddOrEdit(_AddEditReturnItemScreenState state) async {
  bool confirmed = false;

  await showDoubleButtonAlert(
    DoubleButtonAlertModel(
      onRightTap: () => {confirmed = true, AppNavigator.pop()},
      content: 'Are you sure you want to ${state.widget.returnItemCode == null ? 'create' : 'update'} this return?',
    ),
    canClose: true,
  );

  return confirmed;
}