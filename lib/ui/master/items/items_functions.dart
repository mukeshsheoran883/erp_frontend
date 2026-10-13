part of 'items_screen.dart';

Future<void> _viewItemsDetails(
  String itemCode,
) async {
  await showRightMenu(ItemsDetails(itemCode: itemCode));
}

Future<void> _onMenuTap(ItemModel item, AppMenuParams params) async {
  await showAppMenu(
    params: params,
    childrenBuilder: (closeFunction) {
      return [
        AppMenuButtons.viewButton(() => {closeFunction(), _viewItemsDetails(item.itemCode)}),
        AppMenuButtons.editButton(
          () => {
            closeFunction(),
            AppNavigator.navigate(AppRoutes.itemsEdit(data: AddEditItemScreens(itemCode: item.itemCode))),
          },
        ),
        AppMenuButtons.deleteButton(() {
          closeFunction();
          _deleteItems([item]);
        }),
      ];
    },
  );
}

Future<bool> _deleteItems(List<ItemModel> items) async {
  final model = MultiSelectModel(
    items: items.map((e) => e.name.toPascalCase()).toList(),
    singleString: 'item',
    pluralString: 'items',
  );

  bool confirmed = await showMultiDeletePopup(model: model);

  if (!confirmed) return false;

  String error = '';
  Status s = await handleFutureWithAlert(
    errorMessage: () => error,
    progressbarWaitDuration: Duration.zero,
    function: () async {
      final response = await ItemService.multiDeleteItem(deleteList: items.map((e) => e.itemCode).toList());

      if (!response.responseType.success) {
        error = response.firstError();
        return Status.error;
      }

      return Status.success;
    },
    onSuccess: () {
      final context = Globals.context();
      AppSnackBar.showSnackBarWithText(
        text: '${(items.length > 1 ? model.pluralString : model.singleString).toFirstLetterUpperCase()} deleted',
      );
      context.read<ItemProvider>().getItemList();
    },
  );

  if (s == Status.success) return true;
  return false;
}

Future<SearchResponseModel> _search(String a) async {
  final response = await ItemService.getItemsList(pageNumber: 1, searchKey: a, filter: null);
  return SearchResponseModel(
    status: (response.responseType.success && response.data != null) ? Status.success : Status.error,
    error: response.firstError(),
    items: (response.data ?? []).map((e) => CommonKeyValueModel(id: e.itemCode, value: e.name)).toList(),
    searchResultsFor: a,
  );
}

Future<void> _showFilter() async {
  await showRightMenu(const ItemFilterSection());
}
