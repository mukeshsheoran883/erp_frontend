import 'package:invently/assortment/widgets/svg_image.dart';
import 'package:invently/gen/assets.gen.dart';
import 'package:invently/models/common/common_id_value_model.dart';
import 'package:invently/models/purchase/stock_pending_transfer_model.dart';
import 'package:invently/network/branch_service.dart';
import 'package:invently/network/item_service.dart';
import 'package:invently/utils/theme/colors/colors.dart';
import 'package:invently/widgets/alert_dialog/api_search_drop_down.dart';
import 'package:invently/widgets/buttons/increment_decrement_buttons.dart';
import 'package:invently/widgets/form_widgets/search_selection_popup/search_popup_text_field.dart';
import 'package:invently/widgets/page_widgets/delete_button.dart';
import 'package:invently/widgets/page_widgets/list_tile_skeleton.dart';
import 'package:invently/widgets/text_widget/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddStockPendingTransferTile extends StatefulWidget {
  final StockPendingTransferItemModel stockPendingTransferItem;
  final void Function(StockPendingTransferItemModel)? onDelete;
  final void Function()? refresh;

  const AddStockPendingTransferTile({super.key, required this.stockPendingTransferItem, this.onDelete, this.refresh});

  @override
  State<AddStockPendingTransferTile> createState() => _AddStockPendingTransferTileState();
}

class _AddStockPendingTransferTileState extends State<AddStockPendingTransferTile> {
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
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 16,
              children: [
                Expanded(
                  child: SearchPopupTextField(
                    selected: widget.stockPendingTransferItem.item.value,
                    hint: 'Select item',
                    popupSubject: 'item',
                    onSelected: _onItemSelected,
                    onSearch: _onItemSearch,
                    error: widget.stockPendingTransferItem.item.error.errorMessage,
                  ),
                ),
                IncrementDecrementButton(
                  count: _parseNumber(widget.stockPendingTransferItem.qty.text),
                  onTap: _onIncreaseDecreaseTap,
                  error: widget.stockPendingTransferItem.qty.error.errorMessage,
                ),
                SizedBox(width: 28),
                DeleteButton(
                    onDelTap: widget.onDelete == null ? null : () => widget.onDelete!(widget.stockPendingTransferItem)),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 16,
              children: [
                Expanded(
                  child: SearchPopupTextField(
                    selected: widget.stockPendingTransferItem.branchFrom.value,
                    hint: 'From (Branch)',
                    popupSubject: 'From (Branch)',
                    onSelected: _onFromBranchSelected,
                    onSearch: _onFromBranchSearch,
                    error: widget.stockPendingTransferItem.branchFrom.error.errorMessage,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: SvgImage(Assets.icons.arrowRightLong, height: 25, width: 25, color: Tm.color(Tc.txtH3)),
                ),
                Expanded(
                  child: SearchPopupTextField(
                    selected: widget.stockPendingTransferItem.branchTo.value,
                    hint: 'To (Branch)',
                    popupSubject: 'To (Branch)',
                    onSelected: _onToBranchSelected,
                    onSearch: _onToBranchSearch,
                    error: widget.stockPendingTransferItem.branchTo.error.errorMessage,
                  ),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 16,
              children: [
                Flexible(
                  flex: 1,
                  child: TextFieldWithTitle(
                    title: 'Notes/Description',
                    required: true,
                    controller: widget.stockPendingTransferItem.description.controller,
                    error: widget.stockPendingTransferItem.description.error.errorMessage,
                    onChanged: (a) => {widget.stockPendingTransferItem.description.resetError(), _refresh()},
                    maxLen: 500,
                    maxLines: 3,
                    hint: '',
                    inputFormatters: [LengthLimitingTextInputFormatter(500)],
                  ),
                ),
              ],
            ),
          ],
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

  void _onItemSelected(CommonKeyValueModel? st) {
    widget.stockPendingTransferItem.item.reset(st);
    _refresh();
  }

  void _onToBranchSelected(CommonKeyValueModel? st) {
    widget.stockPendingTransferItem.branchTo.reset(st);
    _refresh();
  }

  void _onFromBranchSelected(CommonKeyValueModel? st) {
    widget.stockPendingTransferItem.branchFrom.reset(st);
    _refresh();
  }

  void _onIncreaseDecreaseTap(double p) {
    widget.stockPendingTransferItem.qty.reset(p.toString());
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

  Future<SearchApiResponseModel> _onToBranchSearch(SearchModel search) async {
    final response =
        await BranchService.getBranchList(searchKey: search.text, pageNumber: search.pageNumber, filter: null);

    return SearchApiResponseModel(
      response: response,
      items: response.data?.map((e) => CommonKeyValueModel(id: e.shopCode, value: e.name)).toList() ?? [],
      searchResultsFor: search.text,
    );
  }

  Future<SearchApiResponseModel> _onFromBranchSearch(SearchModel search) async {
    final response =
        await BranchService.getBranchList(searchKey: search.text, pageNumber: search.pageNumber, filter: null);

    return SearchApiResponseModel(
      response: response,
      items: response.data?.map((e) => CommonKeyValueModel(id: e.shopCode, value: e.name)).toList() ?? [],
      searchResultsFor: search.text,
    );
  }

  void _refresh() => mounted ? setState(() {}) : null;
}
