part of '../add_quotations_screen.dart';

Future<void> _getQuotation(_AddEditQuotationsScreenState state) async {
  _setInitialValues(state, [], [], [], [], null);
  state._refresh();

  final response = await Future.wait([
    SupplierService.getAllSupplierList(),
    AdministrationService.getOrganizationList(pageNumber: 1, searchKey: ''),
    ItemService.getItemsList(pageNumber: 1, searchKey: '', filter: null),
    BrandService.getAllBrandList(),
    if (state.widget.quotationsCode != null) QuotationsService.getQuotations(quotationsCode: state.widget.quotationsCode!),
  ]);

  ApiResponseModel<List<SupplierModel>> supplierResponse = response[0] as ApiResponseModel<List<SupplierModel>>;
  ApiResponseModel<List<AdministrationModel>> organisationResponse = response[1] as ApiResponseModel<List<AdministrationModel>>;
  ApiResponseModel<List<ItemModel>> itemResponse = response[2] as ApiResponseModel<List<ItemModel>>;
  ApiResponseModel<List<BrandModel>> brandResponse = response[3] as ApiResponseModel<List<BrandModel>>;

  QuotationsModel? editQuotation;
  if (state.widget.quotationsCode != null) {
    ApiResponseModel<QuotationsModel> quotationResponse = response[3] as ApiResponseModel<QuotationsModel>;
    if (!quotationResponse.responseType.success || quotationResponse.data == null) {
      state.params.quotation.setError(quotationResponse.firstError());
      state.params.quotation.setStatus(Status.error);
      state._refresh();
      return;
    }
    editQuotation = quotationResponse.data!;
  }

  if (!supplierResponse.responseType.success || supplierResponse.data == null) {
    state.params.quotation.setError(supplierResponse.firstError());
    state.params.quotation.setStatus(Status.error);
    state._refresh();
    return;
  }

  if (!organisationResponse.responseType.success || organisationResponse.data == null) {
    state.params.quotation.setError(organisationResponse.firstError());
    state.params.quotation.setStatus(Status.error);
    state._refresh();
    return;
  }

  if (!itemResponse.responseType.success || itemResponse.data == null) {
    state.params.quotation.setError(itemResponse.firstError());
    state.params.quotation.setStatus(Status.error);
    state._refresh();
    return;
  }

  if (!brandResponse.responseType.success || brandResponse.data == null) {
    state.params.quotation.setError(brandResponse.firstError());
    state.params.quotation.setStatus(Status.error);
    state._refresh();
    return;
  }

  await _setInitialValues(state, supplierResponse.data!, organisationResponse.data!, itemResponse.data!, brandResponse.data!, editQuotation);
  state.params.quotation.resetError();
  state.params.quotation.setStatus(Status.success);
  state._refresh();
}

Future<void> _setInitialValues(
    _AddEditQuotationsScreenState state,
    List<SupplierModel> suppliers,
    List<AdministrationModel> organisation,
    List<ItemModel> items,
    List<BrandModel> brands,
    QuotationsModel? quotation,
    ) async {
  state.params.quotation.reset(quotation);
  state.params.description.reset(quotation?.description);
  state.params.quantity.reset(quotation?.quantity.toString() ?? '1');
  state.params.price.controller.text = quotation?.price.toString() ?? '';
  state.params.tax.controller.text = quotation?.tax.toString() ?? '';
  state.params.purchase.reset(quotation?.purchase ?? false);
  state.params.sales.reset(quotation?.sales ?? false);

  state.params.supplier.reset(
    quotation == null ? null : CommonKeyValueModel(id: quotation.supplierName, value: quotation.supplierName),
  );
  state.params.organisation.reset(
    quotation == null ? null : CommonKeyValueModel(id: quotation.organisationId, value: quotation.organisationId),
  );
  state.params.supplier.options = ValueNotifier(
    suppliers.map((s) => CommonKeyValueModel(id: s.supplierCode, value: s.name)).toList(),
  );
 state.params.organisation.options = ValueNotifier(
    organisation.map((s) => CommonKeyValueModel(id: s.organisationId, value: s.contactPersonName)).toList(),
  );

  state.params.item.reset(
    quotation == null ? null : CommonKeyValueModel(id: quotation.itemName, value: quotation.itemName),
  );
  state.params.item.options = ValueNotifier(
    items.map((i) => CommonKeyValueModel(id: i.itemCode, value: i.name)).toList(),
  );

  // NOTE: quotation.brand is a plain string (name), but BrandModel uses brandCode as
  // its id. Prefill below matches on the code equal to the string value — if it
  // doesn't match any brandCode it'll just show unselected. Confirm this is acceptable,
  // or that quotation.brand actually is a brandCode.
  state.params.brand.reset(
    quotation == null ? null : CommonKeyValueModel(id: quotation.brand, value: quotation.brand),
  );
  state.params.brand.options = ValueNotifier(
    brands.map((b) => CommonKeyValueModel(id: b.brandCode, value: b.name)).toList(),
  );

  _resetErrors(state);
}

void _resetErrors(_AddEditQuotationsScreenState state) => state.params.allParams().forEach((d) => d.resetError());

void _dispose(_AddEditQuotationsScreenState state) => state.params.allParams().forEach((d) => d.dispose());

Future<void> _onSaveTap(_AddEditQuotationsScreenState state) async {
  String errorMessage = '';

  QuotationCreateModel? quotationModel = _validate(state);
  state._refresh();
  if (quotationModel == null) return;

  bool confirmed = await _askConfirmationToAddOrEdit(state);
  if (!confirmed) return;

  await handleFutureWithAlert(
    errorMessage: () => errorMessage,
    progressbarWaitDuration: Duration.zero,
    function: () async {
      final response = state.widget.quotationsCode == null
          ? await QuotationsService.createQuotations(quotationModel)
          : await QuotationsService.updateQuotations(quotationModel);

      if (!response.responseType.success || response.data == null) {
        errorMessage = response.firstError();
        return Status.error;
      }
      return Status.success;
    },
    onSuccess: () {
      AppSnackBar.showSnackBarWithText(
        text: state.widget.quotationsCode == null ? 'new supply created successfully' : 'new supply updated successfully',
        duration: state.widget.quotationsCode == null ? const Duration(seconds: 6) : null,
      );
      AppNavigator.navigate(AppRoutes.quotationsList);
    },
  );
}

QuotationCreateModel? _validate(_AddEditQuotationsScreenState state) {
  _resetErrors(state);
  AddQuotationsParams param = state.params;

  bool isValid = Validator.validate([
    CustomValidators.typeValidator(
      field: 'Supplier',
      data: param.supplier.selected,
      error: param.supplier.error,
      types: [CommonKeyValueModel],
    ),
    CustomValidators.typeValidator(
      field: 'Organisation',
      data: param.organisation.selected,
      error: param.organisation.error,
      types: [CommonKeyValueModel],
    ),
    CustomValidators.typeValidator(
      field: 'Item',
      data: param.item.selected,
      error: param.item.error,
      types: [CommonKeyValueModel],
    ),
    CustomValidators.typeValidator(
      field: 'Brand',
      data: param.brand.selected,
      error: param.brand.error,
      types: [CommonKeyValueModel],
    ),
    CustomValidators.nameValidator(field: 'Description', data: param.description.text, error: param.description.error),
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

  final quantity = double.tryParse(param.quantity.text) ?? 0;
  final price = double.tryParse(param.price.text) ?? 0;
  final tax = double.tryParse(param.tax.text) ?? 0;
  final total = (quantity * price) + tax; // NOTE: assumed formula — confirm with backend/business logic

  return QuotationCreateModel(
    supplierId: param.supplier.selected!.id ?? '',
    itemId: param.item.selected!.id ?? '',
    organisationId: param.organisation.selected!.id,
    description: param.description.text,
    brand: param.brand.selected!.id, // NOTE: sends brandCode now, not free text
    quantity: quantity.toInt(),
    price: price,
    tax: tax,
    total: total,
    purchase: param.purchase.value ?? false,
    sales: param.sales.value ?? false,
  );
}

Future<void> _onCloseTap(_AddEditQuotationsScreenState state) async {
  bool confirmed = false;

  await showDoubleButtonAlert(
    DoubleButtonAlertModel(
      onRightTap: () => {confirmed = true, AppNavigator.pop()},
      content:
      'Are you sure you want to cancel ${state.widget.quotationsCode == null ? 'adding' : 'editing'} this quotation?',
    ),
    canClose: true,
  );

  if (!confirmed) return;

  AppNavigator.navigate(AppRoutes.quotationsList);
}

Future<bool> _askConfirmationToAddOrEdit(_AddEditQuotationsScreenState state) async {
  bool confirmed = false;

  await showDoubleButtonAlert(
    DoubleButtonAlertModel(
      onRightTap: () => {confirmed = true, AppNavigator.pop()},
      content: 'Are you sure you want to ${state.widget.quotationsCode == null ? 'create' : 'update'} this new supply?',
    ),
    canClose: true,
  );

  return confirmed;
}