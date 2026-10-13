part of '../add_category_screen.dart';

Future<void> _getCategory(_AddEditCategoryScreenState state) async {
  _setInitialValues(
    state,
  );
  state._refresh();
  await _setInitialValues(state);
  state.params.category.resetError();
  state.params.category.setStatus(Status.success);
  state._refresh();
}

Future<void> _setInitialValues(
  _AddEditCategoryScreenState state,
) async {
  state.params.name.reset(state.widget.categoryName);
}

void _resetErrors(_AddEditCategoryScreenState state) => state.params.allParams().forEach((d) => d.resetError());

void _dispose(_AddEditCategoryScreenState state) => state.params.allParams().forEach((d) => d.dispose());

Future<void> _onSaveTap(_AddEditCategoryScreenState state, BuildContext context) async {
  await handleFutureWithAlert(
    errorMessage: () => '',
    function: () async {
      final valid = _validate(state);
      if (valid != null) {
        context.pop();
        final provider = context.read<CategoryProvider>();
        await CategoryService.createCategory(valid);
        provider.clear();
        provider.getCategoryList();
      }
      state._refresh();
      return Status.success;
    },
  );
}

Future<void> _onSaveChangeTap(_AddEditCategoryScreenState state, BuildContext context) async {
  await handleFutureWithAlert(
    errorMessage: () => '',
    function: () async {
      final valid = _validate(state);
      if (valid != null) {
        context.pop();
        final provider = context.read<CategoryProvider>();
        await CategoryService.updateCategory(valid);
        provider.clear();
        provider.getCategoryList();
      }
      state._refresh();
      return Status.success;
    },
  );
}

Future<void> _onDeleteTap(_AddEditCategoryScreenState state, BuildContext context) async {
  await handleFutureWithAlert(
    errorMessage: () => '',
    function: () async {
      context.pop();
      final provider = context.read<CategoryProvider>();
      await CategoryService.multiDeleteCategory(deleteList: [state.widget.categoryCode!]);
      provider.clear();
      provider.getCategoryList();
      state._refresh();
      return Status.success;
    },
  );
}

CategoryModel? _validate(_AddEditCategoryScreenState state) {
  _resetErrors(state);
  AddCategoryParams param = state.params;
  String name = param.name.text;
  bool isValid = Validator.validate([
    CustomValidators.nameValidator(field: 'Category Name', data: name, error: param.name.error),
  ]);
  if (!isValid) return null;
  CategoryModel categoryModel = CategoryModel(
    name: name,
    categoryCode: state.widget.categoryCode!,
    disabled: false,
    selected: false,
  );

  return categoryModel;
}
