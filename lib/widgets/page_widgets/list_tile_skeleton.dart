
import 'package:invently/utils/theme/colors/colors.dart';
import 'package:flutter/material.dart';

class ListTileSkeleton extends StatelessWidget {
  final Widget child;
  final EdgeInsets? itemPadding;
  final EdgeInsets? tilePadding;
  final BoxDecoration? tileDecoration;
  final BoxDecoration? decoration;
  final bool selected;
  final bool disabled;

  const ListTileSkeleton({
    super.key,
    required this.child,
    required this.selected,
    required this.disabled,
    this.itemPadding,
    this.tilePadding,
    this.tileDecoration,
    this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: decoration ?? BoxDecoration(color: Tm.color(Tc.priDef).withValues(alpha: selected ? 1 : 0.3)),
      foregroundDecoration: tileDecoration ?? const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(12))),
      padding: itemPadding,
      margin: tilePadding,
      child: child,
    );
  }
}

class ListTileSkeletonRounded extends StatelessWidget {
  final Widget child;
  final EdgeInsets? tilePadding;

  const ListTileSkeletonRounded({super.key, required this.child, this.tilePadding});

  @override
  Widget build(BuildContext context) {
    return ListTileSkeleton(
      selected: false,
      disabled: false,
      tilePadding: tilePadding ?? EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(24)), color: Tm.color(Tc.comCardBg)),
      child: child,
    );
  }
}
