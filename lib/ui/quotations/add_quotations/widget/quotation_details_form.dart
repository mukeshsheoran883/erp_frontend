part of '../add_quotations_screen.dart';

class _QuotationDetailsForm extends StatelessWidget {
  final _AddEditQuotationsScreenState state;

  const _QuotationDetailsForm({required this.state});

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
                        items: state.params.supplier.options,
                        onSelected: _onSupplierSelected,
                        title: 'Supplier',
                        required: true,
                        selected: state.params.supplier.selected,
                        error: state.params.supplier.error.errorMessage,
                      ),
                    ),
                    const SizedBox(width: 24),
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
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: CustomDropdown(
                        items: state.params.brand.options,
                        onSelected: _onBrandSelected,
                        title: 'Brand',
                        required: true,
                        selected: state.params.brand.selected,
                        error: state.params.brand.error.errorMessage,
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: CustomDropdown(
                        items: state.params.organisation.options,
                        onSelected: _onOrganisationSelected,
                        title: 'Organisation',
                        required: true,
                        selected: state.params.organisation.selected,
                        error: state.params.organisation.error.errorMessage,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFieldWithTitle(
                        title: 'Quantity',
                        controller: state.params.quantity.controller,
                        required: true,
                        error: state.params.quantity.error.errorMessage,
                        onChanged: (a) => {state.params.quantity.resetError(), state._refresh()},
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: TextFieldWithTitle(
                        title: 'Price',
                        controller: state.params.price.controller,
                        required: true,
                        error: state.params.price.error.errorMessage,
                        onChanged: (a) => {state.params.price.resetError(), state._refresh()},
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: TextFieldWithTitle(
                        title: 'Tax',
                        controller: state.params.tax.controller,
                        required: true,
                        error: state.params.tax.error.errorMessage,
                        onChanged: (a) => {state.params.tax.resetError(), state._refresh()},
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 24,),
                TextFieldWithTitle(
                  title: 'Description',
                  controller: state.params.description.controller,
                  required: true,
                  error: state.params.description.error.errorMessage,
                  onChanged: (a) => {state.params.description.resetError(), state._refresh()},
                ),
                SizedBox(width: 24,),
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Text('Applicable for Purchase', style: Ts.rgRegular(color: Tm.color(Tc.dropItemDefTxt))),
                          const SizedBox(width: 12),
                          AdvancedSwitch(
                            width: 60,
                            initialValue: state.params.purchase.value ?? false,
                            onChanged: (value) {
                              state.params.purchase.reset(value);
                              state._refresh();
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: Row(
                        children: [
                          Text('Applicable for Sales', style: Ts.rgRegular(color: Tm.color(Tc.dropItemDefTxt))),
                          const SizedBox(width: 12),
                          AdvancedSwitch(
                            width: 60,
                            initialValue: state.params.sales.value ?? false,
                            onChanged: (value) {
                              state.params.sales.reset(value);
                              state._refresh();
                            },
                          ),
                        ],
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

  void _onSupplierSelected(CommonKeyValueModel? st) {
    state.params.supplier.reset(st);
    state._refresh();
  }

  void _onOrganisationSelected(CommonKeyValueModel? st) {
    state.params.organisation.reset(st);
    state._refresh();
  }

  void _onItemSelected(CommonKeyValueModel? st) {
    state.params.item.reset(st);
    state._refresh();
  }

  void _onBrandSelected(CommonKeyValueModel? st) {
    state.params.brand.reset(st);
    state._refresh();
  }
}