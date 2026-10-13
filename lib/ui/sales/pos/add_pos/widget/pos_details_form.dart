part of '../add_pos_screen.dart';

class _PosDetailsForm extends StatefulWidget {
  final _AddEditPosScreenState state;

  const _PosDetailsForm({required this.state});

  @override
  State<_PosDetailsForm> createState() => _PosDetailsFormState();
}

class _PosDetailsFormState extends State<_PosDetailsForm> {
  _AddEditPosScreenState get state => widget.state;

  @override
  Widget build(BuildContext context) {
    // NEW: compute grand total across all items for the summary card at the bottom
    double grandSubtotal = 0;
    double grandTax = 0;
    double grandDiscount = 0;

    for (final item in state.params.items) {
      final qty = _parseNumber(item.quantity.text);
      final price = _parseNumber(item.price.text);
      final tax = _parseNumber(item.tax.text);
      final discount = _parseNumber(item.discount.text);

      grandSubtotal += qty * price;
      grandTax += qty * price * tax / 100;
      grandDiscount += discount;
    }

    final grandTotal = grandSubtotal + grandTax - grandDiscount;

    return Center(
      child: SingleChildScrollView(
        child: SizedBox(
          width: StaticValues.formWidth(),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: SearchPopupTextField(
                        selected: state.params.customer.value,
                        hint: 'Select customer',
                        popupSubject: 'customer',
                        title: 'Customer',
                        required: true,
                        onSelected: _onCustomerSelected,
                        onSearch: _onCustomerSearch,
                        error: state.params.customer.error.errorMessage,
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: CustomDropdown(
                        items: state.params.shop.options,
                        onSelected: _onShopSelected,
                        title: 'Shop',
                        required: true,
                        selected: state.params.shop.selected,
                        error: state.params.shop.error.errorMessage,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Items',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                ),
                const SizedBox(height: 8),
                ...state.params.items.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;

                  final qty = _parseNumber(item.quantity.text);
                  final price = _parseNumber(item.price.text);
                  final tax = _parseNumber(item.tax.text);
                  final discount = _parseNumber(item.discount.text);
                  final lineTotal =
                      (qty * price) + (qty * price * tax / 100) - discount;

                  final itemLabel = item.item.value?.value ?? '';

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Column(
                      children: [
                        Row(
                          spacing: 12,
                          children: [
                            Expanded(
                              flex: 2,
                              child: SearchPopupTextField(
                                selected: item.item.value,
                                hint: 'Select item',
                                popupSubject: 'item',
                                onSelected: (st) => _onItemSelected(st, index),
                                onSearch: _onItemSearch,
                                error: item.item.error.errorMessage,
                              ),
                            ),
                            IncrementDecrementButton(
                              count: qty,
                              onTap: (p) => _onQuantityTap(p, index),
                              error: item.quantity.error.errorMessage,
                            ),
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline),
                              onPressed: state.params.items.length < 2
                                  ? null
                                  : () => _removeItem(index),
                            ),
                            if (index == state.params.items.length - 1)
                              IconButton(
                                icon: const Icon(Icons.add_circle_outline),
                                onPressed: _addItem,
                              ),
                          ],
                        ),
                        Row(
                          spacing: 12,
                          children: [
                            Expanded(
                              child: PriceTextField(
                                title: null,
                                controller: item.price.controller,
                                error: item.price.error.errorMessage,
                                onChange: (a) =>
                                {item.price.resetError(), state._refresh()},
                                hint: 'Price',
                              ),
                            ),
                            Expanded(
                              child: PriceTextField(
                                title: null,
                                controller: item.tax.controller,
                                error: item.tax.error.errorMessage,
                                onChange: (a) =>
                                {item.tax.resetError(), state._refresh()},
                                hint: 'Tax',
                              ),
                            ),
                            Expanded(
                              child: PriceTextField(
                                title: null,
                                readOnly: false,
                                controller: item.discount.controller,
                                error: item.discount.error.errorMessage,
                                onChange: (a) => {
                                  item.discount.resetError(),
                                  state._refresh(),
                                },
                                hint: 'Discount',
                              ),
                            ),
                          ],
                        ),
                        // CHANGED: full line-item detail (name, qty, price → line total)
                        // instead of just a bare "Total: X" text
                        if (itemLabel.isNotEmpty)
                          Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                '$itemLabel  ×${qty.toStringAsFixed(qty % 1 == 0 ? 0 : 2)} '
                                    '@ ${StaticValues.currencySymbol(price.toStringAsFixed(2))} '
                                    '= ${StaticValues.currencySymbol(lineTotal.toStringAsFixed(2))}',
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                }),

                // NEW: order summary card — sits right above the Save/Cancel buttons
                // (buttons live in the parent screen, right below this scrollable form)
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Order Summary',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      _summaryRow('Subtotal', grandSubtotal),
                      _summaryRow('Tax', grandTax),
                      _summaryRow('Discount', -grandDiscount),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Divider(height: 1),
                      ),
                      _summaryRow('Grand Total', grandTotal, isTotal: true),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // NEW: reusable row for the summary card
  Widget _summaryRow(String label, double amount, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.w700 : FontWeight.w400,
            ),
          ),
          Text(
            StaticValues.currencySymbol(amount.toStringAsFixed(2)),
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.w700 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  double _parseNumber(String number) {
    try {
      return double.parse(number);
    } catch (_) {}
    return 0;
  }

  void _onCustomerSelected(CommonKeyValueModel? st) {
    state.params.customer.reset(st);
    state._refresh();
  }

  Future<SearchApiResponseModel> _onCustomerSearch(SearchModel search) async {
    final response = await CustomerService.getCustomerList(
        pageNumber: search.pageNumber, searchKey: search.text, filter: null);

    return SearchApiResponseModel(
      response: response,
      items: response.data
          ?.map(
              (e) => CommonKeyValueModel(id: e.customerCode, value: e.name))
          .toList() ??
          [],
      searchResultsFor: search.text,
    );
  }

  void _onShopSelected(CommonKeyValueModel? st) {
    state.params.shop.reset(st);
    state._refresh();
  }

  Future<SearchApiResponseModel> _onQuotationSearch(SearchModel search) async {
    final response = await CustomerQuotationService.getCustomerQuotationList(
        searchKey: search.text, filter: null, pageNumber: search.pageNumber);

    return SearchApiResponseModel(
      response: response,
      items: response.data
          ?.map((e) => CommonKeyValueModel(
          id: e.customerQuotationCode, value: e.customerQuotationCode))
          .toList() ??
          [],
      searchResultsFor: search.text,
    );
  }

  // NEW: auto-fill price from the cached item on selection
  void _onItemSelected(CommonKeyValueModel? st, int index) {
    state.params.items[index].item.reset(st);

    if (st != null) {
      final cachedItem = _AddEditPosScreenState.itemCache[st.id];
      if (cachedItem != null) {
        state.params.items[index].price.controller.text =
            cachedItem.plainPrice.toString();
        state.params.items[index].price.resetError();
        // NOTE: ItemModel has no numeric tax rate field (only taxCode/taxName),
        // so tax can't be auto-filled unless the backend adds a tax percentage.
      }
    } else {
      state.params.items[index].price.controller.text = '';
    }

    state._refresh();
  }

  void _onQuantityTap(double p, int index) {
    state.params.items[index].quantity.reset(p.toInt().toString());
    state._refresh();
  }

  void _addItem() {
    state.params.items.add(PosItemEntry.empty());
    state._refresh();
  }

  void _removeItem(int index) {
    state.params.items.removeAt(index);
    state._refresh();
  }

  // NEW: caches full item objects for later auto-fill on selection
  Future<SearchApiResponseModel> _onItemSearch(SearchModel search) async {
    final response = await ItemService.getItemsList(
        searchKey: search.text, pageNumber: search.pageNumber, filter: null);

    if (response.data != null) {
      for (final it in response.data!) {
        _AddEditPosScreenState.itemCache[it.itemCode] = it;
      }
    }

    return SearchApiResponseModel(
      response: response,
      items: response.data
          ?.map(
            (e) => CommonKeyValueModel(
            id: e.itemCode, value: '${e.name} (${e.itemCode})'),
      )
          .toList() ??
          [],
      searchResultsFor: search.text,
    );
  }
}