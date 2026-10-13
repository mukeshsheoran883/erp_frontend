part of 'pos_screen.dart';

// Future<void> _onMenuTap(PosModel posModel, AppMenuParams params) async {
//   await showAppMenu(
//     params: params,
//     childrenBuilder: (closeFunction) {
//       return [
//         AppMenuButtons.viewButton(
//               () => {
//             closeFunction(),
//             _viewPosDetails(posModel.posCode, posModel.posId.toString()),
//           },
//         ),
//         if (posModel.status == 'draft')
//           AppMenuButtons.textButton(
//             text: 'Confirm',
//             onTap: () => {
//               closeFunction(),
//               _confirmPos(posModel),
//             },
//           ),
//         if (posModel.status == 'confirmed')
//           AppMenuButtons.textButton(
//             text: 'Execute',
//             onTap: () => {
//               closeFunction(),
//               _executePos(posModel),
//             },
//           ),
//         if (posModel.status != 'cancelled')
//           AppMenuButtons.textButton(
//             text: 'Cancel',
//             onTap: () => {
//               closeFunction(),
//               _cancelPos(posModel),
//             },
//           ),
//         AppMenuButtons.textButton(
//           text: 'Send',
//           onTap: () => {
//             closeFunction(),
//             _sendPos(posModel),
//           },
//         ),
//         AppMenuButtons.textButton(
//           text: 'Inventory Confirm',
//           onTap: () => {
//             closeFunction(),
//             _inventoryConfirmPos(posModel),
//           },
//         ),
//         AppMenuButtons.deleteButton(
//               () => {
//             closeFunction(),
//             _deletePos(posModel),
//           },
//         ),
//       ];
//     },
//   );
// }

Future<void> _onMenuTap(PosModel posModel, AppMenuParams params) async {
  final String role =
      AuthenticationProvider.getRole(); // ADMIN / INVENTORY / DISPATCH

  await showAppMenu(
    params: params,
    childrenBuilder: (closeFunction) {
      return [
        AppMenuButtons.viewButton(
          () => {
            closeFunction(),
            _viewPosDetails(posModel.posCode, posModel.posId.toString()),
          },
        ),

        // Confirm — Admin only
        if (posModel.status == 'draft')
          AppMenuButtons.textButton(
            text: 'Confirm',
            onTap: () => {
              closeFunction(),
              _confirmPos(posModel),
            },
          ),


        // Execute — Admin only
        if (posModel.status == 'confirmed' || posModel.status == 'ready_for_execution')
          AppMenuButtons.textButton(
            text: 'Execute',
            onTap: () => {
              closeFunction(),
              _executePos(posModel),
            },
          ),

        // Cancel — Any role
        if (posModel.status != 'cancelled' && posModel.status != 'executed')
          AppMenuButtons.textButton(
            text: 'Cancel',
            onTap: () => {
              closeFunction(),
              _cancelPos(posModel),
            },
          ),

        // // Send — Any role
        // AppMenuButtons.textButton(
        //   text: 'Send',
        //   onTap: () => {
        //     closeFunction(),
        //     _sendPos(posModel),
        //   },
        // ),

        // Delete — Any role
        AppMenuButtons.deleteButton(
          () => {
            closeFunction(),
            _deletePos(posModel),
          },
        ),
      ];
    },
  );
}

Future<void> _viewPosDetails(String posCode, String posId) async {
  await showRightMenu(PosDetails(
    posId: posId,
    posCode: posCode,
  ));
}

// Shared confirm-then-call-API-then-refresh flow for Confirm/Execute/
// Cancel/Send/Inventory Confirm/Delete — mirrors `_deletePurchase`'s
// confirm -> handleFutureWithAlert -> snackbar -> refresh-list pattern,
// but for a single Pos action instead of a multi-delete.
Future<bool> _posAction({
  required PosModel posModel,
  required String actionTitle,
  required Future<ApiResponseModel> Function(int posId) apiCall,
  Color? rightButtonBg,
}) async {
  bool confirmed = false;

  // Action-specific wording instead of one generic sentence reused for
  // every action — each action means something different for a Pos.
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
        text: _posActionSuccessMessage(actionTitle),
      );
      context.read<PosProvider>().getPosList();
    },
  );

  return s == Status.success;
}

// One message per action, written for what actually happens to the
// Pos in each case.
String _posActionContent(String actionTitle, String posCode) {
  switch (actionTitle) {
    case 'Confirm':
      return 'Confirm Pos $posCode? Once confirmed, its details will be locked in and it will move to the next stage.';
    case 'Execute':
      return 'Execute Pos $posCode? This will process the order and cannot be reversed.';
    case 'Cancel':
      return 'Cancel Pos $posCode? This will stop the order from being processed further. This action cannot be undone.';
    case 'Send':
      return 'Send Pos $posCode? This will share the order with the relevant party.';
    case 'Inventory Confirm':
      return 'Confirm inventory for Pos $posCode? This will lock in the inventory details for this order.';
    case 'Delete':
      return 'Delete Pos $posCode? This action cannot be undone.';
    default:
      return 'Are you sure you want to $actionTitle this Pos ($posCode)?';
  }
}

String _posActionSuccessMessage(String actionTitle) {
  switch (actionTitle) {
    case 'Confirm':
      return 'Pos confirmed successfully';
    case 'Execute':
      return 'Pos executed successfully';
    case 'Cancel':
      return 'Pos cancelled successfully';
    case 'Send':
      return 'Pos sent successfully';
    case 'Inventory Confirm':
      return 'Pos inventory confirmed successfully';
    case 'Delete':
      return 'Pos deleted successfully';
    default:
      return 'Pos $actionTitle action completed successfully';
  }
}

Future<void> _confirmPos(PosModel posModel) async {
  await _posAction(
    posModel: posModel,
    actionTitle: 'Confirm',
    apiCall: (id) async {
      final response = await PosService.confirmPos(
        posId: id,
      );

      return response;
    },
  );
}

Future<void> _executePos(PosModel posModel) async {
  await _posAction(
    posModel: posModel,
    actionTitle: 'Execute',
    apiCall: (id) async {
      final response = await PosService.executePos(posId: id);
      return response;
    },
  );
}

Future<void> _cancelPos(PosModel posModel) async {
  await _posAction(
    posModel: posModel,
    actionTitle: 'Cancel',
    apiCall: (id) async {
      final response = await PosService.cancelPos(
        posId: id,
      );
      return response;
    },
    rightButtonBg: Tm.color(Tc.redDef),
  );
}

Future<void> _sendPos(PosModel posModel) async {
  await _posAction(
    posModel: posModel,
    actionTitle: 'Send',
    apiCall: (id) async {
      final response = await PosService.sendPos(
        posId: id,
      );
      return response;
    },
  );
}

Future<void> _inventoryConfirmPos(PosModel posModel) async {
  await _posAction(
    posModel: posModel,
    actionTitle: 'Inventory Confirm',
    apiCall: (id) async {
      final response = await PosService.inventoryConfirmPos(
        posId: id,
      );
      return response;
    },
  );
}

Future<void> _deletePos(PosModel posModel) async {
  await _posAction(
    posModel: posModel,
    actionTitle: 'Delete',
    apiCall: (id) async {
      final response = await PosService.deletePos(
        posId: id,
      );
      return response;
    },
    rightButtonBg: Tm.color(Tc.redDef),
  );
}

Future<SearchResponseModel> _search(String a) async {
  final response = await PurchaseService.getPurchaseList(
      pageNumber: 1, searchKey: a, filter: null);
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

Future<void> _showFilter() async {
  await showRightMenu(const PurchaseFilterSection());
}
