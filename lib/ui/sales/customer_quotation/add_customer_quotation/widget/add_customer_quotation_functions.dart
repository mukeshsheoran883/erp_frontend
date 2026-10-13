part of '../add_customer_quotation_screen.dart';

Future<void> _getCustomerQuotation(
    _AddEditCustomerQuotationsScreenState state) async {
  _setInitialValues(state, [], null);
  state._refresh();

  final response = await Future.wait([
    BranchService.getBranchList(pageNumber: 1, searchKey: '', filter: null),
    if (state.widget.customerQuotationCode != null)
      CustomerQuotationService.getCustomerQuotation(
          customerQuotationCode: state.widget.customerQuotationCode!),
  ]);

  ApiResponseModel<List<BranchModel>> branchResponse =
      response[0] as ApiResponseModel<List<BranchModel>>;

  CustomerQuotationModel? editQuotation;
  if (state.widget.customerQuotationCode != null) {
    ApiResponseModel<CustomerQuotationModel> quotationResponse =
        response[1] as ApiResponseModel<CustomerQuotationModel>;
    if (!quotationResponse.responseType.success ||
        quotationResponse.data == null) {
      state.params.customerQuotation.setError(quotationResponse.firstError());
      state.params.customerQuotation.setStatus(Status.error);
      state._refresh();
      return;
    }
    editQuotation = quotationResponse.data!;
  }

  if (!branchResponse.responseType.success || branchResponse.data == null) {
    state.params.customerQuotation.setError(branchResponse.firstError());
    state.params.customerQuotation.setStatus(Status.error);
    state._refresh();
    return;
  }

  await _setInitialValues(state, branchResponse.data!, editQuotation);
  state.params.customerQuotation.resetError();
  state.params.customerQuotation.setStatus(Status.success);
  state._refresh();
}

Future<void> _setInitialValues(
  _AddEditCustomerQuotationsScreenState state,
  List<BranchModel> branches,
  CustomerQuotationModel? quotation,
) async {
  state.params.customerQuotation.reset(quotation);

  // NEW: if editing, pre-select the customer (name shown as the selected value)
  state.params.customer.reset(
    quotation == null
        ? null
        : CommonKeyValueModel(
            id: quotation.customerName, value: quotation.customerName),
  );

  state.params.customerName.reset(quotation?.customerName);
  state.params.customerPhone.reset(quotation?.customerPhone);
  state.params.customerEmail.reset(quotation?.customerEmail);

  state.params.shop.reset(
    quotation == null
        ? null
        : CommonKeyValueModel(
            id: quotation.shopCode, value: quotation.shopCode),
  );
  state.params.shop.options = ValueNotifier(
    branches
        .map((b) => CommonKeyValueModel(id: b.shopCode, value: b.name))
        .toList(),
  );

  state.params.items = (quotation != null && quotation.items.isNotEmpty)
      ? quotation.items.map((i) {
          final entry = CustomerQuotationItemEntry.empty();
          entry.item
              .reset(CommonKeyValueModel(id: i.itemCode, value: i.itemCode));
          entry.quantity.reset(i.quantity.toString());
          return entry;
        }).toList()
      : [CustomerQuotationItemEntry.empty()];

  _resetErrors(state);
}

void _resetErrors(_AddEditCustomerQuotationsScreenState state) =>
    state.params.allParams().forEach((d) => d.resetError());

void _dispose(_AddEditCustomerQuotationsScreenState state) =>
    state.params.allParams().forEach((d) => d.dispose());

// NEW: Customer search — same pattern as _onItemSearch
Future<SearchApiResponseModel> _onCustomerSearch(SearchModel search) async {
  final response = await CustomerService.getCustomerList(
    pageNumber: search.pageNumber,
    searchKey: search.text,
    filter: null,
  );

  // cache full customer data so we can fill phone/email on selection
  if (response.data != null) {
    for (final customer in response.data!) {
      _AddEditCustomerQuotationsScreenState
          .customerCache[customer.customerCode] = customer;
    }
  }

  return SearchApiResponseModel(
    response: response,
    items: response.data
            ?.map((e) => CommonKeyValueModel(id: e.customerCode, value: e.name))
            .toList() ??
        [],
    searchResultsFor: search.text,
  );
}

Future<void> _onSaveTap(_AddEditCustomerQuotationsScreenState state) async {
  String errorMessage = '';

  CustomerQuotationModel? quotationModel = _validate(state);
  state._refresh();
  if (quotationModel == null) return;

  bool confirmed = await _askConfirmationToAddOrEdit(state);
  if (!confirmed) return;

  await handleFutureWithAlert(
    errorMessage: () => errorMessage,
    progressbarWaitDuration: Duration.zero,
    function: () async {
      final response = state.widget.customerQuotationCode == null
          ? await CustomerQuotationService.createCustomerQuotation(
              quotationModel)
          : await CustomerQuotationService.createCustomerQuotation(
              quotationModel); // NOTE: this method is currently commented out in the service — needs enabling

      if (!response.responseType.success || response.data == null) {
        errorMessage = response.firstError();
        return Status.error;
      }
      return Status.success;
    },
    onSuccess: () {
      AppSnackBar.showSnackBarWithText(
        text: state.widget.customerQuotationCode == null
            ? 'Customer quotation created successfully'
            : 'Customer quotation updated successfully',
        duration: state.widget.customerQuotationCode == null
            ? const Duration(seconds: 6)
            : null,
      );
      AppNavigator.navigate(AppRoutes.customerQuotationsList);
    },
  );
}

CustomerQuotationModel? _validate(_AddEditCustomerQuotationsScreenState state) {
  _resetErrors(state);
  AddCustomerQuotationParams param = state.params;

  String name = param.customerName.text;
  String phone = param.customerPhone.text;
  String email = param.customerEmail.text;
  CommonKeyValueModel? shop = param.shop.selected;

  bool isValid = Validator.validate([
    CustomValidators.typeValidator(
        field: 'Customer',
        data: param.customer.value,
        error: param.customer.error,
        types: [CommonKeyValueModel]),
    CustomValidators.nameValidator(
        field: 'Customer name', data: name, error: param.customerName.error),
    CustomValidators.nameValidator(
        field: 'Customer phone', data: phone, error: param.customerPhone.error),
    CustomValidators.emailValidator(
      field: 'Customer email',
      email: email,
      error: param.customerEmail.error,
      required: false,
    ),
    CustomValidators.typeValidator(
        field: 'Shop',
        data: shop,
        error: param.shop.error,
        types: [CommonKeyValueModel]),
    for (final item in param.items) ...[
      CustomValidators.typeValidator(
        field: 'Item',
        data: item.item.value,
        error: item.item.error,
        types: [CommonKeyValueModel],
      ),
      CustomValidators.minMaxValidator(
        field: 'Quantity',
        value: double.tryParse(item.quantity.text) ?? 0,
        error: item.quantity.error,
        min: 1,
      ),
    ],
  ]);

  if (!isValid) return null;

  return CustomerQuotationModel(
    customerQuotationId:
        state.params.customerQuotation.value?.customerQuotationId ?? 0,
    customerQuotationCode: state.widget.customerQuotationCode ?? '',
    customerName: name,
    customerPhone: phone,
    customerEmail: email,
    status: state.params.customerQuotation.value?.status ?? '',
    createdAt:
        state.params.customerQuotation.value?.createdAt ?? DateTime.now(),
    shopCode: shop!.id,
    items: param.items
        .map((i) => CustomerQuotationItemModel(
      itemCode: i.item.value!.id,
      quantity: (double.tryParse(i.quantity.text) ?? 1).toInt(),
    ))
        .toList(),
    disabled: false,
    selected: false,
  );
}

Future<void> _onCloseTap(_AddEditCustomerQuotationsScreenState state) async {
  bool confirmed = false;

  await showDoubleButtonAlert(
    DoubleButtonAlertModel(
      onRightTap: () => {confirmed = true, AppNavigator.pop()},
      content:
          'Are you sure you want to cancel ${state.widget.customerQuotationCode == null ? 'adding' : 'editing'} this quotation?',
    ),
    canClose: true,
  );

  if (!confirmed) return;

  AppNavigator.navigate(AppRoutes.customerQuotationsList);
}

Future<bool> _askConfirmationToAddOrEdit(
    _AddEditCustomerQuotationsScreenState state) async {
  bool confirmed = false;

  await showDoubleButtonAlert(
    DoubleButtonAlertModel(
      onRightTap: () => {confirmed = true, AppNavigator.pop()},
      content:
          'Are you sure you want to ${state.widget.customerQuotationCode == null ? 'create' : 'update'} this quotation?',
    ),
    canClose: true,
  );

  return confirmed;
}
