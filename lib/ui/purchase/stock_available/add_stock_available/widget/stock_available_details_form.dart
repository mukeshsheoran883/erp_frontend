part of '../add_stock_available_screen.dart';

class _StockAvailableDetailsForm extends StatefulWidget {
  final _AddEditStockAvailableScreenState state;

  const _StockAvailableDetailsForm({required this.state});

  @override
  State<_StockAvailableDetailsForm> createState() => _StockAvailableDetailsFormState();
}

class _StockAvailableDetailsFormState extends State<_StockAvailableDetailsForm> {
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
    return Container(
      decoration: BoxDecoration(color: Tm.color(Tc.comCardBg), borderRadius: BorderRadius.all(Radius.circular(24))),
      padding: EdgeInsets.only(bottom: 20, top: 20, right: 20, left: 20),
      child: Column(
        children: [
          PageHeaderContainer(
            bottomSpacing: 0,
            widgets: [
              Expanded(
                child: SearchPopupTextField(
                  selected: widget.state.params.items.selected,
                  hint: 'Item Name',
                  title: 'Item Name',
                  required: true,
                  popupSubject: 'item',
                  onSelected: _onItemSelected,
                  onSearch: _onItemSearch,
                  error: widget.state.params.items.error.errorMessage,
                ),
              ),
            ],
          ),
          PageHeaderContainer(
            bottomSpacing: 0,
            topSpacing: 0,
            widgets: [
              Flexible(
                child: TextFieldWithTitle(
                  title: 'Selling Price',
                  required: true,
                  controller: widget.state.params.sellingPrice.controller,
                  error: widget.state.params.sellingPrice.error.errorMessage,
                  onChanged: (a) => {widget.state.params.sellingPrice.resetError(), _refresh()},
                  hint: '',
                ),
              ),
              Flexible(
                child: TextFieldWithTitle(
                  title: 'Vendor Cost',
                  required: true,
                  controller: widget.state.params.vendorCost.controller,
                  error: widget.state.params.vendorCost.error.errorMessage,
                  onChanged: (a) => {widget.state.params.vendorCost.resetError(), _refresh()},
                  hint: '',
                ),
              ),
            ],
          ),
          PageHeaderContainer(
            bottomSpacing: 0,
            topSpacing: 0,
            widgets: [
              Expanded(
                child: CustomDateTimeField(
                  title: 'Created On',
                  required: true,
                  pickMode: DatePickMode.dateAndTime,
                  error: widget.state.params.createdON.error.errorMessage,
                  initialDateTime: widget.state.params.createdON.dateTime,
                  onDateSelected: (a) => {widget.state.params.createdON.reset(a), widget.state._refresh()},
                ),
              ),
              Expanded(
                child: CustomDateTimeField(
                  title: 'Expiry Date',
                  required: true,
                  pickMode: DatePickMode.dateAndTime,
                  error: widget.state.params.expiryDate.error.errorMessage,
                  initialDateTime: widget.state.params.expiryDate.dateTime,
                  onDateSelected: (a) => {widget.state.params.expiryDate.reset(a), widget.state._refresh()},
                ),
              ),
            ],
          ),
          PageHeaderContainer(
            bottomSpacing: 0,
            topSpacing: 0,
            widgets: [
              Expanded(
                flex: 1,
                child: CustomDropdown(
                  title: 'Quantity/Unit',
                  items: widget.state.params.unit.options,
                  onSelected: _onQuantitySelected,
                  hintText: 'Quantity/Unit',
                  required: true,
                  selected: widget.state.params.unit.selected,
                  error: widget.state.params.unit.error.errorMessage,
                ),
              ),
              Expanded(
                flex: 2,
                child: TextFieldWithTitle(
                  title: ' ',
                  controller: widget.state.params.quantity.controller,
                  error: widget.state.params.quantity.error.errorMessage,
                  onChanged: (a) => {widget.state.params.quantity.resetError(), _refresh()},
                  hint: '',
                ),
              ),
              Expanded(
                flex: 2,
                child: TextFieldWithTitle(
                  title: 'Purchase Id',
                  required: true,
                  controller: widget.state.params.purchaseId.controller,
                  error: widget.state.params.purchaseId.error.errorMessage,
                  onChanged: (a) => {widget.state.params.purchaseId.resetError(), _refresh()},
                  hint: '',
                ),
              ),
            ],
          ),
          PageHeaderContainer(
            bottomSpacing: 0,
            topSpacing: 0,
            widgets: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 5,
                ),
                child: Text.rich(
                  TextSpan(
                    text: 'Branch Split',
                    style: Ts.xl2Medium(
                      color: Tm.color(Tc.ipfTitle),
                    ),
                  ),
                ),
              ),
              Spacer(),
              AlertButton(
                text: 'Add Branch',
                style: Ts.xl2Medium(color: Tm.color(Tc.priDef)),
                onTap: _addTile,
                color: Tm.color(Tc.priDef),
                buttonColor: Tm.color(Tc.comCardBg),
                icon: SvgImage(Assets.icons.add, height: 22, width: 22, color: Tm.color(Tc.priDef)),
                iconPadding: EdgeInsets.only(),
              ),
            ],
          ),
          SizedBox(height: 24),
          Expanded(
            child: CustomScrollBar(
              controller: scrollController,
              child: ListView.builder(
                controller: scrollController,
                itemCount: widget.state.params.stockAvailableList.options.length,
                itemBuilder: (context, index) => AddStockAvailableTile(
                  index: index + 1,
                  onDelete: widget.state.params.stockAvailableList.options.length < 2 ? null : _deleteTile,
                  refresh: widget.state._refresh,
                  returnedItem: widget.state.params.stockAvailableList.options[index],
                ),
              ),
            ),
          ),
          SizedBox(height: 12),
        ],
      ),
    );
  }

  void _addTile() {
    widget.state.params.stockAvailableList.options.add(StockAvailableItemModel.empty());
    widget.state._refresh();
  }

  void _deleteTile(StockAvailableItemModel model) {
    widget.state.params.stockAvailableList.options.removeWhere((e) => e == model);
    widget.state._refresh();
  }

  void _onItemSelected(CommonKeyValueModel? st) {
    widget.state.params.items.reset(st);
    widget.state._refresh();
  }

  // void _onPurchaseIDSelected(CommonKeyValueModel? st) {
  //   widget.state.params.purchaseId.reset(st);
  //   widget.state._refresh();
  // }

  Future<SearchApiResponseModel> _onItemSearch(SearchModel search) async {
    final response =
        await ItemService.getItemsList(searchKey: search.text, pageNumber: search.pageNumber, filter: null);

    return SearchApiResponseModel(
      response: response,
      items: response.data?.map((e) => CommonKeyValueModel(id: e.itemCode, value: e.name)).toList() ?? [],
      searchResultsFor: search.text,
    );
  }

  Future<SearchApiResponseModel> _onStockAvailableSearch(SearchModel search) async {
    final response =
        await StockAvailableService.getStockAvailableList(searchKey: search.text, pageNumber: search.pageNumber);

    return SearchApiResponseModel(
      response: response,
      items: response.data?.map((e) => CommonKeyValueModel(id: e.itemCode, value: e.itemName)).toList() ?? [],
      searchResultsFor: search.text,
    );
  }

  void _onQuantitySelected(CommonKeyValueModel? selected) {
    widget.state.params.unit.options;
    _refresh!();
  }

  void _refresh() => mounted ? setState(() {}) : null;
}
