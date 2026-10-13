part of '../add_return_item_screen.dart';

class _ReturnDetailsForm extends StatefulWidget {
  final _AddEditReturnItemScreenState state;

  const _ReturnDetailsForm({required this.state});

  @override
  State<_ReturnDetailsForm> createState() => _ReturnDetailsFormState();
}

class _ReturnDetailsFormState extends State<_ReturnDetailsForm> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PageHeaderContainer(
          widgets: [
            PageHeaderTextField(
              hint: 'Purchase Bill Number',
              controller: widget.state.params.purchaseBillNumberField.controller,
              error: widget.state.params.purchaseBillNumberField.error.errorMessage,
              onChange: (a) => {widget.state.params.purchaseBillNumberField.resetError(), widget.state._refresh()},
            ),
            SizedBox(
              width: 260,
              child: SearchPopupTextField(
                selected: widget.state.params.supplier.selected,
                hint: 'Select Supplier',
                popupSubject: 'supplier',
                onSelected: _onSupplierSelected,
                onSearch: _onSupplierSearch,
                error: widget.state.params.supplier.error.errorMessage,
              ),
            ),
            Spacer(),
            PageHeaderButton(
              label: 'Close',
              onTap: () => _onCloseTap(widget.state),
              icon: Assets.icons.closeSquare,
              buttonColor: Tm.color(Tc.neuDef),
              textColor: Tm.color(Tc.neuNeuBtnTxt),
            ),
            PageHeaderButton(label: 'Save', onTap: () => _onSaveTap(widget.state), icon: Assets.icons.checkSquare),
          ],
        ),
        SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 16,
            children: [
              SizedBox(
                width: 240,
                child: SearchPopupTextField(
                  selected: widget.state.params.item.value,
                  hint: 'Select item',
                  popupSubject: 'item',
                  onSelected: _onItemSelected,
                  onSearch: _onItemSearch,
                  error: widget.state.params.item.error.errorMessage,
                ),
              ),
              Flexible(
                child: PriceTextField(
                  title: null,
                  controller: widget.state.params.price.controller,
                  error: widget.state.params.price.error.errorMessage,
                  onChange: (a) => {widget.state.params.price.resetError(), widget.state._refresh()},
                  hint: 'Price',
                ),
              ),
              Flexible(
                child: PriceTextField(
                  title: null,
                  controller: widget.state.params.tax.controller,
                  error: widget.state.params.tax.error.errorMessage,
                  onChange: (a) => {widget.state.params.tax.resetError(), widget.state._refresh()},
                  hint: 'Tax',
                ),
              ),
              IncrementDecrementButton(
                count: _parseNumber(widget.state.params.quantity.text),
                onTap: _onQuantityTap,
                error: widget.state.params.quantity.error.errorMessage,
              ),
            ],
          ),
        ),
        SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: TextFieldWithTitle(
            title: null,
            hint: 'Return reason',
            controller: widget.state.params.returnReason.controller,
            required: true,
            error: widget.state.params.returnReason.error.errorMessage,
            onChanged: (a) => {widget.state.params.returnReason.resetError(), widget.state._refresh()},
          ),
        ),
        SizedBox(height: 12),
      ],
    );
  }

  double _parseNumber(String number) {
    try {
      return double.parse(number);
    } catch (_) {}
    return 0;
  }

  void _onQuantityTap(double p) {
    widget.state.params.quantity.reset(p.toString());
    widget.state._refresh();
  }

  void _onItemSelected(CommonKeyValueModel? st) {
    widget.state.params.item.reset(st);
    widget.state._refresh();
  }


  Future<SearchApiResponseModel> _onItemSearch(SearchModel search) async {
    final response =
     await ItemService.getItemsList(
        searchKey: search.text, pageNumber: search.pageNumber, filter: null,);
    return SearchApiResponseModel(
      response: response,
      items: response.data?.map((e) => CommonKeyValueModel(id: e.itemCode, value: e.name)).toList() ?? [],
      searchResultsFor: search.text,
    );
  }

  void _onSupplierSelected(CommonKeyValueModel? st) {
    widget.state.params.supplier.reset(st);
    widget.state._refresh();
  }

  Future<SearchApiResponseModel> _onSupplierSearch(SearchModel search) async {
    final response =
    await SupplierService.getAllSupplierList();

    return SearchApiResponseModel(
      response: response,
      items: response.data?.map((e) => CommonKeyValueModel(id: e.supplierCode, value: e.name)).toList() ?? [],
      searchResultsFor: search.text,
    );
  }
}