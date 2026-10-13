part of 'category_screen.dart';

Future<void> _onMenuTap(CategoryModel category, AppMenuParams params) async {
  await showAppMenu(
    params: params,
    childrenBuilder: (closeFunction) {
      return [
        AppMenuButtons.editButton(
          () => {
            closeFunction(),
            showCustomCategoryScreen(
              title: 'Edit Category',
              categoryName: category.name,
              categoryCode: category.categoryCode,
              buttonName: 'Save Change',
            ),
          },
        ),
        AppMenuButtons.deleteButton(
          () => {
            closeFunction(),
            _deleteCategory([category]),
          },
        ),
      ];
    },
  );
}

Future<SearchResponseModel> _search(String a) async {
  final response = await CategoryService.getCategoryList(pageNumber: 1, searchKey: a);
  return SearchResponseModel(
    status: (response.responseType.success && response.data != null) ? Status.success : Status.error,
    error: response.firstError(),
    items: (response.data ?? []).map((e) => CommonKeyValueModel(id: e.categoryCode, value: e.name)).toList(),
    searchResultsFor: a,
  );
}

Future<bool> _deleteCategory(List<CategoryModel> category) async {
  bool confirmed = await showMultiDeletePopup(
    model: MultiSelectModel(
      items: category.map((e) => e.name.toPascalCase()).toList(),
      singleString: 'category',
      pluralString: "category's",
    ),
  );

  if (!confirmed) return false;

  String error = '';
  Status s = await handleFutureWithAlert(
    errorMessage: () => error,
    progressbarWaitDuration: Duration.zero,
    function: () async {
      final response =
          await CategoryService.multiDeleteCategory(deleteList: category.map((e) => e.categoryCode).toList());

      if (!response.responseType.success) {
        error = response.firstError();
        return Status.error;
      }

      return Status.success;
    },
    onSuccess: () {
      final context = Globals.context();
      AppSnackBar.showSnackBarWithText(text: '${category.length > 1 ? "category's" : 'category'} deleted');
      context.read<CategoryProvider>().getCategoryList();
    },
  );

  if (s == Status.success) return true;
  return false;
}
