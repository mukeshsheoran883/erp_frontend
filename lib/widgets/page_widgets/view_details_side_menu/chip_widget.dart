
import 'package:invently/widgets/chip_widget.dart';
import 'package:flutter/material.dart';

class ViewDetailsChipWrap extends StatelessWidget {
  final List<ChipModel> chips;

  const ViewDetailsChipWrap({super.key, required this.chips});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      runSpacing: 12,
      spacing: 8,
      children: [for (final i in chips) ChipWidget(chip: i)],
    );
  }
}
