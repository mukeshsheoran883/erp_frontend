import 'dart:async';

import 'package:invently/assortment/extensions/context_extensions.dart';
import 'package:invently/assortment/extensions/string_extensions.dart';
import 'package:invently/assortment/network/api_manager_models.dart';
import 'package:invently/assortment/services/navigation_service/navigation_service.dart';
import 'package:invently/assortment/status.dart';
import 'package:invently/assortment/widgets/button/hover_button_base.dart';
import 'package:invently/assortment/widgets/button/hover_gesture_detector.dart';
import 'package:invently/assortment/widgets/error_loading_and_empty_widgets/custom_progress_indicator.dart';
import 'package:invently/assortment/widgets/error_loading_and_empty_widgets/empty_screen_widgets.dart';
import 'package:invently/assortment/widgets/error_loading_and_empty_widgets/error_retry_button.dart';
import 'package:invently/assortment/widgets/svg_image.dart';
import 'package:invently/gen/assets.gen.dart';
import 'package:invently/models/common/common_id_value_model.dart';
import 'package:invently/utils/common_functions.dart';
import 'package:invently/utils/theme/colors/colors.dart';
import 'package:invently/widgets/alert_dialog/alert_bottom_buttons.dart';
import 'package:invently/widgets/alert_dialog/alert_title_bar.dart';
import 'package:invently/widgets/alert_dialog/api_search_drop_down.dart';
import 'package:invently/widgets/form_widgets/search_selection_popup/popup_item_tile.dart';
import 'package:invently/widgets/page_widgets/custom_scroll_bar.dart';
import 'package:invently/widgets/page_widgets/pagination_number_row.dart';
import 'package:invently/widgets/text_widget/text_field.dart';
import 'package:flutter/material.dart';

class PopupBody extends StatefulWidget {
  final String title;
  final CommonKeyValueModel? selected;
  final Function(CommonKeyValueModel?) onClose;
  final Future<SearchApiResponseModel> Function(SearchModel) onSearch;

  const PopupBody({super.key, required this.title, this.selected, required this.onClose, required this.onSearch});

  @override
  State<PopupBody> createState() => _PopupBodyState();
}

class _PopupBodyState extends State<PopupBody> {
  late TextEditingController controller;
  late ScrollController scrollController;
  List<CommonKeyValueModel> items = [];
  CommonKeyValueModel? tempSelected;
  Status apiStatus = Status.none;
  late FocusNode fNode;
  ApiResponseModel? apiResponse;
  SearchApiResponseModel? searchResponse;

  Timer? _debounce;
  int _currentSearchId = 0;

  @override
  void initState() {
    if (widget.selected != null) {
      tempSelected = CommonKeyValueModel(id: widget.selected!.id, value: widget.selected!.value);
    }
    fNode = FocusNode();
    fNode.addListener(() => CommonFunctions.removeTextSelection(controller));
    controller = TextEditingController(text: tempSelected?.value);
    scrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((a) {
      _fetchApi(1);
      fNode.requestFocus();
    });
    super.initState();
  }

  void _onTextChanged(String text) {
    if (text.trim().isEmpty && (searchResponse?.searchResultsFor ?? '').isEmpty) return;

    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      _fetchApi(1);
    });
  }

  @override
  void dispose() {
    fNode.dispose();
    controller.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Tm.color(Tc.comCardBg),
      width: context.percentWidth * 44,
      height: 650,
      child: Column(
        children: [
          AlertDialogTitleBar(
            title: 'Select ${widget.title.toFirstLetterUpperCase()}',
            bottomHeight: 18,
            onCloseTap: () => _onClose(widget.selected),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 24, right: 24, bottom: 8),
            child: TextFieldWithTitle(
              controller: controller,
              title: '',
              hint: 'Search ${widget.title}',
              removeAllProps: true,
              autoFocus: false,
              focusNode: fNode,
              borderColor: Tm.color(Tc.tabDefTxt),
              paddingContent: 12,
              onChanged: _onTextChanged,
              suffixIcon: HoverGD(
                onTap: controller.text.isEmpty ? null : _onClearTap,
                builder: (context, bState) {
                  return Container(
                    width: 12,
                    height: 12,
                    alignment: Alignment.center,
                    child: SvgImage(
                      controller.text.isEmpty ? Assets.icons.lens : Assets.icons.close,
                      color: controller.text.isEmpty
                          ? Tm.color(Tc.tabDefTxt)
                          : Tm.color(bState.isHovering ? Tc.closeRed : Tc.tabDefTxt),
                    ),
                  );
                },
              ),
            ),
          ),
          Expanded(
            child: apiStatus == Status.loading
                ? CustomProgressIndicator()
                : apiStatus == Status.success
                    ? items.isEmpty
                        ? ListEmptyWidget(imageSize: 80, text: 'No ${widget.title.toLowerCase()} found')
                        : Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: CustomScrollBar(
                              controller: scrollController,
                              child: ListView.builder(
                                controller: scrollController,
                                itemCount: items.length,
                                itemBuilder: (context, index) =>
                                    PopupItemTile(item: items[index], onTap: _onTap, selected: tempSelected),
                              ),
                            ),
                          )
                    : ErrorWidgetWithButton(
                        error: apiResponse?.firstError(),
                        onPressed: () => _fetchApi(apiResponse?.currentPage ?? 1),
                        imageSize: 200,
                      ),
          ),
          if (apiResponse != null && apiStatus == Status.success)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
              child: PaginationNumberRow(
                selectedPage: apiResponse!.currentPage,
                totalPage: apiResponse!.totalPage,
                showingCount: items.length,
                totalCount: apiResponse!.totalCount,
                onPageTap: (a) => _fetchApi(a),
                selectedCount: 0,
              ),
            ),
          AlertBottomButton(
            showUpperPadding: false,
            leftText: 'Close',
            rightText: 'Select',
            onLeftTap: () => _onClose(widget.selected),
            onRightTap: () => _onClose(tempSelected),
          ),
        ],
      ),
    );
  }

  void _onClose(CommonKeyValueModel? m) {
    widget.onClose(m);
    AppNavigator.pop();
  }

  Future<void> _fetchApi(int pageNumber) async {
    final int searchId = ++_currentSearchId;
    apiStatus = Status.loading;
    apiResponse = null;
    _refresh();

    searchResponse = await widget.onSearch(SearchModel(text: controller.text.trim(), pageNumber: pageNumber));
    if (searchId == _currentSearchId) {
      apiStatus = searchResponse!.response.isSuccess() ? Status.success : Status.error;
      items = searchResponse!.items;
      apiResponse = searchResponse!.response;
    }

    _refresh();
  }

  void _refresh() => mounted ? setState(() {}) : null;

  void _onClearTap() {
    tempSelected = null;
    controller.text = '';
    _refresh();
    _fetchApi(1);
  }

  void _onTap(CommonKeyValueModel? item) {
    tempSelected = tempSelected?.id == item?.id ? null : item;
    _refresh();
  }
}
