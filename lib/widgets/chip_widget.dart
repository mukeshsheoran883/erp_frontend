
import 'package:invently/assortment/extensions/string_extensions.dart';
import 'package:invently/utils/theme/colors/colors.dart';
import 'package:invently/utils/theme/text_style/text_styles.dart';
import 'package:flutter/material.dart';

class ChipModel {
  String text;
  ChipColor chipColor;

  ChipModel({required this.text, required this.chipColor});

  factory ChipModel.fromValue({required bool condition, required String trueText, required String falseText}) {
    return ChipModel(text: condition ? trueText : falseText, chipColor: condition ? ChipColor.green : ChipColor.red);
  }
}

enum ChipColor { green, red }

class ChipWidget extends StatelessWidget {
  final ChipModel chip;

  const ChipWidget({super.key, required this.chip});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _getChipColor(),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: Text(chip.text.toFirstLetterUpperCase(), style: TsDefined.ts14W500(color: _getTextColor())),
    );
  }

  Color _getChipColor() {
    switch (chip.chipColor) {
      case ChipColor.red:
        return Tm.color(Tc.iconContainerFillRed);
      default:
        return Tm.color(Tc.iconContainerFillGrn);
    }
  }

  Color _getTextColor() {
    switch (chip.chipColor) {
      case ChipColor.red:
        return PC.colorRed400;
      default:
        return PC.colorGreen400;
    }
  }
}
