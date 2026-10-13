import 'package:invently/assortment/widgets/button/hover_gesture_detector.dart';
import 'package:invently/assortment/widgets/svg_image.dart';
import 'package:invently/gen/assets.gen.dart';
import 'package:invently/utils/theme/colors/colors.dart';
import 'package:flutter/material.dart';

class CustomExpansionTile extends StatefulWidget {
  const CustomExpansionTile({
    super.key,
    required this.tile,
    required this.child,
    this.duration = const Duration(milliseconds: 250),
    this.decoration,
    this.width,
    this.height,
    this.padding,
  });

  final Widget tile;
  final Widget child;
  final Duration duration;
  final BoxDecoration? decoration;
  final double? width;
  final double? height;
  final EdgeInsets? padding;

  @override
  State<CustomExpansionTile> createState() => _CustomExpansionTileState();
}

class _CustomExpansionTileState extends State<CustomExpansionTile> with SingleTickerProviderStateMixin {
  final Tween<double> _heightFactorTween = Tween<double>(begin: 0.0, end: 1.0);

  late AnimationController _animationController;
  late CurvedAnimation _heightFactor;
  bool _isExpanded = false;

  @override
  void initState() {
    _animationController = AnimationController(duration: widget.duration, vsync: this);
    _heightFactor = CurvedAnimation(parent: _animationController.drive(_heightFactorTween), curve: Curves.easeIn);
    if (_isExpanded) _animationController.value = 1.0;
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _heightFactor.dispose();
    super.dispose();
  }

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse().then<void>((void value) {
          if (!mounted) return;

          setState(() {});
        });
      }
    });
  }

  void _handleTap() => _toggleExpansion();

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController.view,
      builder: (context, child) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            HoverGD(
              onTap: _handleTap,
              child: Container(
                width: widget.width,
                height: widget.height,
                decoration: widget.decoration ?? const BoxDecoration(),
                padding: widget.padding,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    widget.tile,
                    AnimatedRotation(
                      turns: _heightFactor.value / 2,
                      duration: const Duration(milliseconds: 100),
                      child: SvgImage(Assets.icons.arrowDown, width: 16, height: 8, color: Tm.color(Tc.ipfTxt)),
                    ),
                  ],
                ),
              ),
            ),
            ClipRect(
              child: Align(alignment: Alignment.center, heightFactor: _heightFactor.value, child: widget.child),
            ),
          ],
        );
      },
    );
  }
}
