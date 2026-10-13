part of 'branch_screen.dart';

Future<void> _viewCustomerDetails(
  String shopCode,
) async {
  await showRightMenu(BranchDetails(shopCode: shopCode));
}

Future<void> _onMenuTap(BranchModel branch, AppMenuParams params) async {
  await showAppMenu(
    params: params,
    childrenBuilder: (closeFunction) {
      return [
        AppMenuButtons.viewButton(() => {closeFunction(), _viewCustomerDetails(branch.shopCode)}),
        AppMenuButtons.editButton(
          () => {
            closeFunction(),
            AppNavigator.navigate(AppRoutes.branchEdit(data: AddEditBranchScreen(shopCode: branch.shopCode))),
          },
        ),
        AppMenuButtons.deleteButton(
          () => {
            closeFunction(),
            _deleteBranches([branch]),
          },
        ),
      ];
    },
  );
}

Future<bool> _deleteBranches(List<BranchModel> branch) async {
  bool confirmed = await showMultiDeletePopup(
    model: MultiSelectModel(
      items: branch.map((e) => e.name.toPascalCase()).toList(),
      singleString: 'branch',
      pluralString: 'branches',
    ),
  );

  if (!confirmed) return false;

  String error = '';
  Status s = await handleFutureWithAlert(
    errorMessage: () => error,
    progressbarWaitDuration: Duration.zero,
    function: () async {
      final response = await BranchService.multiDeleteBranch(deleteList: branch.map((e) => e.shopCode).toList());

      if (!response.responseType.success) {
        error = response.firstError();
        return Status.error;
      }

      return Status.success;
    },
    onSuccess: () {
      final context = Globals.context();
      AppSnackBar.showSnackBarWithText(text: '${branch.length > 1 ? 'Branches' : 'Branch'} deleted');
      context.read<BranchProvider>().getBranchList();
    },
  );

  if (s == Status.success) return true;
  return false;
}

Future<SearchResponseModel> _search(String a) async {
  final response = await BranchService.getBranchList(pageNumber: 1, searchKey: a, filter: null);
  return SearchResponseModel(
    status: (response.responseType.success && response.data != null) ? Status.success : Status.error,
    error: response.firstError(),
    items: (response.data ?? []).map((e) => CommonKeyValueModel(id: e.shopCode, value: e.name)).toList(),
    searchResultsFor: a,
  );
}

Future<void> _showFilter() async {
  await showRightMenu(const BranchFilterSection());
}
