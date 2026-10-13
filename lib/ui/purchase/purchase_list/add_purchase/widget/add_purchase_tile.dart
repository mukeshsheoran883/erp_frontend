import 'package:invently/assortment/extensions/context_extensions.dart';
import 'package:invently/models/branch/branch_model.dart';
import 'package:invently/models/common/common_id_value_model.dart';
import 'package:invently/models/purchase/purchase_model.dart';
import 'package:invently/network/branch_service.dart';
import 'package:invently/network/employee_service.dart';
import 'package:invently/network/item_service.dart';
import 'package:invently/widgets/alert_dialog/api_search_drop_down.dart';
import 'package:invently/widgets/buttons/increment_decrement_buttons.dart';
import 'package:invently/widgets/custom_drop_down.dart';
import 'package:invently/widgets/date_time_picker/date_time_field.dart';
import 'package:invently/widgets/date_time_picker/date_time_picker.dart';
import 'package:invently/widgets/form_widgets/search_selection_popup/search_popup_text_field.dart';
import 'package:invently/widgets/page_widgets/delete_button.dart';
import 'package:invently/widgets/page_widgets/list_tile_skeleton.dart';
import 'package:invently/widgets/text_widget/price_text_field.dart';
import 'package:invently/widgets/text_widget/text_field.dart';
import 'package:flutter/material.dart';

class AddPurchaseTile extends StatefulWidget {
  final AddEditPurchaseModel purchase;
  final void Function(AddEditPurchaseModel)? onDelete;
  final void Function()? refresh;

  const AddPurchaseTile(
      {super.key, required this.purchase, this.onDelete, this.refresh});

  @override
  State<AddPurchaseTile> createState() => _AddPurchaseTileState();
}

class _AddPurchaseTileState extends State<AddPurchaseTile> {
  late TextEditingController itemTextController;

  @override
  void initState() {
    itemTextController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    itemTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListTileSkeletonRounded(
      child: Padding(
        padding:
            const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 16,
              children: [
                SizedBox(
                  width: context.percentWidth * 20,
                  child: SearchPopupTextField(
                    selected: widget.purchase.item.value,
                    hint: 'Select item',
                    popupSubject: 'item',
                    onSelected: _onItemSelected,
                    onSearch: _onItemSearch,
                    error: widget.purchase.item.error.errorMessage,
                  ),
                ),
                Flexible(
                  child: PriceTextField(
                    title: null,
                    controller: widget.purchase.buyingPrice.controller,
                    error: widget.purchase.buyingPrice.error.errorMessage,
                    onChange: (a) =>
                        {widget.purchase.buyingPrice.resetError(), _refresh()},
                    hint: 'Buying price',
                  ),
                ),
                Flexible(
                  child: PriceTextField(
                    title: null,
                    controller: widget.purchase.landingCost.controller,
                    error: widget.purchase.landingCost.error.errorMessage,
                    onChange: (a) =>
                        {widget.purchase.landingCost.resetError(), _refresh()},
                    hint: 'Landing cost',
                  ),
                ),
                Flexible(
                  child: PriceTextField(
                    title: null,
                    controller: widget.purchase.sellingPrice.controller,
                    error: widget.purchase.sellingPrice.error.errorMessage,
                    onChange: (a) =>
                        {widget.purchase.sellingPrice.resetError(), _refresh()},
                    hint: 'Selling price',
                  ),
                ),
                Expanded(
                  child: TextFieldWithTitle(
                    title: null,
                    hint: 'Tax%',
                    controller: widget.purchase.tax.controller,
                    required: true,
                    error: widget.purchase.tax.error.errorMessage,
                    onChanged: (a) =>
                        {widget.purchase.tax.resetError(), _refresh()},
                  ),
                ),
                Flexible(
                  child: CustomDateTimeField(
                    hint: 'Expiry Date',
                    title: null,
                    pickMode: DatePickMode.dateOnly,
                    error: widget.purchase.expiry.error.errorMessage,
                    initialDateTime: widget.purchase.expiry.dateTime,
                    onDateSelected: (a) =>
                        {widget.purchase.expiry.reset(a), _refresh()},
                  ),
                ),
                SizedBox(width: 28),
                IncrementDecrementButton(
                  count: _parseNumber(widget.purchase.quantity.text),
                  onTap: _onIncreaseDecreaseTap,
                  error: widget.purchase.quantity.error.errorMessage,
                ),
                Expanded(
                  child: CustomDropdown(
                    items: widget.purchase.units.options,
                    onSelected: _onQuantitySelected,
                    hintText: 'Unit',
                    selected: widget.purchase.units.selected,
                    error: widget.purchase.units.error.errorMessage,
                  ),
                ),
                SizedBox(width: 28),
                DeleteButton(
                    onDelTap: widget.onDelete == null
                        ? null
                        : () => widget.onDelete!(widget.purchase)),
              ],
            ),
            SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 16,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 8),
                      ...widget.purchase.branchSplits
                          .asMap()
                          .entries
                          .map((entry) {
                        final index = entry.key;
                        final split = entry.value;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            spacing: 12,
                            children: [
                              SizedBox(
                                width: 220,
                                child: SearchPopupTextField(
                                  title: 'Branch split',
                                  selected: split.branch.value,
                                  hint: 'Select branch',
                                  required: true,
                                  popupSubject: 'branch',
                                  onSelected: (st) =>
                                      _onBranchSelected(st, index),
                                  onSearch: _onBranchSearch,
                                  error: split.branch.error.errorMessage,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 28),
                                child: IncrementDecrementButton(
                                  count: _parseNumber(split.quantity.text),
                                  onTap: (p) => _onBranchQuantityTap(p, index),
                                  error: split.quantity.error.errorMessage,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.remove_circle_outline),
                                onPressed:
                                    widget.purchase.branchSplits.length < 2
                                        ? null
                                        : () => _removeBranchSplit(index),
                              ),
                              if (index ==
                                  widget.purchase.branchSplits.length - 1)
                                IconButton(
                                  icon: const Icon(Icons.add_circle_outline),
                                  onPressed: _addBranchSplit,
                                ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _onQuantitySelected(CommonKeyValueModel? selected) {
    widget.purchase.units.reset(selected);
    widget.refresh!();
  }

  double _parseNumber(String number) {
    try {
      return double.parse(number);
    } catch (_) {}

    return 0;
  }

  void _onItemSelected(CommonKeyValueModel? st) {
    widget.purchase.item.reset(st);
    _refresh();
  }

  void _onIncreaseDecreaseTap(double p) {
    widget.purchase.quantity.reset(p.toString());
    _refresh();
  }

  void _onBranchQuantityTap(double p, int index) {
    widget.purchase.branchSplits[index].quantity.reset(p.toString());
    _refresh();
  }

  Future<SearchApiResponseModel> _onItemSearch(SearchModel search) async {
    final response = await ItemService.getItemsList(
        searchKey: search.text, pageNumber: search.pageNumber, filter: null);

    return SearchApiResponseModel(
      response: response,
      items: response.data
              ?.map(
                (e) => CommonKeyValueModel(id: e.itemCode, value: e.name),
              )
              .toList() ??
          [],
      searchResultsFor: search.text,
    );
  }

  Future<SearchApiResponseModel> _onBranchSearch(SearchModel search) async {
    final response = await BranchService.getBranchList(
      searchKey: search.text,
      pageNumber: search.pageNumber,
      filter: null,
    );

    return SearchApiResponseModel(
      response: response,
      items: response.data
              ?.map((e) => CommonKeyValueModel(id: e.shopCode, value: e.name))
              .toList() ??
          [],
      searchResultsFor: search.text,
    );
  }

  void _onBranchSelected(CommonKeyValueModel? st, int index) {
    widget.purchase.branchSplits[index].branch.reset(st);
    _refresh();
  }

  void _addBranchSplit() {
    widget.purchase.branchSplits.add(BranchSplitEntry.empty());
    _refresh();
  }

  void _removeBranchSplit(int index) {
    widget.purchase.branchSplits.removeAt(index);
    _refresh();
  }

  void _refresh() => mounted ? setState(() {}) : null;
}
