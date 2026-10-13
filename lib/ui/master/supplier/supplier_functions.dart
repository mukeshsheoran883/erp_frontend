part of 'supplier_screen.dart';

Future<void> _viewSuppliersDetails(
  String supplierCode,
) async {
  await showRightMenu(SupplierDetails(supplierCode: supplierCode));
}

Future<void> _onMenuTap(SupplierModel supplier, AppMenuParams params) async {
  await showAppMenu(
    params: params,
    childrenBuilder: (closeFunction) {
      return [
        AppMenuButtons.viewButton(() => {closeFunction(), _viewSuppliersDetails(supplier.supplierCode)}),
        AppMenuButtons.editButton(
          () => {
            closeFunction(),
            AppNavigator.navigate(
              AppRoutes.suppliersEdit(
                data: AddEditSupplierScreen(
                  supplierCode: supplier.supplierCode,
                ),
              ),
            ),
          },
        ),
        AppMenuButtons.deleteButton(() {
          closeFunction();
          _deleteSupplier([supplier]);
        }),
      ];
    },
  );
}

Future<bool> _deleteSupplier(List<SupplierModel> supplier) async {
  final model = MultiSelectModel(
    items: supplier.map((e) => e.name.toPascalCase()).toList(),
    singleString: 'supplier',
    pluralString: 'suppliers',
  );

  bool confirmed = await showMultiDeletePopup(model: model);

  if (!confirmed) return false;

  String error = '';
  Status s = await handleFutureWithAlert(
    errorMessage: () => error,
    progressbarWaitDuration: Duration.zero,
    function: () async {
      final response =
          await SupplierService.multiDeleteSupplier(deleteList: supplier.map((e) => e.supplierCode).toList());

      if (!response.responseType.success) {
        error = response.firstError();
        return Status.error;
      }

      return Status.success;
    },
    onSuccess: () {
      final context = Globals.context();
      AppSnackBar.showSnackBarWithText(
        text: '${(supplier.length > 1 ? model.pluralString : model.singleString).toFirstLetterUpperCase()} deleted',
      );
      context.read<SupplierProvider>().getSupplierList();
    },
  );

  if (s == Status.success) return true;
  return false;
}

Future<SearchResponseModel> _search(String a) async {
  final response = await SupplierService.getSupplierList(pageNumber: 1, searchKey: a, filter: null);
  return SearchResponseModel(
    status: (response.responseType.success && response.data != null) ? Status.success : Status.error,
    error: response.firstError(),
    items: (response.data ?? []).map((e) => CommonKeyValueModel(id: e.supplierCode, value: e.name)).toList(),
    searchResultsFor: a,
  );
}

Future<void> _showFilter() async {
  await showRightMenu(const SupplierFilterSection());
}
