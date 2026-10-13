
import 'package:invently/widgets/alert_dialog/popup_menu/show_app_menu.dart';
import 'package:flutter/material.dart';

class CustomPopupMenuButton extends StatefulWidget {
  final Widget Function(AppMenuParams) buttonBuilder;

  const CustomPopupMenuButton({super.key, required this.buttonBuilder});

  @override
  State<CustomPopupMenuButton> createState() => _CustomPopupMenuButtonState();
}

class _CustomPopupMenuButtonState extends State<CustomPopupMenuButton> {
  LayerLink link = LayerLink();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((a) {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: link,
      child: widget.buttonBuilder(
        AppMenuParams(link: link, buttonPosition: _getPosition(context), buttonSize: _getSize(context)),
      ),
    );
  }

  Offset _getPosition(BuildContext context) {
    if (!mounted) return Offset.zero;
    final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return Offset.zero;
    return renderBox.localToGlobal(Offset.zero);
  }

  Size _getSize(BuildContext context) {
    if (!mounted) return const Size(0, 0);
    final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return const Size(0, 0);
    return renderBox.size;
  }
}
