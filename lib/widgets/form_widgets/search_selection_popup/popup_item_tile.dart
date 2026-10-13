
import 'package:invently/assortment/widgets/button/hover_gesture_detector.dart';
import 'package:invently/models/common/common_id_value_model.dart';
import 'package:invently/utils/theme/colors/colors.dart';
import 'package:invently/utils/theme/text_style/text_styles.dart';
import 'package:flutter/material.dart';

class PopupItemTile extends StatelessWidget {
  final CommonKeyValueModel item;
  final CommonKeyValueModel? selected;
  final Function(CommonKeyValueModel?) onTap;

  const PopupItemTile({super.key, required this.item, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 24),
      child: HoverGD(
        onTap: () => onTap(item),
        borderRadius: const BorderRadius.all(Radius.circular(6)),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(6)),
            color: _checkSelected() ? Tm.color(Tc.priDef) : Tm.color(Tc.ipfDef),
          ),
          child: Text(
            item.value,
            style: TsDefined.ts16W600(color: Tm.color(_checkSelected() ? Tc.comBtnTxt : Tc.ipfTitle)),
          ),
        ),
      ),
    );
  }

  bool _checkSelected() => selected?.id == item.id;
}
