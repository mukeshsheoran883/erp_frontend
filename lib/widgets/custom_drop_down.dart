
import 'package:invently/assortment/extensions/context_extensions.dart';
import 'package:invently/assortment/future_handler/full_screen_overlay.dart';
import 'package:invently/assortment/widgets/button/hover_button_base.dart';
import 'package:invently/assortment/widgets/button/hover_gesture_detector.dart';
import 'package:invently/assortment/widgets/svg_image.dart';
import 'package:invently/gen/assets.gen.dart';
import 'package:invently/models/common/common_id_value_model.dart';
import 'package:invently/utils/theme/colors/colors.dart';
import 'package:invently/utils/theme/text_style/text_styles.dart';
import 'package:invently/widgets/page_widgets/custom_scroll_bar.dart';
import 'package:invently/widgets/text_widget/text_field.dart';
import 'package:flutter/material.dart';

class CustomDropdown extends StatefulWidget {
  final String? hintText;
  final String? title;
  final CommonKeyValueModel? selected;
  final ValueNotifier<List<CommonKeyValueModel>> items;
  final Color? dropBgColor;
  final Widget? buttonWidget;
  final double? dropWidth;
  final Function(CommonKeyValueModel?) onSelected;
  final Function()? onClearTap;
  final bool required;
  final bool removeAllProps;
  final String? error;
  final String emptyMessage;
  final TextEditingController? searchController;

  const CustomDropdown({
    super.key,
    required this.items,
    required this.onSelected,
    this.hintText,
    this.emptyMessage = 'No items found',
    this.selected,
    this.title,
    this.buttonWidget,
    this.dropBgColor,
    this.dropWidth,
    this.required = false,
    this.removeAllProps = false,
    this.error,
    this.searchController,
    this.onClearTap,
  });

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  FullScreenBanner fullScreenBanner = FullScreenBanner();
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

  late TextEditingController controller;

  LayerLink layerLink = LayerLink();

  @override
  void initState() {
    controller = TextEditingController(text: widget.selected?.value);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant CustomDropdown oldWidget) {
    controller.text = widget.selected?.value ?? '';
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.buttonWidget != null) {
      return HoverGD(
        onTap: _onDropdownTap,
        key: dropKey,
        child: widget.buttonWidget!,
      );
    }

    return CompositedTransformTarget(
      link: layerLink,
      child: TextFieldWithTitle(
        key: dropKey,
        title: widget.title,
        hint: widget.hintText,
        required: widget.required,
        error: widget.error,
        controller: controller,
        removeAllProps: widget.removeAllProps,
        enableSelection: false,
        onTap: _onDropdownTap,
        readOnly: true,
        suffixIcon: HoverGD(
          onTap: widget.selected == null ? null : () => widget.onSelected(null),
          builder: (context, bState) {
            return AnimatedRotation(
              duration: animationDuration,
              turns: open ? -0.25 : 0,
              child: Container(
                width: 12,
                height: 12,
                alignment: Alignment.center,
                child: SvgImage(
                  widget.selected == null ? Assets.icons.arrowDown : Assets.icons.close,
                  color: widget.selected == null
                      ? Tm.color(Tc.tabDefTxt)
                      : Tm.color(bState.isHovering ? Tc.closeRed : Tc.tabDefTxt),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _onDropdownTap() async {
    bool success = _getDropDownPosition();
    if (!success) return;

    open = true;
    setState(() {});

    double? prevX;
    double? prevY;

    await fullScreenBanner.show(
      widget: CompositedTransformFollower(
        link: layerLink,
        showWhenUnlinked: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Get the current position
            double currentX = constraints.biggest.width;
            double currentY = constraints.biggest.height;

            if ((currentX != prevX || currentY != prevY) && prevY != null) {
              _close();
            }

            prevX = currentX;
            prevY = currentY;

            return Padding(
              padding: EdgeInsets.only(top: height - (widget.removeAllProps ? 0 : 26)),
              child: SizedBox(
                width: widget.dropWidth ?? width,
                child: DefaultTextStyle(
                  style: const TextStyle(),
                  child: _DropDown(
                    selected: widget.selected,
                    items: widget.items,
                    onDispose: _setOpen,
                    color: widget.dropBgColor,
                    emptyMessage: widget.emptyMessage,
                    searchController: widget.searchController,
                    onTap: (a) {
                      widget.onSelected(a);
                      _close();
                    },
                    onClearTap: widget.onClearTap,
                  ),
                ),
              ),
            );
          },
        ),
      ),
      dismissible: true,
    );

    setState(() {});
  }

  void _close() {
    fullScreenBanner.hide();
  }

  void _setOpen() {
    open = false;
    if (mounted) setState(() {});
  }
}

class _DropDown extends StatefulWidget {
  final ValueNotifier<List<CommonKeyValueModel>> items;
  final CommonKeyValueModel? selected;
  final Function() onDispose;
  final Function()? onClearTap;
  final Function(CommonKeyValueModel) onTap;
  final Color? color;
  final TextEditingController? searchController;
  final String emptyMessage;

  const _DropDown({
    required this.items,
    required this.selected,
    required this.onDispose,
    required this.onTap,
    required this.color,
    required this.onClearTap,
    required this.emptyMessage,
    this.searchController,
  });

  @override
  State<_DropDown> createState() => _DropDownState();
}

class _DropDownState extends State<_DropDown> {
  late ScrollController controller;

  @override
  void initState() {
    widget.searchController?.text = widget.selected?.value ?? '';
    controller = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    Future.delayed(Duration.zero, () => widget.onDispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: context.percentHeight * 30),
      margin: const EdgeInsets.only(top: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Tm.color(Tc.comBg)),
        color: widget.color ?? Tm.color(Tc.ipfDef),
      ),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      child: ValueListenableBuilder<List<CommonKeyValueModel>>(
        valueListenable: widget.items,
        builder: (context, value, child) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.searchController != null)
                Material(
                  type: MaterialType.transparency,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 6, right: 6, bottom: 8),
                    child: TextFieldWithTitle(
                      controller: widget.searchController!,
                      title: '',
                      removeAllProps: true,
                      autoFocus: true,
                      borderColor: Tm.color(Tc.tabDefTxt),
                      paddingContent: 12,
                      suffixIcon: HoverGD(
                        onTap: (widget.searchController?.text ?? '').isEmpty ? null : widget.onClearTap,
                        builder: (context, bState) {
                          return Container(
                            width: 12,
                            height: 12,
                            alignment: Alignment.center,
                            child: SvgImage(
                              (widget.searchController?.text ?? '').isEmpty ? Assets.icons.lens : Assets.icons.close,
                              color: (widget.searchController?.text ?? '').isEmpty
                                  ? Tm.color(Tc.tabDefTxt)
                                  : Tm.color(bState.isHovering ? Tc.closeRed : Tc.tabDefTxt),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              Flexible(
                child: widget.items.value.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 22),
                        child: Text(widget.emptyMessage, textAlign: TextAlign.center, style: TsDefined.ts16W400()),
                      )
                    : CustomScrollBar(
                        controller: controller,
                        child: ListView.builder(
                          itemCount: widget.items.value.length,
                          shrinkWrap: true,
                          controller: controller,
                          padding: const EdgeInsets.all(8),
                          itemBuilder: (context, index) => DropDownTile(
                            onTap: widget.onTap,
                            selected: widget.selected,
                            model: widget.items.value[index],
                          ),
                        ),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class DropDownTile extends StatelessWidget {
  final Function(CommonKeyValueModel) onTap;
  final CommonKeyValueModel? selected;
  final CommonKeyValueModel model;

  const DropDownTile({super.key, required this.onTap, required this.selected, required this.model});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: HoverGD(
        onTap: () => onTap(model),
        borderRadius: const BorderRadius.all(Radius.circular(6)),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(6)),
            color: _checkSelected() ? Tm.color(Tc.priDef) : Tm.color(Tc.comCardBg),
          ),
          child: Text(
            model.value,
            style: TsDefined.ts16W600(color: Tm.color(_checkSelected() ? Tc.comBtnTxt : Tc.ipfTitle)),
          ),
        ),
      ),
    );
  }

  bool _checkSelected() => selected?.id == model.id;
}
