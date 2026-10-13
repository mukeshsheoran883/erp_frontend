
import 'package:invently/widgets/custom_tab_bar/widgets/tab_bar_button.dart';
import 'package:flutter/material.dart';

class CustomTabBar extends StatefulWidget {
  final List<String> titles;
  final List<Widget> tabs;
  final Widget? endWidget;
  final Function(TabController)? onControllerCreated;
  final Function(int)? onPageChanged;

  const CustomTabBar({
    super.key,
    required this.titles,
    required this.tabs,
    this.endWidget,
    this.onControllerCreated,
    this.onPageChanged,
  });

  @override
  State<CustomTabBar> createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar> with SingleTickerProviderStateMixin {
  late TabController controller;

  @override
  void initState() {
    controller = TabController(length: widget.titles.length, vsync: this);
    controller.addListener(_tabBarListener);
    widget.onControllerCreated?.call(controller);

    super.initState();
  }

  void _tabBarListener() {
    if (mounted) setState(() {});
    widget.onPageChanged?.call(controller.index);
  }

  @override
  void dispose() {
    controller.removeListener(_tabBarListener);
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTabBarTitle(titles: widget.titles, controller: controller),
        const SizedBox(height: 20),
        Expanded(child: TabBarView(controller: controller, children: widget.tabs)),
        if (widget.endWidget != null)
          ClipRRect(borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)), child: widget.endWidget!),
      ],
    );
  }
}
