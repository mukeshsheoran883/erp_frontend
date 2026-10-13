part of '../add_inventory_screen.dart';

class _InventoryDetailsForm extends StatelessWidget {
  final _AddEditInventoryScreenState state;

  const _InventoryDetailsForm({required this.state});

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
                Row(
                  children: [
                    Expanded(
                      child: CustomDropdown(
                        items: state.params.item.options,
                        onSelected: _onItemSelected,
                        title: 'Item',
                        required: true,
                        selected: state.params.item.selected,
                        error: state.params.item.error.errorMessage,
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
                Row(
                  children: [
                    Expanded(
                      child: CustomDateTimeField(
                        title: 'Expiry Date',
                        required: true,
                        pickMode: DatePickMode.dateOnly,
                        error: state.params.expiryDate.error.errorMessage,
                        initialDateTime: state.params.expiryDate.dateTime,
                        onDateSelected: (a) => {
                          state.params.expiryDate.reset(a),
                          state._refresh()
                        },
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: PriceTextField(
                        title: 'Price',
                        removeAllProps: false,
                        controller: state.params.price.controller,
                        error: state.params.price.error.errorMessage,
                        onChange: (a) =>
                            {state.params.price.resetError(), state._refresh()},
                        hint: 'Price',
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: PriceTextField(
                        removeAllProps: false,
                        title: 'Balance Quantity',
                        controller: state.params.balanceQty.controller,
                        error: state.params.balanceQty.error.errorMessage,
                        onChange: (a) => {
                          state.params.balanceQty.resetError(),
                          state._refresh()
                        },
                        hint: 'Balance Qty',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onItemSelected(CommonKeyValueModel? st) {
    state.params.item.reset(st);
    state._refresh();
  }

  void _onShopSelected(CommonKeyValueModel? st) {
    state.params.shop.reset(st);
    state._refresh();
  }
}
