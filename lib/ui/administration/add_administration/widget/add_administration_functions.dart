part of '../add_administration_screen.dart';

Future<void> _getAdministration(_AddEditAdministrationScreenState state) async {
  await _setInitialValues(state, null);
  state._refresh();
  final response = await Future.wait([
    if (state.widget.administrationCode != null)
      AdministrationService.getOrganization(organizationName: state.widget.administrationCode!),
  ]);

  AdministrationModel? editOrganization;

  if (state.widget.administrationCode != null) {
    ApiResponseModel<AdministrationModel> organizationResponse = response[0];
    if (!organizationResponse.responseType.success || organizationResponse.data == null) {
      state.params.organization.setError(organizationResponse.firstError());
      state.params.organization.setStatus(Status.error);
      state._refresh();
      return;
    }

    editOrganization = organizationResponse.data!;
  }

  await _setInitialValues(state, editOrganization);
  state.params.organization.resetError();
  state.params.organization.setStatus(Status.success);
  state._refresh();
}

Future<void> _setInitialValues(_AddEditAdministrationScreenState state, AdministrationModel? organization) async {
  state.params.organization.reset(organization);
  state.params.image.reset(
    (organization == null || organization.imageUrl.trim().isEmpty)
        ? null
        : CustomImageModel(
            path: organization.imageUrl,
            name: FileUtils.getFileNameFromUrl(url: organization.imageUrl),
            bytes: null,
            size: 100000,
            extension: '',
            isLocalImage: false,
          ),
  );
  state.params.name.reset(organization?.name);
  state.params.contactPersonName.reset(organization?.contactPersonName);
  state.params.contactEmailId.reset(organization?.email);

  state.params.phone.reset((countryCode: organization?.mobileNumberDailCode, phone: organization?.mobileNumber));
  state.params.altPhone
      .reset((countryCode: organization?.altMobileNumberDailCode, phone: organization?.altMobileNumber));
  state.params.plan.options = ValueNotifier([
    OrganizationPlanModel.basic(),
    OrganizationPlanModel.diamond(),
    OrganizationPlanModel.platinum(),
    OrganizationPlanModel.custom(),
  ]);
  state.params.plan.reset(
    organization == null
        ? state.params.plan.options.value.first
        : OrganizationPlanModel.fromString(
            planId: organization.plan,
            userCount: organization.employeeCount,
            branchCount: organization.shopCount,
          ),
  );

  state.params.branchCount.reset(state.params.plan.selected?.branchCount.toString());
  state.params.userCount.reset(state.params.plan.selected?.branchCount.toString());
  state.params.expiryDate.reset(organization?.planExpiry);
  state.params.paymentGateway.reset(organization?.paymentGateway ?? false);
  state.params.approval.reset(organization?.approval ?? false);
}

void _resetErrors(_AddEditAdministrationScreenState state) => state.params.allParams().forEach((d) => d.resetError());

void _dispose(_AddEditAdministrationScreenState state) => state.params.allParams().forEach((d) => d.dispose());

Future<void> _onSaveTap(_AddEditAdministrationScreenState state) async {
  String errorMessage = '';
  AdministrationModel? organizationModel = _validate(state);
  state._refresh();
  if (organizationModel == null) return;

  bool confirmed = await _askConfirmationToAddOrEdit(state);
  if (!confirmed) return;

  await handleFutureWithAlert(
    errorMessage: () => errorMessage,
    progressbarWaitDuration: Duration.zero,
    function: () async {
      organizationModel.imageUrl = state.params.image.file?.path ?? '';

      /// --------------------------------- Upload Profile Image if it is a New File --------------------------------
      if (state.params.image.file != null && state.params.image.file!.isLocalImage) {
        CustomImageModel administrationImage = state.params.image.file!;
        final fileUploadResponse = await CommonApiServices.fileUpload(
          model: FileUploadModel(
            bytes: administrationImage.bytes!,
            fileName: FileUtils.generateUniqueName(fileName: administrationImage.name),
            bucketKeys: BucketKeys.organizationImage,
          ),
        );

        if (!fileUploadResponse.responseType.success || fileUploadResponse.data == null) {
          errorMessage = fileUploadResponse.firstError();
          return Status.error;
        }

        organizationModel.imageUrl = fileUploadResponse.data!.fileUrl;
      }

      /// ------------------------- Calling Create Employee API ------------------------------------

      final createOrganizationResponse = state.widget.administrationCode == null
          ? await AdministrationService.createOrganization(organizationModel)
          : await AdministrationService.updateOrganization(organizationModel);

      if (!createOrganizationResponse.responseType.success || createOrganizationResponse.data == null) {
        errorMessage = createOrganizationResponse.firstError();
        return Status.error;
      }

      return Status.success;
    },
    onSuccess: () {
      AppSnackBar.showSnackBarWithText(
        text: state.widget.administrationCode == null
            ? 'Organization created successfully.'
            : 'Organization updated successfully',
        duration: state.widget.administrationCode == null ? const Duration(seconds: 6) : null,
      );
      AppNavigator.navigate(AppRoutes.administrationListing);
    },
  );
}

Future<void> _onCloseTap(_AddEditAdministrationScreenState state) async {
  bool confirmed = false;

  await showDoubleButtonAlert(
    DoubleButtonAlertModel(
      onRightTap: () => {confirmed = true, AppNavigator.pop()},
      content:
          'Are you sure you want to cancel ${state.widget.administrationCode == null ? 'adding' : 'editing'} this organization?',
    ),
    canClose: true,
  );

  if (!confirmed) return;

  AppNavigator.navigate(AppRoutes.employeeListing);
}

AdministrationModel? _validate(_AddEditAdministrationScreenState state) {
  _resetErrors(state);
  AddAdministrationParams param = state.params;
  String name = param.name.text;
  String contactPersonName = param.contactPersonName.text;
  String contactEmailId = param.contactEmailId.text;
  String branchCount = param.branchCount.text;
  String userCount = param.userCount.text;
  String phoneCountryCode = param.phone.code;
  String phoneNumber = param.phone.phone;
  String altPhoneCountryCode = param.altPhone.code;
  String altPhoneNumber = param.altPhone.phone;
  CommonKeyValueModel? plan = param.plan.selected;
  DateTime? expiryDate = param.expiryDate.dateTime?.convertToDateAlone();
  FileSize? fileSize;
  if (param.image.file != null) {
    fileSize = FileSize(size: param.image.file!.size.toDouble(), unit: FileSizeUnit.bytes);
  }

  bool isValid = Validator.validate([
    CustomValidators.fileSizeValidator(field: 'Id proof image', size: fileSize, error: param.image.error),
    CustomValidators.nameValidator(field: 'Company name', data: name, error: state.params.name.error),
    CustomValidators.nameValidator(
      field: 'Contact person Name',
      data: contactPersonName,
      error: state.params.contactPersonName.error,
    ),
    CustomValidators.emailValidator(
      field: 'Contact email ID',
      email: contactEmailId,
      error: state.params.contactEmailId.error,
    ),
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
    CustomValidators.typeValidator(
      field: 'Plan',
      data: plan,
      error: param.plan.error,
      types: [OrganizationPlanModel],
    ),
    CustomValidators.nameValidator(field: 'Branch count', data: branchCount, error: state.params.branchCount.error),
    CustomValidators.nameValidator(field: 'User count ', data: userCount, error: state.params.userCount.error),
    CustomValidators.dateValidator(
      field: 'Expiry date',
      date: expiryDate,
      maxDate: expiryDate?.add(const Duration(days: 1)),
      error: param.expiryDate.error,
    ),
  ]);

  if (!isValid) return null;
  AdministrationModel administrationModel = AdministrationModel(
    organisationId: '',
    createdDateTime: expiryDate!,
    state: branchCount,
    country: branchCount,
    street: branchCount,
    disabled: false,
    selected: false,
    name: name,
    shopCount: int.parse(branchCount),
    employeeCount: int.parse(userCount),
    imageUrl: state.params.organization.value?.imageUrl ?? '',
    contactPersonName: contactPersonName,
    email: contactEmailId,
    mobileNumberDailCode: phoneCountryCode,
    mobileNumber: phoneNumber,
    altMobileNumberDailCode: altPhoneCountryCode,
    altMobileNumber: altPhoneNumber,
    planExpiry: expiryDate,
    paymentGateway: param.paymentGateway.value!,
    approval: param.approval.value!,
    plan: plan!.value,
  );
  return administrationModel;
}

Future<bool> _askConfirmationToAddOrEdit(_AddEditAdministrationScreenState state) async {
  bool confirmed = false;

  await showDoubleButtonAlert(
    DoubleButtonAlertModel(
      onRightTap: () => {confirmed = true, AppNavigator.pop()},
      content:
          'Are you sure you want to ${state.widget.administrationCode == null ? 'create' : 'update'} this organization?',
    ),
    canClose: true,
  );

  return confirmed;
}
