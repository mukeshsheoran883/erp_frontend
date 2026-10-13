part of '../add_customer_screen.dart';

Future<void> _getCustomer(_AddEditCustomerScreenState state) async {
  _setInitialValues(state, null);
  state._refresh();

  final response = await Future.wait([
    if (state.widget.customerCode != null)
      CustomerService.getCustomer(customerCode: state.widget.customerCode!),
  ]);

  CustomerModel? customer;

  if (state.widget.customerCode != null) {
    ApiResponseModel<CustomerModel> customerResponse = response[0];
    if (!customerResponse.responseType.success ||
        customerResponse.data == null) {
      state.params.customer.setError(customerResponse.firstError());
      state.params.customer.setStatus(Status.error);
      state._refresh();
      return;
    }

    customer = customerResponse.data!;
  }

  await _setInitialValues(state, customer);
  state.params.customer.resetError();
  state.params.customer.setStatus(Status.success);
  state._refresh();
}

Future<void> _setInitialValues(
    _AddEditCustomerScreenState state, CustomerModel? customer) async {
  state.params.photo.reset(
    customer == null
        ? null
        : CustomImageModel(
      path: customer.photoUrl,
      name: FileUtils.getFileNameFromUrl(url: customer.photoUrl),
      bytes: null,
      size: 100000,
      extension: '',
      isLocalImage: false,
    ),
  );
  state.params.idProof.reset(
    customer == null
        ? null
        : CustomImageModel(
      path: customer.idProofUrl,
      name: FileUtils.getFileNameFromUrl(url: customer.idProofUrl),
      bytes: null,
      size: 100000,
      extension: '',
      isLocalImage: false,
    ),
  );
  state.params.customer.reset(customer);
  state.params.name.reset(customer?.name);
  state.params.email.reset(customer?.emailId);
  state.params.dateBirth.reset(customer?.dateOfBirth);
  state.params.phone.reset((
  countryCode: customer?.mobileNumberDailCode,
  phone: customer?.mobileNumber
  ));
  state.params.country.options = await Countries.loadCodesFromFile();
  state.params.country.reset(
    state.params.country.options.firstWhereOrNull((e) =>
    e.name.toLowerCase().trim() == customer?.country.toLowerCase().trim()),
  );
  state.params.unique.options = ValueNotifier([
    CommonKeyValueModel(id: 'Aadhaar', value: 'Aadhaar'),
  ]);
  state.params.gender.options = ValueNotifier<List<CommonKeyValueModel>>([
    CommonKeyValueModel(id: 'M', value: 'Male'),
    CommonKeyValueModel(id: 'F', value: 'Female'),
    CommonKeyValueModel(id: 'O', value: 'Other'),
  ]);
  state.params.unique.reset(state.params.unique.options.value.first);
  state.params.gender.reset(state.params.gender.options.value.first);
  state.params.uniqueNumber.reset(customer?.idNumber);
  state.params.occupation.reset(customer?.occupation);
  state.params.address.reset(customer?.street);
  state.params.education.reset(customer?.education);
  state.params.religion.reset(customer?.religion);
  state.params.bloodGroup.reset(customer?.bloodGroup);
  state.params.maritalStatus.reset(customer?.martialStatus);
  state.params.state.reset(
    state.params.country.selected?.states.firstWhereOrNull(
            (r) => r.toLowerCase().trim() == customer?.state.trim().toLowerCase()),
  );

  _resetErrors(state);
}

void _resetErrors(_AddEditCustomerScreenState state) =>
    state.params.allParams().forEach((d) => d.resetError());

void _dispose(_AddEditCustomerScreenState state) =>
    state.params.allParams().forEach((d) => d.dispose());

Future<void> _onSaveTap(_AddEditCustomerScreenState state) async {
  String errorMessage = '';
  CustomerModel? customerModel = _validate(state);
  state._refresh();
  if (customerModel == null) return;
  bool confirmed = await _askConfirmationToAddOrEdit(state);
  if (!confirmed) return;

  await handleFutureWithAlert(
    errorMessage: () => errorMessage,
    progressbarWaitDuration: Duration.zero,
    function: () async {
      customerModel.photoUrl = state.params.photo.file?.path ?? '';
      customerModel.idProofUrl = state.params.idProof.file?.path ?? '';

      if (state.params.photo.file != null &&
          state.params.photo.file!.isLocalImage) {
        CustomImageModel supplierImage = state.params.photo.file!;
        final fileUploadResponse = await CommonApiServices.fileUpload(
          model: FileUploadModel(
            bytes: supplierImage.bytes!,
            fileName:
            FileUtils.generateUniqueName(fileName: supplierImage.name),
            bucketKeys: BucketKeys.customerImage,
          ),
        );

        if (!fileUploadResponse.responseType.success ||
            fileUploadResponse.data == null) {
          errorMessage = fileUploadResponse.firstError();
          return Status.error;
        }

        customerModel.photoUrl = fileUploadResponse.data!.fileUrl;
      }

      if (state.params.idProof.file != null &&
          state.params.idProof.file!.isLocalImage) {
        CustomImageModel supplierIdImage = state.params.idProof.file!;
        final fileUploadResponse = await CommonApiServices.fileUpload(
          model: FileUploadModel(
            bytes: supplierIdImage.bytes!,
            fileName:
            FileUtils.generateUniqueName(fileName: supplierIdImage.name),
            bucketKeys: BucketKeys.idProof,
          ),
        );

        if (!fileUploadResponse.responseType.success ||
            fileUploadResponse.data == null) {
          errorMessage = fileUploadResponse.firstError();
          return Status.error;
        }

        customerModel.idProofUrl = fileUploadResponse.data!.fileUrl;
      }

      final createEmployeeResponse = state.widget.customerCode == null
          ? await CustomerService.createCustomer(customerModel)
          : await CustomerService.updateCustomer(customerModel);

      if (!createEmployeeResponse.responseType.success ||
          createEmployeeResponse.data == null) {
        errorMessage = createEmployeeResponse.firstError();
        return Status.error;
      }
      return Status.success;
    },
    onSuccess: () {
      AppSnackBar.showSnackBarWithText(
        text: state.widget.customerCode == null
            ? 'Customer created successfully. Please click the activation link sent to ${customerModel.emailId} to activate the account.'
            : 'Customer updated successfully',
        duration: state.widget.customerCode == null
            ? const Duration(seconds: 6)
            : null,
      );
      AppNavigator.navigate(AppRoutes.customersListing);
    },
  );
}

CustomerModel? _validate(_AddEditCustomerScreenState state) {
  _resetErrors(state);
  AddCustomerParams param = state.params;

  String name = param.name.text;
  String email = param.email.text;
  String phoneCountryCode = param.phone.code;
  String phoneNumber = param.phone.phone;
  CommonKeyValueModel? unique = param.unique.selected;
  CommonKeyValueModel? gender = param.gender.selected;
  String occupation = param.occupation.text;
  String education = param.education.text;
  String uniqueNumber = param.uniqueNumber.text;
  String religion = param.religion.text;
  String bloodGroup = param.bloodGroup.text;
  String maritalStatus = param.maritalStatus.text;
  DateTime? dateBirth = param.dateBirth.dateTime?.convertToDateAlone();
  Country? country = param.country.selected;
  String? selectedState = param.state.value;
  String address = param.address.text;

  FileSize? photo;
  FileSize? idImage;
  if (param.photo.file != null) {
    photo = FileSize(
        size: param.photo.file!.size.toDouble(), unit: FileSizeUnit.bytes);
  }
  if (param.idProof.file != null) {
    idImage = FileSize(
        size: param.idProof.file!.size.toDouble(), unit: FileSizeUnit.bytes);
  }

  bool isPersonalDetailsValid = Validator.validate([
    CustomValidators.fileSizeValidator(
      field: 'Image',
      size: photo,
      error: param.photo.error,
      required: false,
    ),
    CustomValidators.fileSizeValidator(
      field: 'Id Proof',
      size: idImage,
      error: param.idProof.error,
      required: false,
    ),
    CustomValidators.nameValidator(
        field: 'Name', data: name, error: param.name.error),
    CustomValidators.emailValidator(
        field: 'Email', email: email, error: param.email.error),
    CustomValidators.phoneValidator(
      field: 'Phone number',
      code: phoneCountryCode,
      phone: phoneNumber,
      error: param.phone.error,
    ),
    CustomValidators.typeValidator(
        field: 'Id',
        data: unique,
        types: [CommonKeyValueModel],
        error: param.unique.error),
    CustomValidators.typeValidator(
        field: 'Gender',
        data: unique,
        types: [CommonKeyValueModel],
        error: param.gender.error),
    CustomValidators.nameValidator(
        field: 'Unique Number',
        data: uniqueNumber,
        error: param.uniqueNumber.error),
    CustomValidators.nameValidator(
        field: 'Occupation', data: occupation, error: param.occupation.error),
    CustomValidators.nameValidator(
      field: 'Education',
      data: education,
      error: param.education.error,
    ),
    CustomValidators.nameValidator(
      field: 'Religion',
      data: religion,
      error: param.religion.error,
    ),
    CustomValidators.nameValidator(
      field: 'Blood Group',
      data: bloodGroup,
      error: param.bloodGroup.error,
    ),
    CustomValidators.nameValidator(
      field: 'Marital Status',
      data: maritalStatus,
      error: param.maritalStatus.error,
    ),
    CustomValidators.dateValidator(
      field: 'Date of Birth',
      date: dateBirth,
      maxDate: DateTime.now(),
      error: param.dateBirth.error,
    ),
    CustomValidators.countryValidator(
        field: 'Country', country: country, error: param.country.error),
    CustomValidators.stateValidator(
      field: 'State or province',
      state: selectedState,
      country: country,
      error: param.state.error,
    ),
    CustomValidators.addressValidator(
        field: 'Address', data: address, error: param.address.error),
  ]);

  if (!isPersonalDetailsValid) return null;

  CustomerModel customerModel = CustomerModel(
    name: name,
    mobileNumber: phoneNumber,
    mobileNumberDailCode: phoneCountryCode,
    dateOfBirth: dateBirth!,
    emailId: email,
    gender: param.gender.options.value.first.id,
    martialStatus: maritalStatus,
    state: selectedState!,
    religion: religion,
    country: country!.name,
    bloodGroup: bloodGroup,
    education: education,
    street: address,
    photoUrl: state.params.customer.value?.photoUrl ?? '',
    idProofUrl: state.params.customer.value?.idProofUrl ?? '',
    customerCode: state.widget.customerCode ?? '',
    idNumber: uniqueNumber,
    disabled: false,
    idType: param.unique.options.value.first.id,
    selected: false,
    occupation: occupation,
    createdDateTime: DateTime.now(),
    organisationName: '',
  );
  return customerModel;
}

Future<void> _onCloseTap(_AddEditCustomerScreenState state) async {
  bool confirmed = false;

  await showDoubleButtonAlert(
    DoubleButtonAlertModel(
      onRightTap: () => {confirmed = true, AppNavigator.pop()},
      content:
      'Are you sure you want to cancel ${state.widget.customerCode == null ? 'adding' : 'editing'} this branch?',
    ),
    canClose: true,
  );

  if (!confirmed) return;

  AppNavigator.navigate(AppRoutes.branchListing);
}

Future<bool> _askConfirmationToAddOrEdit(
    _AddEditCustomerScreenState state) async {
  bool confirmed = false;

  await showDoubleButtonAlert(
    DoubleButtonAlertModel(
      onRightTap: () => {confirmed = true, AppNavigator.pop()},
      content:
      'Are you sure you want to ${state.widget.customerCode == null ? 'create' : 'update'} this customer?',
    ),
    canClose: true,
  );

  return confirmed;
}