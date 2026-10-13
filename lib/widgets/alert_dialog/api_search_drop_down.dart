
import 'package:invently/assortment/extensions/string_extensions.dart';
import 'package:invently/assortment/network/api_manager_models.dart';
import 'package:invently/assortment/status.dart';
import 'package:invently/assortment/widgets/button/hover_gesture_detector.dart';
import 'package:invently/assortment/widgets/error_loading_and_empty_widgets/custom_progress_indicator.dart';
import 'package:invently/assortment/widgets/error_loading_and_empty_widgets/empty_screen_widgets.dart';
import 'package:invently/assortment/widgets/error_loading_and_empty_widgets/error_retry_button.dart';
import 'package:invently/models/common/common_id_value_model.dart';
import 'package:invently/ui/splash/widgets/responsive_framework_builder.dart';
import 'package:invently/utils/globals.dart';
import 'package:invently/utils/theme/colors/colors.dart';
import 'package:invently/utils/theme/text_style/text_styles.dart';
import 'package:flutter/material.dart';

class ApiSearchDropDown extends StatefulWidget {
  final Widget Function(SearchDropParam) builder;
  final Function()? onOutSideTap;
  final Function(CommonKeyValueModel) onSearchResultTap;
  final ValueNotifier<SearchResponseModel> searchResult;

  const ApiSearchDropDown({
    super.key,
    required this.builder,
    this.onOutSideTap,
    required this.searchResult,
    required this.onSearchResultTap,
  });

  @override
  State<ApiSearchDropDown> createState() => _ApiSearchDropDownState();
}

class _ApiSearchDropDownState extends State<ApiSearchDropDown> {
  OverlayEntry? entry;

  late FocusNode node;

  LayerLink link = LayerLink();
  GlobalKey dropKey = GlobalKey();
  bool open = false;

  double width = 0;
  double height = 0;
  double xPos = 0;
  double yPos = 0;

  Duration animationDuration = const Duration(milliseconds: 150);

  bool _getDropDownPosition() {
    RenderBox? box = dropKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return false;
    width = box.size.width;
    height = box.size.height;
    Offset offset = box.localToGlobal(Offset.zero);
    yPos = offset.dy;
    xPos = offset.dx;

    return true;
  }

  @override
  void initState() {
    node = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _closeDropDown();
    node.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: link,
      child: widget.builder(
        SearchDropParam(
          context: context,
          isOpen: false,
          closeDropDown: _closeDropDown,
          openDropDown: _openDropDown,
          node: node,
          sizeKey: dropKey,
        ),
      ),
    );
  }

  Future<void> _openDropDown() async {
    bool success = _getDropDownPosition();
    if (!success || open) return;
    open = true;

    entry = OverlayEntry(
      builder: (context) {
        return ResponsiveFrameworkBuilder(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
              children: [
                GestureDetector(
                  onTap: () {
                    widget.onOutSideTap?.call();
                    _closeDropDown();
                  },
                  child: Container(color: Colors.transparent),
                ),
                CompositedTransformFollower(
                  link: link,
                  showWhenUnlinked: false,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      widget.builder(
                        SearchDropParam(
                          context: context,
                          isOpen: true,
                          closeDropDown: _closeDropDown,
                          openDropDown: _openDropDown,
                          node: node,
                          sizeKey: dropKey,
                        ),
                      ),
                      SizedBox(
                        width: width,
                        child: ValueListenableBuilder(
                          valueListenable: widget.searchResult,
                          builder: (context, value, c) {
                            return _DropDownContent(
                              onDispose: _closeDropDown,
                              searchResult: widget.searchResult,
                              onTap: widget.onSearchResultTap,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    Overlay.of(Globals.context()).insert(entry!);
    node.requestFocus();
  }

  void _closeDropDown() {
    if (entry != null && entry!.mounted) {
      open = false;

      try {
        entry?.remove();
      } catch (_) {}
    }
  }
}

class _DropDownContent extends StatefulWidget {
  final Function() onDispose;
  final Function(CommonKeyValueModel) onTap;
  final ValueNotifier<SearchResponseModel> searchResult;

  const _DropDownContent({required this.onDispose, required this.searchResult, required this.onTap});

  @override
  State<_DropDownContent> createState() => _DropDownContentState();
}

class _DropDownContentState extends State<_DropDownContent> {
  @override
  void dispose() {
    widget.onDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Tm.color(Tc.comBg)),
        color: Tm.color(Tc.ipfDef),
      ),
      height: 250,
      child: ValueListenableBuilder(
        valueListenable: widget.searchResult,
        builder: (context, value, child) {
          return value.status == Status.loading
              ? const CustomProgressIndicator()
              : value.status == Status.success && value.items.isEmpty
                  ? const ListEmptyWidget(imageSize: 90)
                  : value.status == Status.success
                      ? ListView.builder(
                          itemCount: value.items.length,
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          itemBuilder: (context, index) => _ItemTile(item: value.items[index], onTap: widget.onTap),
                        )
                      : ErrorWidgetWithButton(
                          onPressed: null,
                          error: value.error,
                          height: 0,
                          padding: 0,
                          imageSize: 135,
                        );
        },
      ),
    );
  }
}

class _ItemTile extends StatelessWidget {
  final CommonKeyValueModel item;
  final Function(CommonKeyValueModel) onTap;

  const _ItemTile({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
      child: HoverGD(
        onTap: () => onTap(item),
        borderRadius: const BorderRadius.all(Radius.circular(6)),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(6)),
            color: Tm.color(Tc.comCardBg),
          ),
          child: Text(
            item.value.toPascalCase(),
            style: TsDefined.ts16W600(color: Tm.color(Tc.ipfTitle)),
          ),
        ),
      ),
    );
  }
}

class SearchDropParam {
  BuildContext context;
  Function() openDropDown;
  Function() closeDropDown;
  bool isOpen;
  FocusNode node;
  GlobalKey sizeKey;

  SearchDropParam({
    required this.context,
    required this.openDropDown,
    required this.closeDropDown,
    required this.isOpen,
    required this.node,
    required this.sizeKey,
  });
}

class SearchResponseModel {
  Status status;
  String error;
  String searchResultsFor;
  List<CommonKeyValueModel> items;

  SearchResponseModel({required this.status, required this.error, required this.items, required this.searchResultsFor});
}

class SearchApiResponseModel {
  ApiResponseModel response;
  String searchResultsFor;
  List<CommonKeyValueModel> items;

  SearchApiResponseModel({required this.response, required this.items, required this.searchResultsFor});
}

class SearchModel {
  String text;
  int pageNumber;

  SearchModel({required this.text, this.pageNumber = 1});
}
