part of 'customer_screen.dart';

Future<void> _viewCustomerDetails(
  String customerCode,
) async {
  await showRightMenu(CustomerDetails(customerCode: customerCode));
}

Future<void> _onMenuTap(CustomerModel customer, AppMenuParams params) async {
  await showAppMenu(
    params: params,
    childrenBuilder: (closeFunction) {
      return [
        AppMenuButtons.viewButton(() => {closeFunction(), _viewCustomerDetails(customer.customerCode)}),
        AppMenuButtons.editButton(
          () => {
            closeFunction(),
            AppNavigator.navigate(
              AppRoutes.customersEdit(
                data: AddEditCustomerScreen(
                  customerCode: customer.customerCode,
                ),
              ),
            ),
          },
        ),
        AppMenuButtons.deleteButton(
          () => {
            closeFunction(),
            _deleteCustomer([customer]),
          },
        ),
      ];
    },
  );
}

Future<bool> _deleteCustomer(List<CustomerModel> customer) async {
  final model = MultiSelectModel(
    items: customer.map((e) => e.name.toPascalCase()).toList(),
    singleString: 'customer',
    pluralString: 'customers',
  );

  bool confirmed = await showMultiDeletePopup(model: model);

  if (!confirmed) return false;

  String error = '';
  Status s = await handleFutureWithAlert(
    errorMessage: () => error,
    progressbarWaitDuration: Duration.zero,
    function: () async {
      final response =
          await CustomerService.multiDeleteCustomer(deleteList: customer.map((e) => e.customerCode).toList());

      if (!response.responseType.success) {
        error = response.firstError();
        return Status.error;
      }

      return Status.success;
    },
    onSuccess: () {
      final context = Globals.context();
      AppSnackBar.showSnackBarWithText(
        text: '${(customer.length > 1 ? model.pluralString : model.singleString).toFirstLetterUpperCase()} deleted',
      );
      context.read<CustomerProvider>().getCustomerList();
    },
  );

  if (s == Status.success) return true;
  return false;
}

Future<SearchResponseModel> _search(String a) async {
  final response = await CustomerService.getCustomerList(pageNumber: 1, searchKey: a, filter: null);
  return SearchResponseModel(
    status: (response.responseType.success && response.data != null) ? Status.success : Status.error,
    error: response.firstError(),
    items: (response.data ?? []).map((e) => CommonKeyValueModel(id: e.customerCode, value: e.name)).toList(),
    searchResultsFor: a,
  );
}

Future<void> _showFilter() async {
  await showRightMenu(const CustomerFilterSection());
}
