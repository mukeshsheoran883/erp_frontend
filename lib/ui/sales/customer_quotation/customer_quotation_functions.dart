part of 'customer_quotation_screen.dart';

Future<void> _viewCustomerDetails(
  String shopCode,
) async {
  await showRightMenu(CustomerQuotationDetails(shopCode: shopCode));
}

Future<void> _onMenuTap(
    CustomerQuotationModel model, AppMenuParams params,) async {
  await showAppMenu(
    params: params,
    childrenBuilder: (closeFunction) {
      return [
        AppMenuButtons.viewButton(
          () => {
            closeFunction(),
            _viewCustomerDetails(model.customerQuotationId.toString()),
          },
        ),
        AppMenuButtons.textButton(
          text: 'Review',
          onTap: () {
            closeFunction();
            _customerQuotationStatus(
              model,
            );
          },
        ),
        // AppMenuButtons.editButton(
        //       () => {
        //     closeFunction(),
        //     AppNavigator.navigate(AppRoutes.branchEdit(data: AddEditBranchScreen(shopCode: branch.shopCode))),
        //   },
        // ),
        // AppMenuButtons.deleteButton(
        //       () => {
        //     closeFunction(),
        //     _deleteBranches([branch]),
        //   },
        // ),
      ];
    },
  );
}

Future<bool> _customerQuotationStatus(CustomerQuotationModel model) async {
  bool confirmed = await showMultiReviewPopup(
    model: MultiSelectModel(
      items: [model.customerName.toPascalCase()],
      singleString: 'Customer Quotation',
      pluralString: 'branches',
    ),
  );

  if (!confirmed) return false;

  String error = '';
  Status s = await handleFutureWithAlert(
    errorMessage: () => error,
    progressbarWaitDuration: Duration.zero,
    function: () async {
      CustomerQuotationStatusModel customerQuotationStatusModel =
          CustomerQuotationStatusModel(
              customerQuotationId: model.customerQuotationId,
              status: 'phone_confirmed',);

      final response = await CustomerQuotationService.customerQuotationStats(
          customerQuotationStatusModel,);

      if (!response.responseType.success) {
        error = response.firstError();
        return Status.error;
      }

      return Status.success;
    },
    onSuccess: () {
      final context = Globals.context();
      AppSnackBar.showSnackBarWithText(text: '${'Customer Quotation'} review');
      context.read<CustomerQuotationProvider>().getCustomerQuotationList();
    },
  );

  if (s == Status.success) return true;
  return false;
}

Future<SearchResponseModel> _search(String a) async {
  final response = await BranchService.getBranchList(
      pageNumber: 1, searchKey: a, filter: null,);
  return SearchResponseModel(
    status: (response.responseType.success && response.data != null)
        ? Status.success
        : Status.error,
    error: response.firstError(),
    items: (response.data ?? [])
        .map((e) => CommonKeyValueModel(id: e.shopCode, value: e.name))
        .toList(),
    searchResultsFor: a,
  );
}

// Future<void> _showFilter() async {
//   await showRightMenu(const BranchFilterSection());
// }

Future<bool> showMultiReviewPopup({required MultiSelectModel model}) async {
  if (model.items.isEmpty) return false;
  bool confirmed = false;

  bool isMultiple = model.items.length > 1;

  await showDoubleButtonAlert(
    DoubleButtonAlertModel(
      title: 'Review ${isMultiple ? model.pluralString : model.singleString}',
      onRightTap: () => {confirmed = true, AppNavigator.pop()},
      content:
          'Are you sure you want to review the following ${model.items.length} ${isMultiple ? model.pluralString : model.singleString}?',
      multiContent: model.items,
      leftText: 'Close',
      rightText: 'Review',
      rightIcon: SvgImage(Assets.icons.eye, width: 22, height: 22),
    ),
    canClose: true,
  );

  return confirmed;
}
