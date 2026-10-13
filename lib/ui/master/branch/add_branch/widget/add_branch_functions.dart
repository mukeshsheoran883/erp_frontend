part of '../add_branch_screen.dart';

Future<void> _getBranch(_AddEditBranchScreenState state) async {
  _setInitialValues(state, null);
  state._refresh();
  final response = await Future.wait([
    if (state.widget.shopCode != null) BranchService.getBranch(branchCode: state.widget.shopCode!),
  ]);
  BranchModel? editBranch;
  if (state.widget.shopCode != null) {
    ApiResponseModel<BranchModel> branchResponse = response[0];
    if (!branchResponse.responseType.success || branchResponse.data == null) {
      state.params.branch.setError(branchResponse.firstError());
      state.params.branch.setStatus(Status.error);
      state._refresh();
      return;
    }

    editBranch = branchResponse.data!;
  }
  await _setInitialValues(state, editBranch);
  state.params.branch.resetError();
  state.params.branch.setStatus(Status.success);
  state._refresh();
}

Future<void> _setInitialValues(_AddEditBranchScreenState state, BranchModel? branch) async {
  state.params.branch.reset(branch);
  state.params.name.reset(branch?.name);
  state.params.email.reset(branch?.emailId);
  state.params.phone.reset((countryCode: branch?.mobileNumberDailCode, phone: branch?.mobileNumber));
  state.params.altPhone.reset((countryCode: branch?.altMobileNumberDailCode, phone: branch?.altMobileNumber));
  state.params.country.options = await Countries.loadCodesFromFile();
  state.params.country.reset(
    state.params.country.options
        .firstWhereOrNull((e) => e.name.toLowerCase().trim() == branch?.country.toLowerCase().trim()),
  );
  state.params.state.reset(
    state.params.country.selected?.states
        .firstWhereOrNull((r) => r.toLowerCase().trim() == branch?.state.trim().toLowerCase()),
  );
  state.params.buildingStreet.reset(branch?.street);
  state.params.website.reset(branch?.website);

  state.params.type.options = ValueNotifier([
    CommonKeyValueModel(id: 'branch', value: 'Branch'),
    CommonKeyValueModel(id: 'warehouse', value: 'Warehouse'),
  ]);

  state.params.type.reset(
    branch == null
        ? state.params.type.options.value.first
        : branch.type == 'branch'
            ? state.params.type.options.value.first
            : state.params.type.options.value.last,
  );
}

void _resetErrors(_AddEditBranchScreenState state) => state.params.allParams().forEach((d) => d.resetError());

void _dispose(_AddEditBranchScreenState state) => state.params.allParams().forEach((d) => d.dispose());

Future<void> _onSaveTap(_AddEditBranchScreenState state) async {
  String errorMessage = '';

  BranchModel? branchModel = _validate(state);
  state._refresh();
  if (branchModel == null) return;

  bool confirmed = await _askConfirmationToAddOrEdit(state);
  if (!confirmed) return;

  await handleFutureWithAlert(
    errorMessage: () => errorMessage,
    progressbarWaitDuration: Duration.zero,
    function: () async {
      final createBranchResponse = state.widget.shopCode == null
          ? await BranchService.createBranch(branchModel)
          : await BranchService.updateBranch(branchModel);

      if (!createBranchResponse.responseType.success || createBranchResponse.data == null) {
        errorMessage = createBranchResponse.firstError();
        return Status.error;
      }
      return Status.success;
    },
    onSuccess: () {
      AppSnackBar.showSnackBarWithText(
        text: state.widget.shopCode == null ? 'Branch created successfully' : 'Branch updated successfully',
        duration: state.widget.shopCode == null ? const Duration(seconds: 6) : null,
      );
      AppNavigator.navigate(AppRoutes.branchListing);
    },
  );
}

BranchModel? _validate(_AddEditBranchScreenState state) {
  _resetErrors(state);
  AddBranchParams param = state.params;
  String name = param.name.text;
  String email = param.email.text;
  CommonKeyValueModel? type = param.type.selected;
  String phoneCountryCode = param.phone.code;
  String phoneNumber = param.phone.phone;
  String altPhoneCountryCode = param.altPhone.code;
  String altPhoneNumber = param.altPhone.phone;
  Country? country = param.country.selected;
  String? selectedState = param.state.value;

  String buildingStreet = param.buildingStreet.text;
  String website = param.website.text;

  bool isValid = Validator.validate([
    CustomValidators.nameValidator(field: 'Name', data: name, error: param.name.error),
    CustomValidators.emailValidator(field: 'Email', email: email, error: param.email.error),
    CustomValidators.phoneValidator(
      field: 'Phone number',
      code: phoneCountryCode,
      phone: phoneNumber,
      error: param.phone.error,
    ),
    CustomValidators.phoneValidator(
      field: 'Alternate phone number',
      code: altPhoneCountryCode,
      phone: altPhoneNumber,
      error: param.altPhone.error,
      required: false,
    ),
    CustomValidators.countryValidator(field: 'Country', country: country, error: param.country.error),
    CustomValidators.stateValidator(
      field: 'State or province',
      state: selectedState,
      country: country,
      error: param.state.error,
    ),
    CustomValidators.addressValidator(
      field: 'Building number and street number',
      data: buildingStreet,
      error: param.buildingStreet.error,
    ),
    CustomValidators.urlValidator(field: 'Website URL', url: website, error: param.website.error, required: false),
    CustomValidators.typeValidator(
      field: 'Branch Type',
      data: type,
      error: param.type.error,
      types: [CommonKeyValueModel],
    ),
  ]);

  if (!isValid) return null;

  BranchModel branchModel = BranchModel(
    name: name,
    mobileNumber: phoneNumber,
    createdDateTime: DateTime.now(),
    emailId: email,
    state: param.state.value!,
    country: state.params.country.selected!.name,
    street: buildingStreet,
    isActiveChangeTime: '',
    organisationName: '',
    shopCode: state.widget.shopCode ?? '',
    disabled: false,
    selected: false,
    type: type!.id,
    website: website,
    altMobileNumber: altPhoneNumber,
    mobileNumberDailCode: phoneCountryCode,
    altMobileNumberDailCode: altPhoneCountryCode,
  );
  return branchModel;
}

Future<void> _onCloseTap(_AddEditBranchScreenState state) async {
  bool confirmed = false;

  await showDoubleButtonAlert(
    DoubleButtonAlertModel(
      onRightTap: () => {confirmed = true, AppNavigator.pop()},
      content: 'Are you sure you want to cancel ${state.widget.shopCode == null ? 'adding' : 'editing'} this branch?',
    ),
    canClose: true,
  );

  if (!confirmed) return;

  AppNavigator.navigate(AppRoutes.branchListing);
}

Future<bool> _askConfirmationToAddOrEdit(_AddEditBranchScreenState state) async {
  bool confirmed = false;

  await showDoubleButtonAlert(
    DoubleButtonAlertModel(
      onRightTap: () => {confirmed = true, AppNavigator.pop()},
      content: 'Are you sure you want to ${state.widget.shopCode == null ? 'create' : 'update'} this branch?',
    ),
    canClose: true,
  );

  return confirmed;
}
