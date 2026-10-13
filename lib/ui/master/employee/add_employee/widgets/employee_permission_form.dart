
part of '../add_employee_screen.dart';

class _EmployeePermissionForm extends StatefulWidget {
  final _AddEditEmployeeScreenState state;

  const _EmployeePermissionForm({required this.state});

  @override
  State<_EmployeePermissionForm> createState() => _EmployeePermissionFormState();
}

class _EmployeePermissionFormState extends State<_EmployeePermissionForm> {
  late ScrollController scrollController;

  List<EmployeePermissionGroupModel> sortedPermissions = [];

  @override
  void initState() {
    sortedPermissions = widget.state.params.permission.value.permissionList();
    sortedPermissions.sort((a, b) => a.moduleName.compareTo(b.moduleName));
    for (final i in sortedPermissions) {
      i.subModules.sort((a, b) => a.moduleName.compareTo(b.moduleName));
    }

    scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.percentWidth * 45,
      child: CustomScrollBar(
        controller: scrollController,
        child: SingleChildScrollView(
          controller: scrollController,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: context.percentWidth * 45,
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      widget.state.params.permission.error.errorMessage ?? '',
                      style: Ts.rgSemiRegular(color: Tm.color(Tc.redDef)),
                    ),
                  ),
                ),
              ),
              for (final i in sortedPermissions)
                PermissionExpansionTile(
                  permissionModel: i,
                  expanded: widget.state.params.openedGroup?.moduleName == i.moduleName,
                  onTap: _onTap,
                  onPermissionChanged: _onPermissionChanged,
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _onTap(EmployeePermissionGroupModel? a) {
    widget.state.params.openedGroup = a;
    widget.state._refresh();
  }

  void _onPermissionChanged() {
    widget.state.params.permission.resetError();
    widget.state._refresh();
  }
}
