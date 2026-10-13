part of '../aad_brand_screen.dart';

Future<void> _getBrand(_AddEditBrandScreenState state) async {
  _setInitialValues(state);
  state._refresh();
  await _setInitialValues(state);
  state.params.brand.resetError();
  state.params.brand.setStatus(Status.success);
  state._refresh();
}

Future<void> _setInitialValues(_AddEditBrandScreenState state) async {
  state.params.name.reset(state.widget.brandName);
}

void _resetErrors(_AddEditBrandScreenState state) => state.params.allParams().forEach((d) => d.resetError());

void _dispose(_AddEditBrandScreenState state) => state.params.allParams().forEach((d) => d.dispose());

Future<void> _onSaveTap(_AddEditBrandScreenState state, BuildContext context) async {
  await handleFutureWithAlert(
    errorMessage: () => '',
    function: () async {
      final valid = _validate(state);
      if (valid != null) {
        context.pop();
        final provider = context.read<BrandProvider>();
        await BrandService.createBrand(valid);
        provider.clear();
        provider.getBrandList();
      }
      state._refresh();
      return Status.success;
    },
  );
}

Future<void> _onSaveChangeTap(_AddEditBrandScreenState state, BuildContext context) async {
  await handleFutureWithAlert(
    errorMessage: () => '',
    function: () async {
      final valid = _validate(state);
      if (valid != null) {
        context.pop();
        final provider = context.read<BrandProvider>();
        await BrandService.updateBrand(valid);
        provider.clear();
        provider.getBrandList();
      }
      state._refresh();
      return Status.success;
    },
  );
}

Future<void> _onDeleteTap(_AddEditBrandScreenState state, BuildContext context) async {
  await handleFutureWithAlert(
    errorMessage: () => '',
    function: () async {
      context.pop();
      final provider = context.read<BrandProvider>();
      await BrandService.multiDeleteBrand(deleteList: [state.widget.brandCode!]);
      provider.clear();
      provider.getBrandList();
      state._refresh();
      return Status.success;
    },
  );
}

BrandModel? _validate(_AddEditBrandScreenState state) {
  _resetErrors(state);
  AddBrandParams param = state.params;
  String name = param.name.text;
  bool isValid = Validator.validate([
    CustomValidators.nameValidator(field: 'Brand name', data: name, error: param.name.error),
  ]);
  if (!isValid) return null;
  BrandModel brandModel = BrandModel(name: name, brandCode: state.widget.brandCode!, disabled: false, selected: false);
  return brandModel;
}
