  part of 'stock_available_screen.dart';

  Future<void> _viewCustomerDetails(String purchaseCode) async {
    // await showPopup(child: PurchaseDetails(purchaseCode: purchaseCode), canClose: true);
  }

  Future<void> _onMenuTap(StockAvailableModel stockAvailable, AppMenuParams params) async {
    await showAppMenu(
      params: params,
      childrenBuilder: (closeFunction) {
        return [
          AppMenuButtons.viewButton(() => {closeFunction(), _viewCustomerDetails(stockAvailable.purchaseId)}),
          AppMenuButtons.editButton(
            () => {
              closeFunction(),
              AppNavigator.navigate(
                AppRoutes.stockAvailableEdit(
                    data: AddEditStockAvailableScreen(stockAvailableCode: stockAvailable.purchaseId)),
              ),
            },
          ),
          AppMenuButtons.textButton(text: 'Print'),
          AppMenuButtons.textButton(text: 'Download'),
          AppMenuButtons.textButton(text: 'Convert To Stock'),
          AppMenuButtons.divider(),
          AppMenuButtons.deleteButton(
            () => {
              closeFunction(),
              _deletePurchase([stockAvailable]),
            },
          ),
        ];
      },
    );
  }

  Future<bool> _deletePurchase(List<StockAvailableModel> stockAvailable) async {
    bool confirmed = await showMultiDeletePopup(
      model: MultiSelectModel(
        items: stockAvailable.map((e) => e.purchaseId.toPascalCase()).toList(),
        singleString: 'purchase',
        pluralString: 'purchases',
      ),
    );

    if (!confirmed) return false;

    String error = '';
    Status s = await handleFutureWithAlert(
      errorMessage: () => error,
      progressbarWaitDuration: Duration.zero,
      function: () async {


        return Status.success;
      },

    );

    if (s == Status.success) return true;
    return false;
  }

  Future<SearchResponseModel> _search(String a) async {
    final response = await StockAvailableService.getStockAvailableList(
      pageNumber: 1,
      searchKey: a,
    );
    return SearchResponseModel(
      status: (response.responseType.success && response.data != null) ? Status.success : Status.error,
      error: response.firstError(),
      items: (response.data ?? []).map((e) => CommonKeyValueModel(id: e.purchaseId, value: e.purchaseId)).toList(),
      searchResultsFor: a,
    );
  }

  Future<void> _showFilter() async {
    await showRightMenu(const PurchaseFilterSection());
  }
