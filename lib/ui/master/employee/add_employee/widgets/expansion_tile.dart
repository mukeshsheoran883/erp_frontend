
import 'package:invently/assortment/extensions/context_extensions.dart';
import 'package:invently/assortment/widgets/button/hover_gesture_detector.dart';
import 'package:invently/assortment/widgets/svg_image.dart';
import 'package:invently/gen/assets.gen.dart';
import 'package:invently/models/user/employee_permission_model.dart';
import 'package:invently/utils/theme/colors/colors.dart';
import 'package:invently/utils/theme/text_style/text_styles.dart';
import 'package:invently/widgets/custom_check_box.dart';
import 'package:flutter/material.dart';

class PermissionExpansionTile extends StatefulWidget {
  final bool expanded;
  final Function(EmployeePermissionGroupModel? expandedModel) onTap;
  final Function() onPermissionChanged;

  const PermissionExpansionTile({
    super.key,
    required this.permissionModel,
    required this.expanded,
    required this.onTap,
    required this.onPermissionChanged,
  });

  final EmployeePermissionGroupModel permissionModel;

  @override
  State<PermissionExpansionTile> createState() => _PermissionExpansionTileState();
}

class _PermissionExpansionTileState extends State<PermissionExpansionTile> with SingleTickerProviderStateMixin {
  final Tween<double> _heightFactorTween = Tween<double>(begin: 0.0, end: 1.0);

  late AnimationController _animationController;
  late CurvedAnimation _heightFactor;
  bool _isExpanded = false;

  @override
  void initState() {
    _isExpanded = widget.expanded;
    _animationController = AnimationController(duration: const Duration(milliseconds: 250), vsync: this);
    _heightFactor = CurvedAnimation(parent: _animationController.drive(_heightFactorTween), curve: Curves.easeIn);
    _animationController.value = _isExpanded ? 1.0 : 0.0;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant PermissionExpansionTile oldWidget) {
    if (mounted) {
      widget.expanded ? _animationController.forward() : _animationController.reverse();
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _heightFactor.dispose();
    super.dispose();
  }

  void _handleTap() {
    final t = widget.expanded ? null : widget.permissionModel;
    widget.onTap(t);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Container(
        width: context.percentWidth * 45,
        decoration: BoxDecoration(color: Tm.color(Tc.tableDivider), borderRadius: radius),
        child: AnimatedBuilder(
          animation: _animationController.view,
          builder: (context, child) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                HoverGD(
                  onTap: _handleTap,
                  borderRadius: radius,
                  clickColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 32,
                          child: CustomCheckBox(
                            isChecked: widget.permissionModel.isAllPermissionGranted(),
                            onChange: _selectAllTapped,
                          ),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.permissionModel.moduleName,
                                style: Ts.lgSemibold(color: Tm.color(Tc.txtH3)),
                              ),
                              const SizedBox(height: 4),
                              Text(widget.permissionModel.description, style: Ts.mdLight(color: Tm.color(Tc.ipfTxt))),
                            ],
                          ),
                        ),
                        const SizedBox(width: 24),
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: AnimatedRotation(
                            turns: _heightFactor.value / 2,
                            duration: const Duration(milliseconds: 100),
                            child: SvgImage(Assets.icons.arrowDown, width: 16, height: 8, color: Tm.color(Tc.ipfTxt)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                ClipRRect(
                  borderRadius: radius,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    heightFactor: _heightFactor.value,
                    child: Container(
                      margin: const EdgeInsets.only(left: 2, right: 2, bottom: 2),
                      decoration: BoxDecoration(color: Tm.color(Tc.tableDivider), borderRadius: radius),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Tm.color(Tc.comCardBg),
                          borderRadius: const BorderRadius.all(Radius.circular(14)),
                        ),
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          children: [
                            for (final i in widget.permissionModel.subModules)
                              _SubItem(onTap: (a) => {i.hasPermission = a, widget.onPermissionChanged()}, model: i),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  BorderRadius radius = const BorderRadius.all(Radius.circular(16));

  void _selectAllTapped(bool a) {
    for (final i in widget.permissionModel.subModules) {
      i.hasPermission = a;
    }
    widget.onPermissionChanged();
  }
}

class _SubItem extends StatelessWidget {
  final EmployeePermissionModel model;
  final Function(bool) onTap;

  const _SubItem({required this.model, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(height: 32, child: CustomCheckBox(isChecked: model.hasPermission, onChange: onTap)),
          const SizedBox(width: 24),
          SizedBox(width: 130, child: Text(model.moduleName, style: Ts.rgRegular(color: Tm.color(Tc.ipfTxt)))),
          const SizedBox(width: 16),
          Flexible(child: Text(model.description, style: Ts.mdRegular(color: Tm.color(Tc.ipfTxt)))),
        ],
      ),
    );
  }
}
