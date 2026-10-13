part of '../add_returned_purchase_screen.dart';

class _ReturnedPurchaseDetailsForm extends StatefulWidget {
  final _AddEditReturnedPurchaseScreenState state;

  const _ReturnedPurchaseDetailsForm({required this.state});

  @override
  State<_ReturnedPurchaseDetailsForm> createState() => _PurchaseDetailsFormState();
}

class _PurchaseDetailsFormState extends State<_ReturnedPurchaseDetailsForm> {
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
            SizedBox(
              width: 300,
              child: SearchPopupTextField(
                selected: widget.state.params.purchaseId.selected,
                hint: 'Purchase ID',
                popupSubject: 'purchase',
                onSelected: _onPurchaseIDSelected,
                onSearch: _onPurchaseSearch,
                error: widget.state.params.purchaseId.error.errorMessage,
              ),
            ),
            SizedBox(
              width: 300,
              child: SearchPopupTextField(
                selected: widget.state.params.item.selected,
                hint: 'Item List',
                popupSubject: 'item',
                onSelected: _onItemSelected,
                onSearch: _onItemSearch,
                error: widget.state.params.item.error.errorMessage,
              ),
            ),
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
            Spacer(),
            PageHeaderButton(
                label: 'Proceed Return', onTap: () => _onSaveTap(widget.state), icon: Assets.icons.archiveBook),
          ],
        ),
        SizedBox(height: 24),
        Expanded(
          child: CustomScrollBar(
            controller: scrollController,
            child: ListView.builder(
              controller: scrollController,
              itemCount: widget.state.params.returnedPurchaseList.options.length,
              itemBuilder: (context, index) => AddReturnedPurchaseTile(
                onDelete: widget.state.params.returnedPurchaseList.options.length < 2 ? null : _deleteTile,
                refresh: widget.state._refresh,
                returnedItem: widget.state.params.returnedPurchaseList.options[index],
              ),
            ),
          ),
        ),
        SizedBox(height: 12),
      ],
    );
  }

  void _addTile() {
    widget.state.params.returnedPurchaseList.options.add(ReturnedItem.empty());
    widget.state._refresh();
  }

  void _deleteTile(ReturnedItem model) {
    widget.state.params.returnedPurchaseList.options.removeWhere((e) => e == model);
    widget.state._refresh();
  }

  void _onItemSelected(CommonKeyValueModel? st) {
    widget.state.params.item.reset(st);
    widget.state._refresh();
  }

  void _onPurchaseIDSelected(CommonKeyValueModel? st) {
    widget.state.params.purchaseId.reset(st);
    widget.state._refresh();
  }

  Future<SearchApiResponseModel> _onItemSearch(SearchModel search) async {
    final response =
        await ItemService.getItemsList(searchKey: search.text, pageNumber: search.pageNumber, filter: null);

    return SearchApiResponseModel(
      response: response,
      items: response.data?.map((e) => CommonKeyValueModel(id: e.itemCode, value: e.name)).toList() ?? [],
      searchResultsFor: search.text,
    );
  }

  Future<SearchApiResponseModel> _onPurchaseSearch(SearchModel search) async {
    final response =
        await PurchaseService.getPurchaseList(searchKey: search.text, pageNumber: search.pageNumber, filter: null);

    return SearchApiResponseModel(
      response: response,
      items: response.data?.map((e) => CommonKeyValueModel(id: e.purchaseCode, value: e.purchaseBillNumber)).toList() ??
          [],
      searchResultsFor: search.text,
    );
  }
}
