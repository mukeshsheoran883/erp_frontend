part of 'brand_screen.dart';

Future<void> _onMenuTap(BrandModel brand, AppMenuParams params) async {
  await showAppMenu(
    params: params,
    childrenBuilder: (closeFunction) {
      return [
        AppMenuButtons.editButton(
          () => {
            closeFunction(),
            showCustomBrandScreen(
              title: 'Edit Brand',
              brandName: brand.name,
              brandCode: brand.brandCode,
              buttonName: 'Save Change',
            ),
          },
        ),
        AppMenuButtons.deleteButton(
          () => {
            closeFunction(),
            _deleteBrand([brand]),
          },
        ),
      ];
    },
  );
}

Future<SearchResponseModel> _search(String a) async {
  final response = await BrandService.getBrandList(pageNumber: 1, searchKey: a);
  return SearchResponseModel(
    status: (response.responseType.success && response.data != null) ? Status.success : Status.error,
    error: response.firstError(),
    items: (response.data ?? []).map((e) => CommonKeyValueModel(id: e.brandCode, value: e.name)).toList(),
    searchResultsFor: a,
  );
}

Future<bool> _deleteBrand(List<BrandModel> brand) async {
  bool confirmed = await showMultiDeletePopup(
    model: MultiSelectModel(
      items: brand.map((e) => e.name.toPascalCase()).toList(),
      singleString: 'brand',
      pluralString: 'brands',
    ),
  );

  if (!confirmed) return false;

  String error = '';
  Status s = await handleFutureWithAlert(
    errorMessage: () => error,
    progressbarWaitDuration: Duration.zero,
    function: () async {
      final response = await BrandService.multiDeleteBrand(deleteList: brand.map((e) => e.brandCode).toList());

      if (!response.responseType.success) {
        error = response.firstError();
        return Status.error;
      }

      return Status.success;
    },
    onSuccess: () {
      final context = Globals.context();
      AppSnackBar.showSnackBarWithText(text: '${brand.length > 1 ? 'brands' : 'brand'} deleted');
      context.read<BrandProvider>().getBrandList();
    },
  );

  if (s == Status.success) return true;
  return false;
}
