part of '../add_items_screen.dart';

Future<void> _getItem(_AddEditItemScreenState state) async {
  _setInitialValues(state, [], [], [], [], null);
  state._refresh();
  final response = await Future.wait([
    BrandService.getAllBrandList(),
    CategoryService.getAllCategoryList(),
    SupplierService.getAllSupplierList(),
    TaxService.getAllTaxList(),
    if (state.widget.itemCode != null) ItemService.getItem(itemCode: state.widget.itemCode!),
  ]);

  ApiResponseModel<List<BrandModel>> brandResponse = response[0] as ApiResponseModel<List<BrandModel>>;
  ApiResponseModel<List<CategoryModel>> categoryResponse = response[1] as ApiResponseModel<List<CategoryModel>>;
  ApiResponseModel<List<SupplierModel>> supplierResponse = response[2] as ApiResponseModel<List<SupplierModel>>;
  ApiResponseModel<List<TaxModel>> taxResponse = response[3] as ApiResponseModel<List<TaxModel>>;

  ItemModel? editItem;

  if (state.widget.itemCode != null) {
    ApiResponseModel<ItemModel> itemResponse = response[4] as ApiResponseModel<ItemModel>;
    if (!itemResponse.responseType.success || itemResponse.data == null) {
      state.params.item.setError(itemResponse.firstError());
      state.params.item.setStatus(Status.error);
      state._refresh();
      return;
    }
    editItem = itemResponse.data!;
  }

  if (!brandResponse.responseType.success || brandResponse.data == null) {
    state.params.item.setError(brandResponse.firstError());
    state.params.item.setStatus(Status.error);
    state._refresh();
    return;
  }

  if (!categoryResponse.responseType.success || categoryResponse.data == null) {
    state.params.item.setError(categoryResponse.firstError());
    state.params.item.setStatus(Status.error);
    state._refresh();
    return;
  }

  if (!supplierResponse.responseType.success || supplierResponse.data == null) {
    state.params.item.setError(supplierResponse.firstError());
    state.params.item.setStatus(Status.error);
    state._refresh();
    return;
  }

  if (!taxResponse.responseType.success || taxResponse.data == null) {
    state.params.tax.setError(taxResponse.firstError());
    state.params.item.setStatus(Status.error);
    state._refresh();
    return;
  }

  await _setInitialValues(
    state,
    brandResponse.data!,
    categoryResponse.data!,
    supplierResponse.data!,
    taxResponse.data!,
    editItem,
  );
  state.params.item.resetError();
  state.params.item.setStatus(Status.success);
  state._refresh();
}

Future<void> _setInitialValues(
    _AddEditItemScreenState state,
    List<BrandModel> brand,
    List<CategoryModel> category,
    List<SupplierModel> supplier,
    List<TaxModel> tax,
    ItemModel? item,
    ) async {
  state.params.item.reset(item);
  state.params.image.reset(
    (item == null || item.imageUrl.trim().isEmpty)
        ? null
        : CustomImageModel(
      path: item.imageUrl,
      name: FileUtils.getFileNameFromUrl(url: item.imageUrl),
      bytes: null,
      size: 100000,
      extension: '',
      isLocalImage: false,
    ),
  );
  state.params.name.reset(item?.name);
  state.params.hsnCode.reset(item?.hsnCode);
  state.params.qrCode.reset(item?.barQrCode);
  state.params.description.reset(item?.description);
  state.params.date.reset(item?.createdTime);
  state.params.brand.reset(item == null ? null : CommonKeyValueModel(id: item.brandCode, value: item.brandName));
  state.params.brand.options = ValueNotifier(
    brand.map((b) => CommonKeyValueModel(id: b.brandCode, value: b.name.toPascalCase())).toList(),
  );
  state.params.category
      .reset(item == null ? null : CommonKeyValueModel(id: item.categoryCode, value: item.categoryName));
  state.params.category.options = ValueNotifier(
    category.map((c) => CommonKeyValueModel(id: c.categoryCode, value: c.name.toPascalCase())).toList(),
  );
  state.params.supplier
      .reset(item == null ? null : CommonKeyValueModel(id: item.supplierCode, value: item.supplierName));
  state.params.supplier.options = ValueNotifier(
    supplier.map((s) => CommonKeyValueModel(id: s.supplierCode, value: s.name.toPascalCase())).toList(),
  );
  state.params.tax.reset(item == null ? null : CommonKeyValueModel(id: item.taxCode, value: item.taxName));
  state.params.tax.options = ValueNotifier(
    tax.map((t) => CommonKeyValueModel(id: t.taxCode, value: t.name.toPascalCase())).toList(),
  );
  state.params.barQrAuto.reset(false); // NOTE: still no barQrAuto field in GET response

  state.params.noOfPackets.reset(item?.noOfPackets.toString() ?? '1');
  state.params.skuCode.reset(item?.skuCode ?? '');
  state.params.plainPrice.controller.text = item?.plainPrice.toString() ?? '';
  state.params.printedPrice.controller.text = item?.printedPrice.toString() ?? '';
  state.params.moq.reset(item?.moq.toString() ?? '1');

  state.params.attributes = (item != null && item.attributes.isNotEmpty)
      ? item.attributes.map((a) {
    final entry = AttributeEntry.empty();
    entry.key.reset(a.attributeKey);
    entry.value.reset(a.attributeValue);
    entry.unit.reset(a.attributeUnit);
    return entry;
  }).toList()
      : [AttributeEntry.empty()];

  state.params.otherImages = (item != null && item.otherImages.isNotEmpty)
      ? item.otherImages.map((img) {
    final param = FileParam();
    param.reset(
      CustomImageModel(
        path: img.imageUrl,
        name: FileUtils.getFileNameFromUrl(url: img.imageUrl),
        bytes: null,
        size: 100000,
        extension: '',
        isLocalImage: false,
      ),
    );
    return param;
  }).toList()
      : [];

  _resetErrors(state);
}

void _resetErrors(_AddEditItemScreenState state) => state.params.allParams().forEach((d) => d.resetError());

void _dispose(_AddEditItemScreenState state) => state.params.allParams().forEach((d) => d.dispose());

Future<void> _onSaveTap(_AddEditItemScreenState state) async {
  String errorMessage = '';

  ItemCreateModel? itemModel = _validate(state);
  state._refresh();
  if (itemModel == null) return;

  bool confirmed = await _askConfirmationToAddOrEdit(state);
  if (!confirmed) return;

  await handleFutureWithAlert(
    errorMessage: () => errorMessage,
    progressbarWaitDuration: Duration.zero,
    function: () async {
      if (state.params.image.file != null && state.params.image.file!.isLocalImage) {
        CustomImageModel itemImage = state.params.image.file!;
        final fileUploadResponse = await CommonApiServices.fileUpload(
          model: FileUploadModel(
            bytes: itemImage.bytes!,
            fileName: FileUtils.generateUniqueName(fileName: itemImage.name),
            bucketKeys: BucketKeys.itemImage,
          ),
        );

        if (!fileUploadResponse.responseType.success || fileUploadResponse.data == null) {
          errorMessage = fileUploadResponse.firstError();
          return Status.error;
        }

        itemModel.imageUrl = fileUploadResponse.data!.fileUrl;
      } else {
        itemModel.imageUrl = state.params.item.value?.imageUrl ?? '';
      }

      final List<String> uploadedOtherImages = [];
      for (final imageParam in state.params.otherImages) {
        if (imageParam.file == null) continue;
        if (imageParam.file!.isLocalImage) {
          final uploadResponse = await CommonApiServices.fileUpload(
            model: FileUploadModel(
              bytes: imageParam.file!.bytes!,
              fileName: FileUtils.generateUniqueName(fileName: imageParam.file!.name),
              bucketKeys: BucketKeys.itemImage,
            ),
          );
          if (!uploadResponse.responseType.success || uploadResponse.data == null) {
            errorMessage = uploadResponse.firstError();
            return Status.error;
          }
          uploadedOtherImages.add(uploadResponse.data!.fileUrl);
        } else {
          uploadedOtherImages.add(imageParam.file!.path);
        }
      }
      itemModel.otherImages = uploadedOtherImages;

      final createItemResponse = state.widget.itemCode == null
          ? await ItemService.createItem(itemModel)
          : await ItemService.updateItem(itemModel);

      if (!createItemResponse.responseType.success || createItemResponse.data == null) {
        errorMessage = createItemResponse.firstError();
        return Status.error;
      }

      return Status.success;
    },
    onSuccess: () {
      AppSnackBar.showSnackBarWithText(
        text: state.widget.itemCode == null
            ? 'Item created successfully. Please click the activation link sent to ${itemModel.name} to activate the account.'
            : 'Item updated successfully',
        duration: state.widget.itemCode == null ? const Duration(seconds: 6) : null,
      );
      AppNavigator.navigate(AppRoutes.itemListing);
    },
  );
}

ItemCreateModel? _validate(_AddEditItemScreenState state) {
  _resetErrors(state);
  AddItemsParams param = state.params;
  String name = param.name.text;
  String hsnCode = param.hsnCode.text;
  String code = param.qrCode.text;
  String description = param.description.text;
  DateTime? date = param.date.dateTime?.convertToDateAlone();

  FileSize? fileSize;
  if (param.image.file != null) {
    fileSize = FileSize(size: param.image.file!.size.toDouble(), unit: FileSizeUnit.bytes);
  }

  bool isValid = Validator.validate([
    CustomValidators.fileSizeValidator(
      field: 'Item image',
      size: fileSize,
      error: param.image.error,
      required: false,
    ),
    CustomValidators.nameValidator(field: 'Item name', data: name, error: param.name.error),
    CustomValidators.nameValidator(field: 'Hsn Code', data: hsnCode, error: param.hsnCode.error),
    CustomValidators.nameValidator(
      field: 'Qr Code',
      data: code,
      error: param.qrCode.error,
      required: state.params.barQrAuto.value ?? false,
    ),
    CustomValidators.dateValidator(
      field: 'Date and time',
      date: date,
      maxDate: DateTime.now(),
      error: param.date.error,
      required: false,
    ),
    CustomValidators.typeValidator(
      field: 'Brand',
      data: param.brand.selected,
      error: param.brand.error,
      types: [CommonKeyValueModel],
    ),
    CustomValidators.typeValidator(
      field: 'Supplier',
      data: param.supplier.selected,
      error: param.supplier.error,
      types: [CommonKeyValueModel],
    ),
    CustomValidators.typeValidator(
      field: 'Tax',
      data: param.tax.selected,
      error: param.tax.error,
      types: [CommonKeyValueModel],
    ),
    CustomValidators.typeValidator(
      field: 'Category',
      data: param.category.selected,
      error: param.category.error,
      types: [CommonKeyValueModel],
    ),
    CustomValidators.minMaxValidator(
      field: 'No. of Packets',
      value: double.tryParse(param.noOfPackets.text) ?? 0,
      error: param.noOfPackets.error,
      min: 1,
    ),
    CustomValidators.moneyValidator(field: 'Plain price', amount: param.plainPrice.text, error: param.plainPrice.error),
    CustomValidators.moneyValidator(
      field: 'Printed price',
      amount: param.printedPrice.text,
      error: param.printedPrice.error,
    ),
    CustomValidators.minMaxValidator(
      field: 'MOQ',
      value: double.tryParse(param.moq.text) ?? 0,
      error: param.moq.error,
      min: 1,
    ),
    for (final attr in param.attributes) ...[
      CustomValidators.nameValidator(field: 'Attribute name', data: attr.key.text, error: attr.key.error),
      CustomValidators.nameValidator(field: 'Attribute value', data: attr.value.text, error: attr.value.error),
    ],
  ]);

  if (!isValid) return null;

  return ItemCreateModel(
    itemCode: state.widget.itemCode ?? '',
    name: name,
    description: description,
    barQrCode: code,
    brandCode: param.brand.selected!.id,
    categoryCode: param.category.selected!.id,
    supplierCode: param.supplier.selected!.id,
    imageUrl: state.params.item.value?.imageUrl ?? '',
    taxCode: param.tax.selected!.id,
    hsnCode: hsnCode,
    noOfPackets: int.tryParse(param.noOfPackets.text) ?? 1,
    skuCode: param.skuCode.text,
    plainPrice: param.plainPrice.text,
    printedPrice: param.printedPrice.text,
    moq: param.moq.text,
    attributes: param.attributes
        .map((a) => ItemAttributeModel(attributeKey: a.key.text, attributeValue: a.value.text, attributeUnit: a.unit.text))
        .toList(),
    otherImages: [],
  );
}

Future<void> _onCloseTap(_AddEditItemScreenState state) async {
  bool confirmed = false;

  await showDoubleButtonAlert(
    DoubleButtonAlertModel(
      onRightTap: () => {confirmed = true, AppNavigator.pop()},
      content: 'Are you sure you want to cancel ${state.widget.itemCode == null ? 'adding' : 'editing'} this item?',
    ),
    canClose: true,
  );

  if (!confirmed) return;

  AppNavigator.navigate(AppRoutes.itemListing);
}

Future<bool> _askConfirmationToAddOrEdit(_AddEditItemScreenState state) async {
  bool confirmed = false;

  await showDoubleButtonAlert(
    DoubleButtonAlertModel(
      onRightTap: () => {confirmed = true, AppNavigator.pop()},
      content: 'Are you sure you want to ${state.widget.itemCode == null ? 'create' : 'update'} this item?',
    ),
    canClose: true,
  );

  return confirmed;
}