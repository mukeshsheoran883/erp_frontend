part of 'dispatch_screen.dart';

Future<void> _onMenuTap(PosModel posModel, AppMenuParams params) async {
  await showAppMenu(
    params: params,
    childrenBuilder: (closeFunction) {
      return [
        AppMenuButtons.textButton(
          text: 'Add Dispatch Details',
          onTap: () => {
            closeFunction(),
            showAddDispatchDetailsPopup(
              buttonName: 'Save Change',
              posId: posModel.posId,
              posCode: '',
            ),
          },
        ),
        if (posModel.status == 'confirmed')
          AppMenuButtons.textButton(
            text: 'Execute',
            onTap: () => {
              closeFunction(),
              _executePos(posModel),
            },
          ),
        AppMenuButtons.textButton(
          text: 'Dispatch Confirm',
          onTap: () => {
            closeFunction(),
            _dispatchConfirmPos(posModel),
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

Future<bool> _godownAction({
  required PosModel posModel,
  required String actionTitle,
  required Future<ApiResponseModel> Function(int posId) apiCall,
  Color? rightButtonBg,
}) async {
  bool confirmed = false;

  final String content = _godownActionContent(actionTitle, posModel.posCode);

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
      final response = await apiCall(posModel.posId);

      if (!response.responseType.success) {
        error = response.firstError();
        return Status.error;
      }

      return Status.success;
    },
    onSuccess: () {
      final context = Globals.context();
      AppSnackBar.showSnackBarWithText(
        text: _godownActionSuccessMessage(actionTitle),
      );
      context.read<DispatchProvider>().getDispatchList();
    },
  );

  return s == Status.success;
}

String _godownActionContent(String actionTitle, String posCode) {
  switch (actionTitle) {
    case 'Execute':
      return 'Execute Pos $posCode? This will process the order and cannot be reversed.';
    case 'Dispatch Confirm':
      return 'Confirm dispatch for Pos $posCode? This will mark the order as dispatched.';
    case 'Cancel':
      return 'Cancel Pos $posCode? This will stop the order from being processed further. This action cannot be undone.';
    default:
      return 'Are you sure you want to $actionTitle this Pos ($posCode)?';
  }
}

String _godownActionSuccessMessage(String actionTitle) {
  switch (actionTitle) {
    case 'Execute':
      return 'Pos executed successfully';
    case 'Dispatch Confirm':
      return 'Pos dispatch confirmed successfully';
    case 'Cancel':
      return 'Pos cancelled successfully';
    default:
      return 'Pos $actionTitle action completed successfully';
  }
}

Future<void> _executePos(PosModel posModel) async {
  await _godownAction(
    posModel: posModel,
    actionTitle: 'Execute',
    apiCall: (id) async {
      final response = await PosService.executePos(posId: id);
      return response;
    },
  );
}

Future<void> _dispatchConfirmPos(PosModel posModel) async {
  await _godownAction(
    posModel: posModel,
    actionTitle: 'Dispatch Confirm',
    apiCall: (id) async {
      final response = await PosService.dispatchConfirmPos(posId: id);
      return response;
    },
  );
}

Future<void> _cancelPos(PosModel posModel) async {
  await _godownAction(
    posModel: posModel,
    actionTitle: 'Cancel',
    apiCall: (id) async {
      final response = await PosService.cancelPos(posId: id);
      return response;
    },
    rightButtonBg: Tm.color(Tc.redDef),
  );
}

Future<SearchResponseModel> _search(String a) async {
  final response = await PurchaseService.getPurchaseList(
      pageNumber: 1, searchKey: a, filter: null,);
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
