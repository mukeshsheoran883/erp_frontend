part of '../add_customer_quotation_screen.dart';

class _CustomerQuotationDetailsForm extends StatefulWidget {
  final _AddEditCustomerQuotationsScreenState state;

  const _CustomerQuotationDetailsForm({required this.state});

  @override
  State<_CustomerQuotationDetailsForm> createState() => _CustomerQuotationDetailsFormState();
}

class _CustomerQuotationDetailsFormState extends State<_CustomerQuotationDetailsForm> {
  _AddEditCustomerQuotationsScreenState get state => widget.state;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: SizedBox(
          width: StaticValues.formWidth(),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 16),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
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

                    const SizedBox(width: 32),
                    Flexible(
                      child: TextFieldWithTitle(
                        title: 'Customer Phone',
                        controller: state.params.customerPhone.controller,
                        required: true,
                        readOnly: true, // auto-filled from customer selection
                        error: state.params.customerPhone.error.errorMessage,
                        onChanged: (a) => {state.params.customerPhone.resetError(), state._refresh()},
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Flexible(
                      child: TextFieldWithTitle(
                        title: 'Customer Email',
                        controller: state.params.customerEmail.controller,
                        required: false,
                        readOnly: true, // auto-filled from customer selection
                        error: state.params.customerEmail.error.errorMessage,
                        onChanged: (a) => {state.params.customerEmail.resetError(), state._refresh()},
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
                  child: Text('Items', style: TextStyle(fontWeight: FontWeight.w600)),
                ),
                const SizedBox(height: 8),
                ...state.params.items.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      spacing: 12,
                      children: [
                        Expanded(
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
                          count: _parseNumber(item.quantity.text),
                          onTap: (p) => _onQuantityTap(p, index),
                          error: item.quantity.error.errorMessage,
                        ),
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline),
                          onPressed: state.params.items.length < 2 ? null : () => _removeItem(index),
                        ),
                        if (index == state.params.items.length - 1)
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline),
                            onPressed: _addItem,
                          ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  double _parseNumber(String number) {
    try {
      return double.parse(number);
    } catch (_) {}
    return 0;
  }

  // NEW: fills name/phone/email when a customer is selected
  void _onCustomerSelected(CommonKeyValueModel? st) {
    state.params.customer.reset(st);

    if (st != null) {
      final customer = _AddEditCustomerQuotationsScreenState.customerCache[st.id];
      if (customer != null) {
        state.params.customerName.reset(customer.name);
        state.params.customerPhone.reset(customer.mobileNumber);
        state.params.customerEmail.reset(customer.emailId);
        state.params.customerName.resetError();
        state.params.customerPhone.resetError();
        state.params.customerEmail.resetError();
      }
    } else {
      state.params.customerName.reset('');
      state.params.customerPhone.reset('');
      state.params.customerEmail.reset('');
    }

    state._refresh();
  }

  void _onShopSelected(CommonKeyValueModel? st) {
    state.params.shop.reset(st);
    state._refresh();
  }

  void _onItemSelected(CommonKeyValueModel? st, int index) {
    state.params.items[index].item.reset(st);
    state._refresh();
  }

  void _onQuantityTap(double p, int index) {
    state.params.items[index].quantity.reset(p.toInt().toString());
    state._refresh();
  }

  void _addItem() {
    state.params.items.add(CustomerQuotationItemEntry.empty());
    state._refresh();
  }

  void _removeItem(int index) {
    state.params.items.removeAt(index);
    state._refresh();
  }

  Future<SearchApiResponseModel> _onItemSearch(SearchModel search) async {
    final response = await ItemService.getItemsList(searchKey: search.text, pageNumber: search.pageNumber, filter: null);

    return SearchApiResponseModel(
      response: response,
      items: response.data?.map((e) => CommonKeyValueModel(id: e.itemCode, value: '${e.name} (${e.skuCode})')).toList() ?? [],
      searchResultsFor: search.text,
    );
  }
}