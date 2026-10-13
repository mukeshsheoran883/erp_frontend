import 'package:invently/assortment/extensions/context_extensions.dart';
import 'package:invently/models/common/common_id_value_model.dart';
import 'package:invently/models/purchase/returned_purchases_model.dart';
import 'package:invently/network/item_service.dart';
import 'package:invently/widgets/alert_dialog/api_search_drop_down.dart';
import 'package:invently/widgets/buttons/increment_decrement_buttons.dart';
import 'package:invently/widgets/form_widgets/search_selection_popup/search_popup_text_field.dart';
import 'package:invently/widgets/page_widgets/delete_button.dart';
import 'package:invently/widgets/page_widgets/list_tile_skeleton.dart';
import 'package:invently/widgets/text_widget/price_text_field.dart';
import 'package:invently/widgets/text_widget/text_field.dart';
import 'package:flutter/material.dart';

class AddReturnedPurchaseTile extends StatefulWidget {
  final ReturnedItem returnedItem;
  final void Function(ReturnedItem)? onDelete;
  final void Function()? refresh;

  const AddReturnedPurchaseTile({super.key, required this.returnedItem, this.onDelete, this.refresh});

  @override
  State<AddReturnedPurchaseTile> createState() => _AddReturnedPurchaseTileState();
}

class _AddReturnedPurchaseTileState extends State<AddReturnedPurchaseTile> {
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
        padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 16,
          children: [
            SizedBox(
              width: context.percentWidth * 20,
              child: SearchPopupTextField(
                selected: widget.returnedItem.item.value,
                hint: 'Select item',
                popupSubject: 'item',
                onSelected: _onItemSelected,
                onSearch: _onItemSearch,
                error: widget.returnedItem.item.error.errorMessage,
              ),
            ),
            IncrementDecrementButton(
              count: _parseNumber(widget.returnedItem.qty.text),
              onTap: _onIncreaseDecreaseTap,
              error: widget.returnedItem.qty.error.errorMessage,
            ),
            Flexible(
              child: TextFieldWithTitle(
                title: null,
                controller: widget.returnedItem.tax.controller,
                error: widget.returnedItem.tax.error.errorMessage,
                onChanged: (a) => {widget.returnedItem.tax.resetError(), _refresh()},
                hint: 'Tax',
              ),
            ),
            Flexible(
              child: TextFieldWithTitle(
                title: null,
                controller: widget.returnedItem.label.controller,
                error: widget.returnedItem.label.error.errorMessage,
                hint: 'Label',
              ),
            ),
            Flexible(
              child: PriceTextField(
                title: null,
                controller: widget.returnedItem.totalPrice.controller,
                error: widget.returnedItem.totalPrice.error.errorMessage,
                hint: 'Total Price',
              ),
            ),
            SizedBox(width: 28),
            SizedBox(width: 28),
            DeleteButton(onDelTap: widget.onDelete == null ? null : () => widget.onDelete!(widget.returnedItem)),
          ],
        ),
      ),
    );
  }

  // void _onQuantitySelected(CommonKeyValueModel? selected) {
  //   widget.returnedItem.units.reset(selected);
  //   widget.refresh!();
  // }

  double _parseNumber(String number) {
    try {
      return double.parse(number);
    } catch (_) {}

    return 0;
  }

  void _onItemSelected(CommonKeyValueModel? st) {
    widget.returnedItem.item.reset(st);
    _refresh();
  }

  void _onIncreaseDecreaseTap(double p) {
    widget.returnedItem.qty.reset(p.toString());
    _refresh();
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

  void _refresh() => mounted ? setState(() {}) : null;
}
