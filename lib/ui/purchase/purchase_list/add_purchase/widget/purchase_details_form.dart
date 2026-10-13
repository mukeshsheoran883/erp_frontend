part of '../add_purchase_screen.dart';

class _PurchaseDetailsForm extends StatefulWidget {
  final _AddEditPurchaseScreenState state;

  const _PurchaseDetailsForm({required this.state});

  @override
  State<_PurchaseDetailsForm> createState() => _PurchaseDetailsFormState();
}

class _PurchaseDetailsFormState extends State<_PurchaseDetailsForm> {
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
            PageHeaderTextField(
              hint: 'Purchase Bill Number',
              controller: widget.state.params.purchaseBillNumberField.controller,
              error: widget.state.params.purchaseBillNumberField.error.errorMessage,
              onChange: (a) => {widget.state.params.purchaseBillNumberField.resetError(), widget.state._refresh()},
            ),
            SizedBox(
              width: 300,
              child: SearchPopupTextField(
                selected: widget.state.params.supplier.selected,
                hint: 'Select Supplier',
                popupSubject: 'supplier',
                onSelected: _onSupplierSelected,
                onSearch: _onSupplierSearch,
                error: widget.state.params.supplier.error.errorMessage,
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
        Expanded(
          child: CustomScrollBar(
            controller: scrollController,
            child: ListView.builder(
              controller: scrollController,
              itemCount: widget.state.params.purchaseList.options.length,
              itemBuilder: (context, index) => AddPurchaseTile(
                purchase: widget.state.params.purchaseList.options[index],
                onDelete: widget.state.params.purchaseList.options.length < 2 ? null : _deleteTile,
                refresh: widget.state._refresh,
              ),
            ),
          ),
        ),
        SizedBox(height: 12),
      ],
    );
  }

  void _addTile() {
    widget.state.params.purchaseList.options.add(AddEditPurchaseModel.empty());
    widget.state._refresh();
  }

  void _deleteTile(AddEditPurchaseModel model) {
    widget.state.params.purchaseList.options.removeWhere((e) => e == model);
    widget.state._refresh();
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
