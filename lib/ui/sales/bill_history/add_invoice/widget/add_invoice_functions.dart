part of '../add_invoice_screen.dart';

Future<void> _getBill(_AddEditInvoiceScreenState state) async {
  _setInitialValues(state, null);
  state._refresh();

  final response = await Future.wait([
    if (state.widget.invoiceCode != null)
      BillHistoryService.getBillHistory(billHistoryCode: state.widget.invoiceCode!),
  ]);

  BillHistoryModel? bill;

  if (state.widget.invoiceCode != null) {
    ApiResponseModel<BillHistoryModel> billResponse = response[0];
    if (!billResponse.responseType.success || billResponse.data == null) {
      state.params.bill.setError(billResponse.firstError());
      state.params.bill.setStatus(Status.error);
      state._refresh();
      return;
    }

    bill = billResponse.data!;
  }

  await _setInitialValues(state, bill);
  state.params.bill.resetError();
  state.params.bill.setStatus(Status.success);
  state._refresh();
}

Future<void> _setInitialValues(
    _AddEditInvoiceScreenState state,
    BillHistoryModel? bill,
    ) async {
  state.params.bill.reset(bill);

  state.params.customer.reset(
    bill == null ? null : CommonKeyValueModel(id: bill.customerName, value: bill.customerName),
  );
  state.params.customerName.reset(bill?.customerName);
  state.params.customerPhone.reset(bill?.customerPhone);

  state.params.items = (bill != null && bill.items.isNotEmpty)
      ? bill.items.map((i) {
    final entry = InvoiceItemEntry.empty();
    entry.item.reset(CommonKeyValueModel(
      id: i.itemCode,
      value: i.itemName.isNotEmpty ? '${i.itemName} (${i.itemCode})' : i.itemCode,
    ));
    entry.quantity.reset(i.quantity.toString());
    entry.price.controller.text = i.price.toString();
    entry.tax.controller.text = i.tax.toString();
    entry.discount.controller.text = i.discount.toString();
    return entry;
  }).toList()
      : [InvoiceItemEntry.empty()];

  _resetErrors(state);
}

void _resetErrors(_AddEditInvoiceScreenState state) =>
    state.params.allParams().forEach((d) => d.resetError());

void _dispose(_AddEditInvoiceScreenState state) =>
    state.params.allParams().forEach((d) => d.dispose());

Future<void> _onSaveTap(_AddEditInvoiceScreenState state) async {
  String errorMessage = '';
  BillHistoryModel? billHistoryModel = _validate(state);
  state._refresh();
  if (billHistoryModel == null) return;
  bool confirmed = await _askConfirmationToAddOrEdit(state);
  if (!confirmed) return;

  await handleFutureWithAlert(
    errorMessage: () => errorMessage,
    progressbarWaitDuration: Duration.zero,
    function: () async {
      final createEmployeeResponse = state.widget.invoiceCode == null
          ? await BillHistoryService.createBillHistory(billHistoryModel)
          : await BillHistoryService.updateBillHistory(billHistoryModel);

      if (!createEmployeeResponse.responseType.success || createEmployeeResponse.data == null) {
        errorMessage = createEmployeeResponse.firstError();
        return Status.error;
      }
      return Status.success;
    },
    onSuccess: () {
      AppSnackBar.showSnackBarWithText(
        text: state.widget.invoiceCode == null
            ? 'Invoice created successfully'
            : 'Invoice updated successfully',
        duration: state.widget.invoiceCode == null ? const Duration(seconds: 6) : null,
      );
      AppNavigator.navigate(AppRoutes.billHistoryList);
    },
  );
}

BillHistoryModel? _validate(_AddEditInvoiceScreenState state) {
  _resetErrors(state);
  AddInvoiceParams param = state.params;

  String name = param.customerName.text;
  String phone = param.customerPhone.text;

  bool isValid = Validator.validate([
    CustomValidators.typeValidator(
      field: 'Customer',
      data: param.customer.value,
      error: param.customer.error,
      types: [CommonKeyValueModel],
    ),
    for (final item in param.items) ...[
      CustomValidators.typeValidator(
        field: 'Item',
        data: item.item.value,
        error: item.item.error,
        types: [CommonKeyValueModel],
      ),
      CustomValidators.minMaxValidator(
        field: '',
        value: double.tryParse(item.quantity.text) ?? 0,
        error: item.quantity.error,
        min: 1,
      ),
      CustomValidators.moneyValidator(field: 'Price', amount: item.price.text, error: item.price.error),
      CustomValidators.moneyValidator(field: 'Tax', amount: item.tax.text, error: item.tax.error),
      CustomValidators.moneyValidator(field: 'Discount', amount: item.discount.text, error: item.discount.error),
    ],
  ]);

  if (!isValid) return null;

  return BillHistoryModel(
    billNumber: state.params.bill.value?.billNumber ?? '',
    date: state.params.bill.value?.date ?? DateTime.now(),
    customerName: name,
    customerPhone: phone,
    posCode: state.params.bill.value?.posCode ?? '',
    totalPrice: 0,
    disabled: false,
    selected: false,
    items: param.items
        .map((i) => InvoiceItemModel(
      itemCode: i.item.value!.id,
      quantity: (double.tryParse(i.quantity.text) ?? 1),
      price: double.tryParse(i.price.text) ?? 0,
      tax: double.tryParse(i.tax.text) ?? 0,
      discount: double.tryParse(i.discount.text) ?? 0,
    ))
        .toList(),
  );
}

Future<void> _onCloseTap(_AddEditInvoiceScreenState state) async {
  bool confirmed = false;

  await showDoubleButtonAlert(
    DoubleButtonAlertModel(
      onRightTap: () => {confirmed = true, AppNavigator.pop()},
      content:
      'Are you sure you want to cancel ${state.widget.invoiceCode == null ? 'adding' : 'editing'} this invoice?',
    ),
    canClose: true,
  );

  if (!confirmed) return;

  AppNavigator.navigate(AppRoutes.billHistoryList);
}

Future<bool> _askConfirmationToAddOrEdit(_AddEditInvoiceScreenState state) async {
  bool confirmed = false;

  await showDoubleButtonAlert(
    DoubleButtonAlertModel(
      onRightTap: () => {confirmed = true, AppNavigator.pop()},
      content:
      'Are you sure you want to ${state.widget.invoiceCode == null ? 'create' : 'update'} this invoice?',
    ),
    canClose: true,
  );

  return confirmed;
}