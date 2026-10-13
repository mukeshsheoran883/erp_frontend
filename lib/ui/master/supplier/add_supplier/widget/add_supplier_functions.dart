part of '../add_supplier_screen.dart';

Future<void> _getSupplier(_AddEditSupplierScreenState state) async {
  _setInitialValues(state, null);
  state._refresh();
  final response = await Future.wait([
    if (state.widget.supplierCode != null) SupplierService.getSupplier(suppliersCode: state.widget.supplierCode!),
  ]);

  SupplierModel? editSupplier;

  if (state.widget.supplierCode != null) {
    ApiResponseModel<SupplierModel> supplierResponse = response[0];
    if (!supplierResponse.responseType.success || supplierResponse.data == null) {
      state.params.supplier.setError(supplierResponse.firstError());
      state.params.supplier.setStatus(Status.error);
      state._refresh();
      return;
    }

    editSupplier = supplierResponse.data!;
  }

  await _setInitialValues(state, editSupplier);
  state.params.supplier.resetError();
  state.params.supplier.setStatus(Status.success);
  state._refresh();
}

Future<void> _setInitialValues(_AddEditSupplierScreenState state, SupplierModel? supplier) async {
  state.params.supplier.reset(supplier);
  state.params.image.reset(
    supplier == null
        ? null
        : CustomImageModel(
            path: supplier.profilePhotoUrl,
            name: FileUtils.getFileNameFromUrl(url: supplier.profilePhotoUrl),
            bytes: null,
            size: 100000,
            extension: '',
            isLocalImage: false,
          ),
  );
  state.params.idImage.reset(
    supplier == null
        ? null
        : CustomImageModel(
            path: supplier.idProofUrl,
            name: FileUtils.getFileNameFromUrl(url: supplier.idProofUrl),
            bytes: null,
            size: 100000,
            extension: '',
            isLocalImage: false,
          ),
  );

  state.params.name.reset(supplier?.name);
  state.params.gstNumber.reset(supplier?.gstNumber);
  state.params.idNumber.reset(supplier?.idNumber);
  state.params.email.reset(supplier?.emailId);
  state.params.id.options = ValueNotifier([
    CommonKeyValueModel(id: 'aadhar', value: 'aadhar'),
  ]);
  state.params.id.reset(state.params.id.options.value.last);
  state.params.phone.reset((countryCode: supplier?.mobileNumberDailCode, phone: supplier?.mobileNumber));
  state.params.altPhone.reset((countryCode: supplier?.altMobileNumberDailCode, phone: supplier?.altMobileNumber));
  state.params.country.options = await Countries.loadCodesFromFile();
  state.params.country.reset(
    state.params.country.options
        .firstWhereOrNull((e) => e.name.toLowerCase().trim() == supplier?.country.toLowerCase().trim()),
  );
  state.params.state.reset(
    state.params.country.selected?.states
        .firstWhereOrNull((r) => r.toLowerCase().trim() == supplier?.state.trim().toLowerCase()),
  );
  state.params.address.reset(supplier?.address);
  _resetErrors(state);
}

void _resetErrors(_AddEditSupplierScreenState state) => state.params.allParams().forEach((d) => d.resetError());

void _dispose(_AddEditSupplierScreenState state) => state.params.allParams().forEach((d) => d.dispose());

Future<void> _onSaveTap(_AddEditSupplierScreenState state) async {
  String errorMessage = '';

  SupplierModel? supplierModel = _validate(state);
  state._refresh();
  if (supplierModel == null) return;

  bool confirmed = await _askConfirmationToAddOrEdit(state);
  if (!confirmed) return;

  await handleFutureWithAlert(
    errorMessage: () => errorMessage,
    progressbarWaitDuration: Duration.zero,
    function: () async {
      supplierModel.profilePhotoUrl = state.params.image.file?.path ?? '';
      supplierModel.idProofUrl = state.params.idImage.file?.path ?? '';

      /// --------------------------------- Upload Profile Image if it is a New File --------------------------------
      if (state.params.image.file != null && state.params.image.file!.isLocalImage) {
        CustomImageModel supplierImage = state.params.image.file!;
        final fileUploadResponse = await CommonApiServices.fileUpload(
          model: FileUploadModel(
            bytes: supplierImage.bytes!,
            fileName: FileUtils.generateUniqueName(fileName: supplierImage.name),
            bucketKeys: BucketKeys.employeeImage,
          ),
        );

        if (!fileUploadResponse.responseType.success || fileUploadResponse.data == null) {
          errorMessage = fileUploadResponse.firstError();
          return Status.error;
        }

        supplierModel.profilePhotoUrl = fileUploadResponse.data!.fileUrl;
      }

      /// --------------------------------- Upload Profile Image if it is a New File --------------------------------
      if (state.params.idImage.file != null && state.params.idImage.file!.isLocalImage) {
        CustomImageModel supplierIdImage = state.params.idImage.file!;
        final fileUploadResponse = await CommonApiServices.fileUpload(
          model: FileUploadModel(
            bytes: supplierIdImage.bytes!,
            fileName: FileUtils.generateUniqueName(fileName: supplierIdImage.name),
            bucketKeys: BucketKeys.employeeImage,
          ),
        );

        if (!fileUploadResponse.responseType.success || fileUploadResponse.data == null) {
          errorMessage = fileUploadResponse.firstError();
          return Status.error;
        }

        supplierModel.idProofUrl = fileUploadResponse.data!.fileUrl;
      }

      final createSupplierResponse = state.widget.supplierCode == null
          ? await SupplierService.createSupplier(supplierModel)
          : await SupplierService.updateSupplier(supplierModel);

      if (!createSupplierResponse.responseType.success || createSupplierResponse.data == null) {
        errorMessage = createSupplierResponse.firstError();
        return Status.error;
      }

      return Status.success;
    },
    onSuccess: () {
      AppSnackBar.showSnackBarWithText(text: 'Supplier created successfully');
      AppNavigator.navigate(AppRoutes.suppliersListing);
    },
  );
}

SupplierModel? _validate(_AddEditSupplierScreenState state) {
  _resetErrors(state);
  AddSupplierParams param = state.params;

  String name = param.name.text;
  String email = param.email.text;
  CommonKeyValueModel? id = param.id.selected;
  String phoneCountryCode = param.phone.code;
  String phoneNumber = param.phone.phone;
  String altPhoneCountryCode = param.altPhone.code;
  String altPhoneNumber = param.altPhone.phone;
  Country? country = param.country.selected;
  String? selectedState = param.state.value;
  String address = param.address.text;
  String idNumber = param.idNumber.text;
  String gstNumber = param.gstNumber.text;
  FileSize? supplierImage;
  FileSize? supplierIdImage;
  if (param.image.file != null) {
    supplierImage = FileSize(size: param.image.file!.size.toDouble(), unit: FileSizeUnit.bytes);
  }
  if (param.idImage.file != null) {
    supplierIdImage = FileSize(size: param.idImage.file!.size.toDouble(), unit: FileSizeUnit.bytes);
  }

  bool isValid = Validator.validate([
    CustomValidators.fileSizeValidator(
      field: 'Supplier image',
      size: supplierImage,
      error: param.image.error,
      required: false,
    ),
    CustomValidators.fileSizeValidator(
      field: 'Id Proof',
      size: supplierIdImage,
      error: param.idImage.error,
      required: false,
    ),
    CustomValidators.nameValidator(
      field: 'Name',
      data: name,
      error: param.name.error,
    ),
    CustomValidators.emailValidator(
      field: 'Email',
      email: email,
      error: param.email.error,
    ),
    CustomValidators.nameValidator(
      field: 'Id Number',
      data: idNumber,
      error: param.idNumber.error,
    ),
    CustomValidators.nameValidator(
      field: 'Gst Number',
      data: gstNumber,
      error: param.gstNumber.error,
      required: false,
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
    CustomValidators.addressValidator(
      field: 'Address',
      data: address,
      error: param.address.error,
    ),
    CustomValidators.countryValidator(
      field: 'Country',
      country: country,
      error: param.country.error,
    ),
    CustomValidators.stateValidator(
      field: 'State or province',
      state: selectedState,
      country: country,
      error: param.state.error,
    ),
    CustomValidators.typeValidator(
      field: 'Id Unique',
      data: id,
      error: param.id.error,
      types: [CommonKeyValueModel],
    ),
  ]);

  if (!isValid) return null;
  SupplierModel supplierModel = SupplierModel(
    name: name,
    state: param.state.value!,
    country: state.params.country.selected!.name,
    address: address,
    mobileNumber: phoneNumber,
    altMobileNumber: altPhoneNumber,
    emailId: email,
    idNumber: idNumber,
    idType: param.id.options.value.first.id,
    gstNumber: gstNumber,
    profilePhotoUrl: state.params.supplier.value?.profilePhotoUrl ?? '',
    idProofUrl: state.params.supplier.value?.idProofUrl ?? '',
    supplierCode: state.params.supplier.value?.supplierCode ?? '',
    disabled: false,
    selected: false,
    altMobileNumberDailCode: altPhoneCountryCode,
    mobileNumberDailCode: phoneCountryCode,
  );

  return supplierModel;
}

Future<void> _onCloseTap(_AddEditSupplierScreenState state) async {
  bool confirmed = false;

  await showDoubleButtonAlert(
    DoubleButtonAlertModel(
      onRightTap: () => {confirmed = true, AppNavigator.pop()},
      content:
          'Are you sure you want to cancel ${state.widget.supplierCode == null ? 'adding' : 'editing'} this supplier?',
    ),
    canClose: true,
  );

  if (!confirmed) return;

  AppNavigator.navigate(AppRoutes.suppliersListing);
}

Future<bool> _askConfirmationToAddOrEdit(_AddEditSupplierScreenState state) async {
  bool confirmed = false;

  await showDoubleButtonAlert(
    DoubleButtonAlertModel(
      onRightTap: () => {confirmed = true, AppNavigator.pop()},
      content: 'Are you sure you want to ${state.widget.supplierCode == null ? 'create' : 'update'} this supplier?',
    ),
    canClose: true,
  );

  return confirmed;
}
