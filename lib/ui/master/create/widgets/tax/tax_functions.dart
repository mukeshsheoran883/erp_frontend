part of 'tax_screen.dart';

Future<void> _onMenuTap(TaxModel tax, AppMenuParams params) async {
  await showAppMenu(
    params: params,
    childrenBuilder: (closeFunction) {
      return [
        AppMenuButtons.viewButton(() => {closeFunction(), _viewTaxDetails(tax.taxCode)}),
        AppMenuButtons.editButton(
          () => {
            closeFunction(),
            showAddTaxPopup(
              title: 'Edit Tax  ',
              taxName: tax.name,
              taxCode: tax.taxCode,
              tax: tax.totalTax.toString(),
              totalTax: tax.totalTax.toString(),
              buttonName: 'Save Change',
            ),
          },
        ),
        AppMenuButtons.deleteButton(
          () => {
            closeFunction(),
            _deleteTax([tax]),
          },
        ),
      ];
    },
  );
}

Future<void> _viewTaxDetails(
  String taxCode,
) async {
  await showRightMenu(TaxDetails(taxCode: taxCode));
}

Future<SearchResponseModel> _search(String a) async {
  final response = await TaxService.getTaxList(pageNumber: 1, searchKey: a);
  return SearchResponseModel(
    status: (response.responseType.success && response.data != null) ? Status.success : Status.error,
    error: response.firstError(),
    items: (response.data ?? []).map((e) => CommonKeyValueModel(id: e.taxCode, value: e.name)).toList(),
    searchResultsFor: a,
  );
}

Future<bool> _deleteTax(List<TaxModel> tax) async {
  bool confirmed = await showMultiDeletePopup(
    model: MultiSelectModel(
      items: tax.map((e) => e.name.toPascalCase()).toList(),
      singleString: 'tax',
      pluralString: 'taxes',
    ),
  );

  if (!confirmed) return false;

  String error = '';
  Status s = await handleFutureWithAlert(
    errorMessage: () => error,
    progressbarWaitDuration: Duration.zero,
    function: () async {
      final response = await TaxService.multiDeleteTax(deleteList: tax.map((e) => e.taxCode).toList());

      if (!response.responseType.success) {
        error = response.firstError();
        return Status.error;
      }

      return Status.success;
    },
    onSuccess: () {
      final context = Globals.context();
      AppSnackBar.showSnackBarWithText(text: '${tax.length > 1 ? 'Taxes' : 'Tax'} deleted');
      context.read<TaxProvider>().getTaxList();
    },
  );

  if (s == Status.success) return true;
  return false;
}
