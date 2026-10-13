part of '../add_purchase_screen.dart';

Future<void> _getPurchase(_AddEditPurchaseScreenState state) async {
  await _setInitialValues(state, null);
  state._refresh();
  final response = await Future.wait(
    [
      if (state.widget.purchaseCode != null)
        PurchaseService.getPurchase(purchaseCode: state.widget.purchaseCode!)
    ],
  );

  PurchaseEditModel? editPurchase;
  if (state.widget.purchaseCode != null) {
    ApiResponseModel<PurchaseEditModel> purchaseResponse = response[0];
    if (!purchaseResponse.responseType.success ||
        purchaseResponse.data == null) {
      state.params.purchase.setError(purchaseResponse.firstError());
      state.params.purchase.setStatus(Status.error);
      state._refresh();
      return;
    }

    editPurchase = purchaseResponse.data!;
  }
  await _setInitialValues(state, editPurchase);
  state.params.purchase.resetError();
  state.params.purchase.setStatus(Status.success);
  state._refresh();
}

Future<void> _setInitialValues(
    _AddEditPurchaseScreenState state, PurchaseEditModel? purchase) async {
  state.params.purchase.reset(purchase);
  state.params.purchaseBillNumberField.reset(purchase?.purchaseBillNumber);
  state.params.purchaseList.reset(null);

  state.params.purchaseList.options = purchase == null
      ? [AddEditPurchaseModel.empty()]
      : [AddEditPurchaseModel.fromExisting(purchase)];

  state.params.supplier.options = [];
  state.params.supplier.reset(
    purchase == null
        ? null
        : CommonKeyValueModel(
            id: purchase.supplierName, value: purchase.supplierName),
  );
}

void _resetErrors(_AddEditPurchaseScreenState state) =>
    state.params.allParams().forEach((d) => d.resetError());

void _dispose(_AddEditPurchaseScreenState state) =>
    state.params.allParams().forEach((d) => d.dispose());

Future<void> _onSaveTap(_AddEditPurchaseScreenState state) async {
  String errorMessage = '';

  PurchaseCreateModel? purchaseModel = _validate(state);
  state._refresh();
  if (purchaseModel == null) return;

  bool confirmed = await _askConfirmationToAddOrEdit(state);
  if (!confirmed) return;

  await handleFutureWithAlert(
    errorMessage: () => errorMessage,
    progressbarWaitDuration: Duration.zero,
    function: () async {
      final createBranchResponse = state.widget.purchaseCode == null
          ? await PurchaseService.createPurchase(purchaseModel)
          : await PurchaseService.updatePurchase(purchaseModel);

      if (!createBranchResponse.responseType.success ||
          createBranchResponse.data == null) {
        errorMessage = createBranchResponse.firstError();
        return Status.error;
      }
      return Status.success;
    },
    onSuccess: () {
      AppSnackBar.showSnackBarWithText(
        text: state.widget.purchaseCode == null
            ? 'Purchase created successfully'
            : 'Purchase updated successfully',
        duration: state.widget.purchaseCode == null
            ? const Duration(seconds: 6)
            : null,
      );
      AppNavigator.navigate(AppRoutes.purchaseList);
    },
  );
}

PurchaseCreateModel? _validate(_AddEditPurchaseScreenState state) {
  _resetErrors(state);
  AddPurchaseParams param = state.params;
  String billNumber = param.purchaseBillNumberField.text;
  CommonKeyValueModel? supplier = param.supplier.selected;
  final itemList = param.purchaseList;

  bool isPersonalDetailsValid = Validator.validate(
    [
      CustomValidators.nameValidator(
        field: 'Bill number',
        data: billNumber,
        error: param.purchaseBillNumberField.error,
      ),
      CustomValidators.typeValidator(
        field: 'Supplier',
        data: supplier,
        error: param.supplier.error,
        types: [CommonKeyValueModel],
      ),
      for (final i in itemList.options) ...[
        CustomValidators.typeValidator(
          field: 'Item',
          data: i.item.value,
          types: [CommonKeyValueModel],
          error: i.item.error,
        ),
        CustomValidators.moneyValidator(
            field: 'Buying price',
            amount: i.buyingPrice.text,
            error: i.buyingPrice.error),
        CustomValidators.moneyValidator(
          field: 'Landing cost',
          amount: i.landingCost.text,
          error: i.landingCost.error,
        ),
        CustomValidators.moneyValidator(
          field: 'Selling price',
          amount: i.sellingPrice.text,
          error: i.sellingPrice.error,
        ),
        CustomValidators.moneyValidator(
          field: 'Tax',
          amount: i.tax.text,
          error: i.tax.error,
        ),
        CustomValidators.typeValidator(
            field: 'Unit',
            data: i.units.selected,
            types: [UnitModel],
            error: i.units.error),
        CustomValidators.minMaxValidator(
          field: '',
          value: double.tryParse(i.quantity.text) ?? 0,
          error: i.quantity.error,
          min: 0,
        ),
        CustomValidators.dateValidator(
          field: 'Expiry',
          date: i.expiry.dateTime,
          maxDate: DateTime.now(),
          error: i.expiry.error,
        ),
        for (final split in i.branchSplits) ...[
          CustomValidators.typeValidator(
            field: 'Branch',
            data: split.branch.value,
            types: [CommonKeyValueModel],
            error: split.branch.error,
          ),
          CustomValidators.minMaxValidator(
            field: '',
            value: double.tryParse(split.quantity.text) ?? 0,
            error: split.quantity.error,
            min: 0,
          ),
        ],
      ],
    ],
  );

  if (!isPersonalDetailsValid) return null;

  final items = itemList.options
      .map(
        (i) => PurchaseItemRequestModel(
          itemCode: i.item.value!.id,
          buyingPrice: int.tryParse(i.buyingPrice.text) ?? 0,
          landingCost: int.tryParse(i.landingCost.text) ?? 0,
          sellingPrice: int.tryParse(i.sellingPrice.text) ?? 0,
          tax: int.tryParse(i.tax.text) ?? 0,
          quantity: int.tryParse(i.quantity.text) ?? 0,
          unit: i.units.selected!.id,
          expiry: i.expiry.dateTime ?? DateTime.now(),
          branchSplit: i.branchSplits
              .map(
                (s) => BranchSplitModel(
                  branchCode: s.branch.value!.id,
                  quantity: double.tryParse(s.quantity.text) ?? 0,
                ),
              )
              .toList(),
        ),
      )
      .toList();

  final totalBillAmount = items.fold<double>(
    0,
    (sum, item) => sum + (item.buyingPrice * item.quantity) + item.tax,
  );

  return PurchaseCreateModel(
    purchaseBillNumber: billNumber,
    supplierCode: supplier!.id,
    billAmount: totalBillAmount,
    items: items,
  );
}

Future<void> _onCloseTap(_AddEditPurchaseScreenState state) async {
  bool confirmed = false;

  await showDoubleButtonAlert(
    DoubleButtonAlertModel(
      onRightTap: () => {confirmed = true, AppNavigator.pop()},
      content:
          'Are you sure you want to cancel ${state.widget.purchaseCode == null ? 'adding' : 'editing'} this purchase?',
    ),
    canClose: true,
  );

  if (!confirmed) return;

  AppNavigator.navigate(AppRoutes.purchaseList);
}

Future<bool> _askConfirmationToAddOrEdit(
    _AddEditPurchaseScreenState state) async {
  bool confirmed = false;

  await showDoubleButtonAlert(
    DoubleButtonAlertModel(
      onRightTap: () => {confirmed = true, AppNavigator.pop()},
      content:
          'Are you sure you want to ${state.widget.purchaseCode == null ? 'create' : 'update'} this purchase?',
    ),
    canClose: true,
  );

  return confirmed;
}
