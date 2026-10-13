part of '../employee_screen.dart';

class EmployeeDetails extends StatefulWidget {
  final String employeeCode;

  const EmployeeDetails({super.key, required this.employeeCode});

  @override
  State<EmployeeDetails> createState() => _EmployeeDetailsState();
}

class _EmployeeDetailsState extends State<EmployeeDetails> {
  Status employeeStatus = Status.loading;
  String? error;
  UserModel? employee;
  late ScrollController scrollController;
  List<String> permissionList = [];

  @override
  void initState() {
    scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((s) => _getEmployee());
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewDetailsSkeleton(
      title: 'Employee Details',
      error: error,
      onRetry: _getEmployee,
      status: employeeStatus,
      builder: (context) {
        return CustomScrollBar(
          controller: scrollController,
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DetailsValueName(
                  label: 'Employee Image',
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.all(Radius.circular(12)),
                        child: CachedImage(
                          url: employee!.profilePhotoUrl,
                          height: 140,
                          width: 140,
                          errorWidget: Container(
                            width: 140,
                            height: 140,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(color: Tm.color(Tc.tableLine2)),
                            child: SvgImage(Assets.icons.person, height: 40, width: 40, color: Tm.color(Tc.txtH4)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Flexible(
                        child: ViewDetailsChipWrap(
                          chips: [
                            ChipModel.fromValue(
                              condition: employee!.isActive,
                              trueText: 'Active',
                              falseText: 'Inactive',
                            ),
                            ChipModel.fromValue(
                              condition: employee!.emailVerified,
                              trueText: 'Email Verified',
                              falseText: 'Email not verified',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                DetailsValueName(label: 'Employee ID', childText: employee!.employeeCode),
                DetailsValueName(label: 'Employee Name', childText: employee!.name.toFirstLetterUpperCase()),
                DetailsValueName(label: 'Employee Email', childText: employee!.emailId),
                DetailsValueName(
                  label: 'Date of Birth',
                  childText: StaticValues.commonDateFormatSlash.format(employee!.dob),
                ),
                DetailsValueName(
                  label: 'Phone',
                  childText: StaticValues.mobileFormatter(
                    code: employee!.mobileNumberDailCode,
                    number: employee!.mobileNumber,
                  ),
                ),
                DetailsValueName(
                  label: 'Alternate Phone',
                  childText: StaticValues.mobileFormatter(
                    code: employee!.altMobileNumberDailCode,
                    number: employee!.altMobileNumber,
                  ),
                ),
                DetailsValueName(label: 'Address', childText: employee!.address),
                DetailsValueName(label: 'State and Country', childText: '${employee!.state}, ${employee!.country}'),
                DetailsValueName(
                  label: 'Accessible Shops',
                  child: EmployeeDetailsWrapWidget(items: employee!.shopAccess.map((e) => e.value).toList()),
                ),
                DetailsValueName(
                  label: 'Employee Permissions',
                  child: EmployeeDetailsWrapWidget(items: permissionList),
                ),
              ],
            ),
          ),
        );
      },
      bottomButtons: employeeStatus == Status.success
          ? [
              ViewDetailsButtonModel.closeButton(),
              ViewDetailsButtonModel(
                icon: employee!.isActive ? Assets.icons.personCancel : Assets.icons.personApprove,
                tooltip: employee!.isActive ? 'Deactivate' : 'Activate',
                onTap: () async {
                  bool statusChanged = await _updateEmployeeStatus([employee!], !employee!.isActive);
                  if (statusChanged) AppNavigator.pop();
                },
                iconColor: employee!.isActive ? Tm.color(Tc.redActLight) : Tm.color(Tc.grnActLight),
                bgColor: employee!.isActive ? Tm.color(Tc.iconButtonBgRed) : Tm.color(Tc.iconButtonBgGreen),
              ),
              ViewDetailsButtonModel.editButton(() {
                AppNavigator.pop();
                AppNavigator.navigate(
                  AppRoutes.employeeEdit(data: AddEditEmployeeScreen(employeeCode: widget.employeeCode)),
                );
              }),
              ViewDetailsButtonModel.deleteButton(() async {
                bool deleted = await _deleteEmployees([employee!]);
                if (deleted) AppNavigator.pop();
              }),
            ]
          : [],
    );
  }

  Future<void> _getEmployee() async {
    employeeStatus = Status.loading;
    error = null;
    employee = null;
    _refresh();

    final response = await EmployeeService.getEmployee(employeeCode: widget.employeeCode);

    if (!response.responseType.success || response.data == null) {
      error = response.firstError();
      employeeStatus = Status.error;
      _refresh();
      return;
    }

    employee = response.data;
    _getPermissions();
    employeeStatus = Status.success;
    _refresh();
  }

  void _refresh() => mounted ? setState(() {}) : null;

  void _getPermissions() {
    for (final i in (employee!.permissions.permissionList().where((e) => e.hasPermission()))) {
      permissionList.addAll(i.subModules.map((e) => e.moduleName));
    }
  }
}
