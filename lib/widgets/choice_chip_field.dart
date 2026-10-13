
import 'package:invently/assortment/widgets/button/hover_button_base.dart';
import 'package:invently/assortment/widgets/button/hover_gesture_detector.dart';
import 'package:invently/assortment/widgets/svg_image.dart';
import 'package:invently/gen/assets.gen.dart';
import 'package:invently/models/common/common_id_value_model.dart';
import 'package:invently/utils/theme/colors/colors.dart';
import 'package:invently/utils/theme/text_style/text_styles.dart';
import 'package:invently/widgets/page_widgets/custom_scroll_bar.dart';
import 'package:flutter/material.dart';

import 'custom_multi_select_drop_down.dart';

class CustomChoiceChipField extends StatefulWidget {
  final List<CommonKeyValueModel> items;
  final List<CommonKeyValueModel> selectedItems;
  final Function(CommonKeyValueModel)? onRemoveTap;
  final Function(CommonKeyValueModel)? onAddTap;
  final double borderRadius;
  final Color? fillColor;
  final double? height;
  final String title;
  final String? error;
  final bool required;
  final String? hint;

  const CustomChoiceChipField({
    super.key,
    required this.items,
    required this.selectedItems,
    required this.title,
    this.required = false,
    this.onRemoveTap,
    this.borderRadius = 12,
    this.fillColor,
    this.height,
    this.error,
    this.onAddTap,
    this.hint,
  });

  @override
  State<CustomChoiceChipField> createState() => _CustomChoiceChipFieldState();
}

class _CustomChoiceChipFieldState extends State<CustomChoiceChipField> {
  late TextEditingController searchController;
  late ScrollController scrollController;

  ValueNotifier<List<CommonKeyValueModel>> items = ValueNotifier([]);

  @override
  void initState() {
    final remainingItems = widget.items.where((e) => !widget.selectedItems.map((s) => s.id).contains(e.id)).toList();
    items.value = remainingItems;
    searchController = TextEditingController();
    scrollController = ScrollController();
    searchController.addListener(_listener);

    super.initState();
  }

  @override
  void didUpdateWidget(covariant CustomChoiceChipField oldWidget) {
    Future.delayed(Duration.zero, () {
      final remainingItems = widget.items.where((e) => !widget.selectedItems.map((s) => s.id).contains(e.id)).toList();
      items.value = remainingItems;
    });

    super.didUpdateWidget(oldWidget);
  }

  void _listener() {
    String text = searchController.text.trim().toLowerCase();

    final remainingItems = widget.items.where((e) => !widget.selectedItems.map((s) => s.id).contains(e.id)).toList();

    items.value = text.isEmpty
        ? remainingItems
        : remainingItems.where((e) => e.value.toLowerCase().trim().startsWith(text)).toList();
  }

  @override
  void dispose() {
    searchController.removeListener(_listener);
    searchController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomMultiSelectDropDown(
          items: items,
          selectedItems: widget.selectedItems,
          onSelected: (a) =>
              a == null || widget.selectedItems.map((e) => e.id).contains(a.id) ? null : widget.onAddTap?.call(a),
          title: widget.title,
          required: widget.required,
          searchController: searchController,
          error: widget.error,
          onClearTap: () => searchController.text = '',
        ),
        Container(
          constraints: const BoxConstraints(minHeight: 120),
          height: widget.height,
          width: double.infinity,
          decoration: BoxDecoration(
            color: widget.fillColor ?? Tm.color(Tc.ipfDef),
            borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius)),
          ),
          padding: const EdgeInsets.all(16),
          child: CustomScrollBar(
            controller: scrollController,
            child: SingleChildScrollView(
              controller: scrollController,
              child: Wrap(
                runSpacing: 6,
                spacing: 12,
                children: [for (final i in widget.selectedItems) _Item(item: i, onRemoveTap: widget.onRemoveTap)],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _Item extends StatelessWidget {
  final CommonKeyValueModel item;
  final Function(CommonKeyValueModel)? onRemoveTap;

  const _Item({required this.item, required this.onRemoveTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Tm.color(Tc.comCardBg),
        borderRadius: const BorderRadius.all(Radius.circular(6)),
      ),
      padding: const EdgeInsets.only(left: 12, right: 6, top: 8, bottom: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(
              item.value,
              style: Ts.rgRegular(color: Tm.color(Tc.ipfTitle)),
            ),
          ),
          if (onRemoveTap != null)
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: HoverGD(
                onTap: onRemoveTap == null ? null : () => onRemoveTap!(item),
                builder: (context, state) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Tm.color(Tc.ipfDef),
                      borderRadius: const BorderRadius.all(Radius.circular(6)),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: SvgImage(
                      Assets.icons.trash,
                      color: state.isPressing
                          ? Tm.color(Tc.closeRedClick)
                          : state.isHovering
                              ? Tm.color(Tc.closeRed)
                              : Tm.color(Tc.ipfTitle),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
