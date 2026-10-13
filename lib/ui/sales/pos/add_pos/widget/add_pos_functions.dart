part of '../add_pos_screen.dart';

Future<void> _getPos(_AddEditPosScreenState state) async {
  _setInitialValues(state, [], null);
  state._refresh();

  final response = await Future.wait([
    BranchService.getBranchList(pageNumber: 1, searchKey: '', filter: null),
    if (state.widget.posCode != null)
      PosService.getPos(posCode: state.widget.posCode!, posId: ''),
  ]);

  ApiResponseModel<List<BranchModel>> branchResponse =
  response[0] as ApiResponseModel<List<BranchModel>>;

  PosModel? editPos;
  if (state.widget.posCode != null) {
    ApiResponseModel<PosModel> posResponse =
    response[1] as ApiResponseModel<PosModel>;
    if (!posResponse.responseType.success || posResponse.data == null) {
      state.params.pos.setError(posResponse.firstError());
      state.params.pos.setStatus(Status.error);
      state._refresh();
      return;
    }
    editPos = posResponse.data!;
  }

  if (!branchResponse.responseType.success || branchResponse.data == null) {
    state.params.pos.setError(branchResponse.firstError());
    state.params.pos.setStatus(Status.error);
    state._refresh();
    return;
  }

  await _setInitialValues(state, branchResponse.data!, editPos);
  state.params.pos.resetError();
  state.params.pos.setStatus(Status.success);
  state._refresh();
}

Future<void> _setInitialValues(
    _AddEditPosScreenState state,
    List<BranchModel> branches,
    PosModel? pos,
    ) async {
  state.params.pos.reset(pos);

  // NOTE: PosModel (GET) has no customer_code / customer_quotation_code / items —
  // only customerName (display), customerQuotationId (int), etc. So these can't be
  // reliably prefilled on edit until the GET response includes the actual codes.
  state.params.customer.reset(
    pos == null
        ? null
        : CommonKeyValueModel(id: pos.customerCode, value: pos.customerName),
  );

  state.params.shop.reset(
    pos == null
        ? null
        : CommonKeyValueModel(id: pos.shopCode, value: pos.shopCode),
  );
  state.params.shop.options = ValueNotifier(
    branches
        .map((b) => CommonKeyValueModel(id: b.shopCode, value: b.name))
        .toList(),
  );

  // state.params.customerQuotation.reset(
  //   pos == null
  //       ? null
  //       : CommonKeyValueModel(
  //       id: pos.customerQuotationCode, value: pos.customerQuotationCode),
  // );

  state.params.items = (pos != null && pos.items.isNotEmpty)
      ? pos.items.map((i) {
    final entry = PosItemEntry.empty();
    // NOTE: kept consistent with search-result format (name + code) where possible
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
      : [PosItemEntry.empty()];

  _resetErrors(state);
}

void _resetErrors(_AddEditPosScreenState state) =>
    state.params.allParams().forEach((d) => d.resetError());

void _dispose(_AddEditPosScreenState state) =>
    state.params.allParams().forEach((d) => d.dispose());

Future<void> _onSaveTap(_AddEditPosScreenState state) async {
  String errorMessage = '';

  PosModel? posModel = _validate(state);
  state._refresh();
  if (posModel == null) return;

  bool confirmed = await _askConfirmationToAddOrEdit(state);
  if (!confirmed) return;

  await handleFutureWithAlert(
    errorMessage: () => errorMessage,
    progressbarWaitDuration: Duration.zero,
    function: () async {
      final response = state.widget.posCode == null
          ? await PosService.createPos(posModel)
          : await PosService.createPos(posModel);

      if (!response.responseType.success || response.data == null) {
        errorMessage = response.firstError();
        return Status.error;
      }
      return Status.success;
    },
    onSuccess: () {
      AppSnackBar.showSnackBarWithText(
        text: state.widget.posCode == null
            ? 'Sale created successfully'
            : 'Sale updated successfully',
        duration:
        state.widget.posCode == null ? const Duration(seconds: 6) : null,
      );
      AppNavigator.navigate(AppRoutes.posList);
    },
  );
}

PosModel? _validate(_AddEditPosScreenState state) {
  _resetErrors(state);
  AddPosParams param = state.params;

  bool isValid = Validator.validate([
    CustomValidators.typeValidator(
      field: 'Customer',
      data: param.customer.value,
      error: param.customer.error,
      types: [CommonKeyValueModel],
    ),
    CustomValidators.typeValidator(
      field: 'Shop',
      data: param.shop.selected,
      error: param.shop.error,
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
      CustomValidators.moneyValidator(
          field: 'Price', amount: item.price.text, error: item.price.error),
      CustomValidators.moneyValidator(
          field: 'Tax', amount: item.tax.text, error: item.tax.error),
      CustomValidators.moneyValidator(
          field: 'Discount',
          amount: item.discount.text,
          error: item.discount.error),
    ],
  ]);

  if (!isValid) return null;

  return PosModel(
    posId: state.params.pos.value?.posId ?? 0,
    posCode: state.widget.posCode ?? '',
    customerName: state.params.pos.value?.customerName ?? '',
    customerCode: param.customer.value!.id,
    shopCode: param.shop.selected!.id,
    paymentType: state.params.pos.value?.paymentType ?? '',
    paymentStatus: state.params.pos.value?.paymentStatus ?? '',
    amount: state.params.pos.value?.amount ?? 0,
    status: state.params.pos.value?.status ?? '',
    customerQuotationId: state.params.pos.value?.customerQuotationId ?? 0,
    // customerQuotationCode: param.customerQuotation.value?.id ?? '',
    createdDate: state.params.pos.value?.createdDate ?? DateTime.now(),
    items: param.items
        .map((i) => PosItemModel(
      itemCode: i.item.value!.id,
      // NEW: robust parse — handles "5" and "5.0" the same way
      quantity: (double.tryParse(i.quantity.text) ?? 1).toInt(),
      price: double.tryParse(i.price.text) ?? 0,
      tax: double.tryParse(i.tax.text) ?? 0,
      discount: double.tryParse(i.discount.text) ?? 0,
      posItemId: 0,
      itemName: '',
      total: 0,
    ))
        .toList(),
    disabled: false,
    selected: false,
    discounts: 0,
    discountsUnit: '',
    waveOff: 0,
    dispatch: Dispatch(logisticsCharges: '', logisticsCompany: ''),
  );
}

Future<void> _onCloseTap(_AddEditPosScreenState state) async {
  bool confirmed = false;

  await showDoubleButtonAlert(
    DoubleButtonAlertModel(
      onRightTap: () => {confirmed = true, AppNavigator.pop()},
      content:
      'Are you sure you want to cancel ${state.widget.posCode == null ? 'adding' : 'editing'} this sale?',
    ),
    canClose: true,
  );

  if (!confirmed) return;

  AppNavigator.navigate(AppRoutes.posList);
}

Future<bool> _askConfirmationToAddOrEdit(_AddEditPosScreenState state) async {
  bool confirmed = false;

  await showDoubleButtonAlert(
    DoubleButtonAlertModel(
      onRightTap: () => {confirmed = true, AppNavigator.pop()},
      content:
      'Are you sure you want to ${state.widget.posCode == null ? 'create' : 'update'} this sale?',
    ),
    canClose: true,
  );

  return confirmed;
}