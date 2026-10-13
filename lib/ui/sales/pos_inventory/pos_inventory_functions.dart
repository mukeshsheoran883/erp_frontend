part of 'pos_inventory.dart';

Future<void> _onMenuTap(PosModel posModel, AppMenuParams params) async {
  await showAppMenu(
    params: params,
    childrenBuilder: (closeFunction) {
      return [
        AppMenuButtons.textButton(
          text: 'Inventory Confirm',
          onTap: () => {
            closeFunction(),
            _inventoryConfirmPos(posModel),
          },
        ),
        AppMenuButtons.textButton(
          text: 'Cancel',
          onTap: () => {
            closeFunction(),
            _cancelPos(posModel),
          },
        ),
      ];
    },
  );
}

// Shared confirm-then-call-API-then-refresh flow for Inventory Confirm /
// Cancel — same pattern as customer_screen's delete flow, kept local to this
// file since it refreshes GodownProvider instead of CustomerProvider.
Future<bool> _posAction({
  required PosModel posModel,
  required String actionTitle,
  required Future<ApiResponseModel> Function(int posId) apiCall,
  Color? rightButtonBg,
}) async {
  bool confirmed = false;

  final String content = _posActionContent(actionTitle, posModel.posCode);

  await showDoubleButtonAlert(
    DoubleButtonAlertModel(
      title: '$actionTitle Pos',
      onRightTap: () => {confirmed = true, AppNavigator.pop()},
      content: content,
      leftText: 'Close',
      rightText: actionTitle,
      rightButtonBg: rightButtonBg ?? Tm.color(Tc.breadcrumbsDefTxt),
    ),
    canClose: true,
  );

  if (!confirmed) return false;

  String error = '';
  Status s = await handleFutureWithAlert(
    errorMessage: () => error,
    progressbarWaitDuration: Duration.zero,
    function: () async {
      // FIX: apiCall now ONLY calls the API and returns the response.
      // Previously it also called `GodownProvider().getGodownList()`
      // *inside* this function, which runs under handleFutureWithAlert's
      // own progress/spinner — causing GodownProvider's consumer to show
      // a second, overlapping spinner. The refresh is now done in
      // onSuccess (below), after this alert's spinner has already closed,
      // matching the pattern used in customer_screen.dart.
      final response = await apiCall(posModel.posId);

      if (!response.responseType.success) {
        error = response.firstError();
        return Status.error;
      }

      return Status.success;
    },
    onSuccess: () {
      AppSnackBar.showSnackBarWithText(
        text: _posActionSuccessMessage(actionTitle),
      );

      // FIX: moved here from inside apiCall — see comment above.
      // This now fires after the confirm alert's spinner is gone, so only
      // GodownProvider's own loading indicator (if any) shows — one
      // spinner instead of two.
      Globals.context().read<GodownProvider>().getGodownList();
    },
  );

  return s == Status.success;
}

String _posActionContent(String actionTitle, String posCode) {
  switch (actionTitle) {
    case 'Inventory Confirm':
      return 'Confirm inventory for Pos $posCode? This will lock in the inventory details for this order.';
    case 'Cancel':
      return 'Cancel Pos $posCode? This will stop the order from being processed further. This action cannot be undone.';
    default:
      return 'Are you sure you want to $actionTitle this Pos ($posCode)?';
  }
}

String _posActionSuccessMessage(String actionTitle) {
  switch (actionTitle) {
    case 'Inventory Confirm':
      return 'Pos inventory confirmed successfully';
    case 'Cancel':
      return 'Pos cancelled successfully';
    default:
      return 'Pos $actionTitle action completed successfully';
  }
}

Future<void> _inventoryConfirmPos(PosModel posModel) async {
  await _posAction(
    posModel: posModel,
    actionTitle: 'Inventory Confirm',
    // FIX: apiCall is now a thin wrapper — just the API call, no
    // GodownProvider refresh here. Refresh happens in onSuccess.
    apiCall: (id) => PosService.inventoryConfirmPos(posId: id),
  );
}

Future<void> _cancelPos(PosModel posModel) async {
  await _posAction(
    posModel: posModel,
    actionTitle: 'Cancel',
    // FIX: same as above — no GodownProvider call inside apiCall anymore.
    apiCall: (id) => PosService.cancelPos(posId: id),
    rightButtonBg: Tm.color(Tc.redDef),
  );
}

Future<SearchResponseModel> _search(String a) async {
  final response = await PurchaseService.getPurchaseList(
    pageNumber: 1,
    searchKey: a,
    filter: null,
  );
  return SearchResponseModel(
    status: (response.responseType.success && response.data != null)
        ? Status.success
        : Status.error,
    error: response.firstError(),
    items: (response.data ?? [])
        .map(
          (e) => CommonKeyValueModel(
            id: e.purchaseCode,
            value: e.purchaseBillNumber,
          ),
        )
        .toList(),
    searchResultsFor: a,
  );
}
