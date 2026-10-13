
part of 'add_employee_screen.dart';

Future<void> _getEmployee(_AddEditEmployeeScreenState state) async {
  _setInitialValues(state, [], null);
  state._refresh();
  final response = await Future.wait([
    ShopService.getShopList(pagination: false),
    if (state.widget.employeeCode != null)
      CommonApiServices.getCurrentUserDetails(employeeCode: state.widget.employeeCode),
  ]);

  ApiResponseModel<List<ShopModel>> shopResponse = response[0] as ApiResponseModel<List<ShopModel>>;

  UserModel? editUser;

  if (state.widget.employeeCode != null) {
    ApiResponseModel<UserModel> employeeResponse = response[1] as ApiResponseModel<UserModel>;
    if (!employeeResponse.responseType.success || employeeResponse.data == null) {
      state.params.employee.setError(employeeResponse.firstError());
      state.params.employee.setStatus(Status.error);
      state._refresh();
      return;
    }

    editUser = employeeResponse.data!;
  }

  if (!shopResponse.responseType.success || shopResponse.data == null) {
    state.params.employee.setError(shopResponse.firstError());
    state.params.employee.setStatus(Status.error);
    state._refresh();
    return;
  }

  await _setInitialValues(state, shopResponse.data!, editUser);
  state.params.employee.resetError();
  state.params.employee.setStatus(Status.success);
  state._refresh();
}

Future<void> _setInitialValues(_AddEditEmployeeScreenState state, List<ShopModel> shops, UserModel? employee) async {
  state.params.employee.reset(employee);
  state.params.image.reset(
    (employee == null || employee.profilePhotoUrl.trim().isEmpty)
        ? null
        : CustomImageModel(
            path: employee.profilePhotoUrl,
            name: FileUtils.getFileNameFromUrl(url: employee.profilePhotoUrl),
            bytes: null,
            size: 100000,
            extension: '',
            isLocalImage: false,
          ),
  );
  state.params.name.reset(employee?.name);
  state.params.email.reset(employee?.emailId);
  state.params.dateOfBirth.reset(employee?.dob);
  state.params.status.options = ValueNotifier([
    CommonKeyValueModel(id: 'Active', value: 'Active'),
    CommonKeyValueModel(id: 'Disabled', value: 'Inactive'),
  ]);

  state.params.status.reset(
    employee == null
        ? state.params.status.options.value.last
        : employee.disabled
            ? state.params.status.options.value.last
            : state.params.status.options.value.first,
  );

  state.params.phone.reset((countryCode: employee?.mobileNumberDailCode, phone: employee?.mobileNumber));
  state.params.altPhone.reset((countryCode: employee?.altMobileNumberDailCode, phone: employee?.altMobileNumber));
  state.params.country.options = await Countries.loadCodesFromFile();
  state.params.country.reset(
    state.params.country.options
        .firstWhereOrNull((e) => e.name.toLowerCase().trim() == employee?.country.toLowerCase().trim()),
  );
  state.params.state.reset(
    state.params.country.selected?.states
        .firstWhereOrNull((r) => r.toLowerCase().trim() == employee?.state.trim().toLowerCase()),
  );
  state.params.address.reset(employee?.address);
  state.params.shop.reset(employee?.shopAccess ?? []);
  state.params.shop.options =
      shops.map((e) => CommonKeyValueModel(id: e.shopCode, value: e.name.toPascalCase())).toList();
  state.params.permission.reset(employee?.permissions ?? EmployeePermission());
  state.params.openedGroup = null;
}

void _resetErrors(_AddEditEmployeeScreenState state) => state.params.allParams().forEach((d) => d.resetError());

void _dispose(_AddEditEmployeeScreenState state) => state.params.allParams().forEach((d) => d.dispose());

Future<void> _onSaveTap(_AddEditEmployeeScreenState state) async {
  String errorMessage = '';

  UserModel? userModel = _validate(state);
  state._refresh();
  if (userModel == null) return;

  bool confirmed = await _askConfirmationToAddOrEdit(state);
  if (!confirmed) return;

  await handleFutureWithAlert(
    errorMessage: () => errorMessage,
    progressbarWaitDuration: Duration.zero,
    function: () async {
      userModel.profilePhotoUrl = state.params.image.file?.path ?? '';

      /// --------------------------------- Upload Profile Image if it is a New File --------------------------------
      if (state.params.image.file != null && state.params.image.file!.isLocalImage) {
        CustomImageModel employeeImage = state.params.image.file!;
        final fileUploadResponse = await CommonApiServices.fileUpload(
          model: FileUploadModel(
            bytes: employeeImage.bytes!,
            fileName: FileUtils.generateUniqueName(fileName: employeeImage.name),
            bucketKeys: BucketKeys.employeeImage,
          ),
        );

        if (!fileUploadResponse.responseType.success || fileUploadResponse.data == null) {
          errorMessage = fileUploadResponse.firstError();
          return Status.error;
        }

        userModel.profilePhotoUrl = fileUploadResponse.data!.fileUrl;
      }

      /// ------------------------- Calling Create Employee API ------------------------------------

      final createEmployeeResponse = state.widget.employeeCode == null
          ? await EmployeeService.createEmployee(userModel)
          : await EmployeeService.updateEmployee(userModel);

      if (!createEmployeeResponse.responseType.success || createEmployeeResponse.data == null) {
        errorMessage = createEmployeeResponse.firstError();
        return Status.error;
      }

      return Status.success;
    },
    onSuccess: () {
      AppSnackBar.showSnackBarWithText(
        text: state.widget.employeeCode == null
            ? 'Employee created successfully. Please click the activation link sent to ${userModel.emailId} to activate the account.'
            : 'Employee updated successfully',
        duration: state.widget.employeeCode == null ? const Duration(seconds: 6) : null,
      );
      AppNavigator.navigate(AppRoutes.employeeListing);
    },
  );
}

UserModel? _validate(_AddEditEmployeeScreenState state) {
  _resetErrors(state);
  AddEmployeeParams param = state.params;

  String name = param.name.text;
  String email = param.email.text;
  DateTime? dateOfBirth = param.dateOfBirth.dateTime?.convertToDateAlone();
  CommonKeyValueModel? employeeStatus = param.status.selected;
  String phoneCountryCode = param.phone.code;
  String phoneNumber = param.phone.phone;
  String altPhoneCountryCode = param.altPhone.code;
  String altPhoneNumber = param.altPhone.phone;
  Country? country = param.country.selected;
  String? selectedState = param.state.value;
  String address = param.address.text;

  FileSize? fileSize;
  if (param.image.file != null) {
    fileSize = FileSize(size: param.image.file!.size.toDouble(), unit: FileSizeUnit.bytes);
  }

  bool isPersonalDetailsValid = Validator.validate([
    CustomValidators.fileSizeValidator(
      field: 'Employee image',
      required: false,
      size: fileSize,
      error: param.image.error,
    ),
    CustomValidators.nameValidator(field: 'Employee name', data: name, error: param.name.error),
    CustomValidators.emailValidator(field: 'Employee email', email: email, error: param.email.error),
    CustomValidators.dateValidator(
      field: 'Date of birth',
      date: dateOfBirth,
      maxDate: DateTime.now(),
      error: param.dateOfBirth.error,
    ),
    CustomValidators.typeValidator(
      field: 'Employee status',
      data: employeeStatus,
      error: param.status.error,
      types: [CommonKeyValueModel],
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
    CustomValidators.countryValidator(field: 'Country', country: country, error: param.country.error),
    CustomValidators.stateValidator(
      field: 'State or province',
      state: selectedState,
      country: country,
      error: param.state.error,
    ),
    CustomValidators.addressValidator(field: 'Address', data: address, error: param.address.error),
  ]);

  bool isShopAccessValid = Validator.validate([
    ValidationModel(
      fieldName: 'Shop access',
      data: param.shop.selected,
      validators: [
        FastMinLengthValidation(
          minLength: 1,
          customMessage: 'At least access to one shop must be granted for an employee',
        ),
      ],
      error: param.shop.error,
    ),
  ]);

  bool isPermissionValid = Validator.validate([
    ValidationModel(
      fieldName: 'Permission',
      data: param.permission.value.isAnyOnePermissionGranted(),
      validators: [
        FastExactValueValidation(value: true, customMessage: 'At least one permission must be granted to an employee'),
      ],
      error: state.params.permission.error,
    ),
  ]);

  if (state.tabController != null) {
    if (!isPersonalDetailsValid) {
      state.tabController!.animateTo(0);
    } else if (!isShopAccessValid) {
      state.tabController!.animateTo(1);
    } else if (!isPermissionValid) {
      state.tabController!.animateTo(2);
    }
  }

  if (!isPersonalDetailsValid || !isShopAccessValid || !isPermissionValid) return null;

  UserModel employeeModel = UserModel(
    name: name,
    mobileNumber: phoneNumber,
    mobileNumberDailCode: phoneCountryCode,
    altMobileNumber: altPhoneNumber,
    altMobileNumberDailCode: altPhoneCountryCode,
    isActive: employeeStatus!.id == param.status.options.value.first.id,
    dob: dateOfBirth!,
    shopAccess: param.shop.selected,
    emailId: email,
    state: param.state.value!,
    country: state.params.country.selected!.name,
    address: address,
    profilePhotoUrl: state.params.employee.value?.profilePhotoUrl ?? '',
    organisationName: state.params.employee.value?.organisationName ?? '',
    emailVerified: state.params.employee.value?.emailVerified ?? false,
    employeeCode: state.params.employee.value?.employeeCode ?? '',
    disabled: state.params.employee.value?.isActive == true ? false : true,
    selected: false,
    permissions: param.permission.value,
    defaultShop: state.params.employee.value?.defaultShop ?? CommonKeyValueModel(id: '', value: ''),
  );

  return employeeModel;
}

Future<void> _onCloseTap(_AddEditEmployeeScreenState state) async {
  bool confirmed = false;

  await showDoubleButtonAlert(
    DoubleButtonAlertModel(
      onRightTap: () => {confirmed = true, AppNavigator.pop()},
      content:
          'Are you sure you want to cancel ${state.widget.employeeCode == null ? 'adding' : 'editing'} this employee?',
    ),
    canClose: true,
  );

  if (!confirmed) return;

  AppNavigator.navigate(AppRoutes.employeeListing);
}

Future<bool> _askConfirmationToAddOrEdit(_AddEditEmployeeScreenState state) async {
  bool confirmed = false;

  await showDoubleButtonAlert(
    DoubleButtonAlertModel(
      onRightTap: () => {confirmed = true, AppNavigator.pop()},
      content: 'Are you sure you want to ${state.widget.employeeCode == null ? 'create' : 'update'} this employee?',
    ),
    canClose: true,
  );

  return confirmed;
}
