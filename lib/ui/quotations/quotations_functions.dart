part of 'quotations_screen.dart';

Future<void> _viewCustomerDetails(String purchaseCode) async {
  // await showPopup(child: PurchaseDetails(purchaseCode: purchaseCode), canClose: true);
}

Future<void> _onMenuTap(QuotationsModel quotations, AppMenuParams params) async {
  await showAppMenu(
    params: params,
    childrenBuilder: (closeFunction) {
      return [
        AppMenuButtons.editButton(
          () => {
            closeFunction(),
            AppNavigator.navigate(
              AppRoutes.purchaseEdit(data: AddEditPurchaseScreen(purchaseCode: quotations.quotationId.toString())),
            ),
          },
        ),
        AppMenuButtons.textButton(text: 'Download'),
        AppMenuButtons.textButton(text: 'Print'),
        AppMenuButtons.divider(),
        AppMenuButtons.deleteButton(
          () => {
            closeFunction(),
            _deletePurchase([quotations]),
          },
        ),
      ];
    },
  );
}

Future<bool> _deletePurchase(List<QuotationsModel> quotations) async {
  bool confirmed = await showMultiDeletePopup(
    model: MultiSelectModel(
      items: quotations.map((e) => e.organisationId.toPascalCase()).toList(),
      singleString: 'new supply',
      pluralString: "new supply's",
    ),
  );

  if (!confirmed) return false;

  String error = '';
  Status s = await handleFutureWithAlert(
    errorMessage: () => error,
    progressbarWaitDuration: Duration.zero,
    function: () async {
      // final response = await BranchService.multiDeleteBranch(deleteList: purchase.map((e) => e.purchaseCode).toList());

      // if (!response.responseType.success) {
      //   error = response.firstError();
      //   return Status.error;
      // }

      return Status.success;
    },
    // onSuccess: () {
    //   final context = Globals.context();
    //   AppSnackBar.showSnackBarWithText(text: '${purchase.length > 1 ? 'Purchases' : 'Purchase'} deleted');
    //   context.read<PurchaseProvider>().getPurchaseList();
    // },
  );

  if (s == Status.success) return true;
  return false;
}

Future<SearchResponseModel> _search(String a) async {
  final response = await QuotationsService.getQuotationsList(
    pageNumber: 1,
    searchKey: a,
  );
  return SearchResponseModel(
    status: (response.responseType.success && response.data != null) ? Status.success : Status.error,
    error: response.firstError(),
    items: (response.data ?? []).map((e) => CommonKeyValueModel(id: e.organisationId, value: e.organisationId)).toList(),
    searchResultsFor: a,
  );
}

Future<void> _showFilter() async {
  await showRightMenu(const PurchaseFilterSection());
}
