import 'package:invently/assortment/extensions/context_extensions.dart';
import 'package:invently/models/common/common_id_value_model.dart';
import 'package:invently/models/purchase/stock_available_model.dart';
import 'package:invently/network/branch_service.dart';
import 'package:invently/utils/theme/colors/colors.dart';
import 'package:invently/utils/theme/text_style/text_styles.dart';
import 'package:invently/widgets/alert_dialog/api_search_drop_down.dart';
import 'package:invently/widgets/buttons/increment_decrement_buttons.dart';
import 'package:invently/widgets/form_widgets/search_selection_popup/search_popup_text_field.dart';
import 'package:invently/widgets/page_widgets/delete_button.dart';
import 'package:invently/widgets/page_widgets/list_tile_skeleton.dart';
import 'package:flutter/material.dart';

class AddStockAvailableTile extends StatefulWidget {
  final int index;
  final StockAvailableItemModel returnedItem;
  final void Function(StockAvailableItemModel)? onDelete;
  final void Function()? refresh;

  const AddStockAvailableTile(
      {super.key, required this.returnedItem, this.onDelete, this.refresh, required this.index});

  @override
  State<AddStockAvailableTile> createState() => _AddStockAvailableTileState();
}

class _AddStockAvailableTileState extends State<AddStockAvailableTile> {
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
        padding: const EdgeInsets.only(top: 0, left: 20, right: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 16,
          children: [
            SizedBox(
              width: context.percentWidth * 2,
              child: Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Text.rich(
                  TextSpan(
                    text: widget.index < 10 ? '0${widget.index}' : widget.index.toString(),
                    style: Ts.xl2Medium(color: Tm.color(Tc.ipfTitle)),
                  ),
                ),
              ),
            ),
            Expanded(
              child: SearchPopupTextField(
                selected: widget.returnedItem.branch.value,
                hint: 'branch',
                popupSubject: 'branch',
                onSelected: _onItemSelected,
                onSearch: _onItemSearch,
                error: widget.returnedItem.branch.error.errorMessage,
              ),
            ),
            IncrementDecrementButton(
              count: _parseNumber(widget.returnedItem.qty.text),
              onTap: _onIncreaseDecreaseTap,
              error: widget.returnedItem.qty.error.errorMessage,
            ),
            SizedBox(width: 28),
            DeleteButton(onDelTap: widget.onDelete == null ? null : () => widget.onDelete!(widget.returnedItem)),
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
    widget.returnedItem.branch.reset(st);
    _refresh();
  }

  void _onIncreaseDecreaseTap(double p) {
    widget.returnedItem.qty.reset(p.toString());
    _refresh();
  }

  Future<SearchApiResponseModel> _onItemSearch(SearchModel search) async {
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
