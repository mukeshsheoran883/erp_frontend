part of '../add_stock_pending_transfer_screen.dart';

class _StockPendingTransferDetailsForm extends StatefulWidget {
  final _AddEditStockPendingTransferScreenState state;

  const _StockPendingTransferDetailsForm({required this.state});

  @override
  State<_StockPendingTransferDetailsForm> createState() => _StockPendingTransferDetailsFormState();
}

class _StockPendingTransferDetailsFormState extends State<_StockPendingTransferDetailsForm> {
  late ScrollController scrollController;

  @override
  void initState() {
    scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PageHeaderContainer(
          widgets: [
            Padding(
              padding: const EdgeInsets.only(
                top: 5,
              ),
              child: Text.rich(
                TextSpan(
                  text: 'Stock Transfer Details',
                  style: Ts.xl2Medium(
                    color: Tm.color(Tc.txtH3),
                  ),
                ),
              ),
            ),
            Spacer(),
            SquareIconButton(
              model: SquareIconButtonModel(
                buttonIcon: Assets.icons.add,
                tooltip: 'Add item',
                onTap: _addTile,
                buttonBgColor: Tm.color(Tc.priIconLight),
                iconColor: Tm.color(Tc.priIconLight),
                iconSize: 18,
              ),
            ),
            PageHeaderButton(
              label: 'Close',
              onTap: () => _onCloseTap(widget.state),
              icon: Assets.icons.closeSquare,
              buttonColor: Tm.color(Tc.neuDef),
              textColor: Tm.color(Tc.neuNeuBtnTxt),
            ),
            PageHeaderButton(
              label: 'Transfer Now',
              onTap: () => _onSaveTap(widget.state),
              icon: Assets.icons.stockTransfer,
            ),
          ],
        ),
        SizedBox(height: 24),
        Expanded(
          child: CustomScrollBar(
            controller: scrollController,
            child: ListView.builder(
              controller: scrollController,
              itemCount: widget.state.params.returnedPurchaseList.options.length,
              itemBuilder: (context, index) => AddStockPendingTransferTile(
                onDelete: widget.state.params.returnedPurchaseList.options.length < 2 ? null : _deleteTile,
                refresh: widget.state._refresh,
                stockPendingTransferItem: widget.state.params.returnedPurchaseList.options[index],
              ),
            ),
          ),
        ),
        SizedBox(height: 12),
      ],
    );
  }

  void _addTile() {
    widget.state.params.returnedPurchaseList.options.add(StockPendingTransferItemModel.empty());
    widget.state._refresh();
  }

  void _deleteTile(StockPendingTransferItemModel model) {
    widget.state.params.returnedPurchaseList.options.removeWhere((e) => e == model);
    widget.state._refresh();
  }

// void _onItemSelected(CommonKeyValueModel? st) {
//   widget.state.params.item.reset(st);
//   widget.state._refresh();
// }

// Future<SearchApiResponseModel> _onItemSearch(SearchModel search) async {
//   final response =
//       await ItemService.getItemsList(searchKey: search.text, pageNumber: search.pageNumber, filter: null);
//
//   return SearchApiResponseModel(
//     response: response,
//     items: response.data?.map((e) => CommonKeyValueModel(id: e.itemCode, value: e.name)).toList() ?? [],
//     searchResultsFor: search.text,
//   );
// }

// Future<SearchApiResponseModel> _onPurchaseSearch(SearchModel search) async {
//   final response =
//       await PurchaseService.getPurchaseList(searchKey: search.text, pageNumber: search.pageNumber, filter: null);
//
//   return SearchApiResponseModel(
//     response: response,
//     items: response.data?.map((e) => CommonKeyValueModel(id: e.purchaseCode, value: e.purchaseBillNumber)).toList() ??
//         [],
//     searchResultsFor: search.text,
//   );
// }
}
