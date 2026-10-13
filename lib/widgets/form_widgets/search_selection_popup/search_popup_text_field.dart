import 'package:invently/assortment/widgets/button/hover_button_base.dart';
import 'package:invently/assortment/widgets/button/hover_gesture_detector.dart';
import 'package:invently/assortment/widgets/svg_image.dart';
import 'package:invently/gen/assets.gen.dart';
import 'package:invently/models/common/common_id_value_model.dart';
import 'package:invently/utils/common_functions.dart';
import 'package:invently/utils/theme/colors/colors.dart';
import 'package:invently/widgets/alert_dialog/api_search_drop_down.dart';
import 'package:invently/widgets/alert_dialog/show_dialog.dart';
import 'package:invently/widgets/form_widgets/search_selection_popup/search_popup.dart';
import 'package:invently/widgets/text_widget/text_field.dart';
import 'package:flutter/material.dart';

class SearchPopupTextField extends StatefulWidget {
  final String? title;
  final String? hint;
  final String? error;
  final String popupSubject;
  final CommonKeyValueModel? selected;
  final bool required;
  final bool removeAllProps;
  final Function(CommonKeyValueModel?) onSelected;
  final Future<SearchApiResponseModel> Function(SearchModel) onSearch;

  const SearchPopupTextField({
    super.key,
    this.title,
    this.error,
    required this.selected,
    required this.onSelected,
    this.hint,
    this.required = true,
    this.removeAllProps = false,
    required this.popupSubject,
    required this.onSearch,
  });

  @override
  State<SearchPopupTextField> createState() => _SearchPopupTextFieldState();
}

class _SearchPopupTextFieldState extends State<SearchPopupTextField> {
  late TextEditingController controller;
  late FocusNode fNode;

  @override
  void initState() {
    controller = TextEditingController(text: widget.selected?.value);
    fNode = FocusNode();
    fNode.addListener(() => CommonFunctions.removeTextSelection(controller));

    super.initState();
  }

  @override
  void didUpdateWidget(covariant SearchPopupTextField oldWidget) {
    controller.text = widget.selected?.value ?? '';
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    controller.dispose();
    fNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFieldWithTitle(
      removeAllProps: widget.removeAllProps,
      controller: controller,
      title: widget.title,
      error: widget.error,
      hint: widget.hint,
      required: widget.required,
      focusNode: fNode,
      autoFocus: false,
      onTap: _onTap,
      suffixIcon: HoverGD(
        onTap: widget.selected == null ? null : () => widget.onSelected(null),
        builder: (context, bState) {
          return Container(
            width: 12,
            height: 12,
            alignment: Alignment.center,
            child: SvgImage(
              widget.selected == null ? Assets.icons.arrowDown : Assets.icons.close,
              color: widget.selected == null
                  ? Tm.color(Tc.tabDefTxt)
                  : Tm.color(bState.isHovering ? Tc.closeRed : Tc.tabDefTxt),
            ),
          );
        },
      ),
    );
  }

  void _onTap() {
    showPopup(
      canClose: true,
      child: PopupBody(
        title: widget.popupSubject,
        onClose: widget.onSelected,
        selected: widget.selected,
        onSearch: widget.onSearch,
      ),
    );
  }
}
