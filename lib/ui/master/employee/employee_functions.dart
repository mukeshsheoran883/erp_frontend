
part of 'employee_screen.dart';

Future<void> _onMenuTap(UserModel employee, AppMenuParams params) async {
  await showAppMenu(
    params: params,
    childrenBuilder: (closeFunction) {
      return [
        AppMenuButtons.viewButton(() => {closeFunction(), _viewEmployeeDetails(employee.employeeCode)}),
        AppMenuButtons.editButton(
          () => {
            closeFunction(),
            AppNavigator.navigate(
              AppRoutes.employeeEdit(data: AddEditEmployeeScreen(employeeCode: employee.employeeCode)),
            ),
          },
        ),
        AppMenuButtons.divider(),
        AppMenuButtons.textButton(
          text: employee.isActive ? 'Deactivate' : 'Activate',
          onTap: () {
            closeFunction();
            _updateEmployeeStatus([employee], !employee.isActive);
          },
        ),
        AppMenuButtons.deleteButton(() {
          closeFunction();
          _deleteEmployees([employee]);
        }),
      ];
    },
  );
}

Future<void> _viewEmployeeDetails(String employeeCode) async {
  await showRightMenu(EmployeeDetails(employeeCode: employeeCode));
}

Future<bool> _deleteEmployees(List<UserModel> employees) async {
  final model = MultiSelectModel(
    items: employees.map((e) => e.name.toPascalCase()).toList(),
    singleString: 'employee',
    pluralString: 'employees',
  );

  bool confirmed = await showMultiDeletePopup(model: model);

  if (!confirmed) return false;

  String error = '';
  Status s = await handleFutureWithAlert(
    errorMessage: () => error,
    progressbarWaitDuration: Duration.zero,
    function: () async {
      final response =
          await EmployeeService.multiDeleteEmployee(deleteList: employees.map((e) => e.employeeCode).toList());

      if (!response.responseType.success) {
        error = response.firstError();
        return Status.error;
      }

      return Status.success;
    },
    onSuccess: () {
      final context = Globals.context();
      AppSnackBar.showSnackBarWithText(
        text: '${(employees.length > 1 ? model.pluralString : model.singleString).toFirstLetterUpperCase()} deleted',
      );
      context.read<EmployeeProvider>().getEmployeeList();
    },
  );

  if (s == Status.success) return true;
  return false;
}

Future<bool> _updateEmployeeStatus(List<UserModel> employees, bool status) async {
  final model = MultiSelectModel(
    items: employees.map((e) => e.name.toPascalCase()).toList(),
    singleString: 'employee',
    pluralString: 'employees',
    rightText: status ? 'activate' : 'deactivate',
    rightIcon: status ? Assets.icons.personApprove : Assets.icons.personCancel,
    actionWord: status ? 'activate' : 'deactivate',
    rightButtonColor: status ? Tm.color(Tc.grnDef) : null,
  );

  bool confirmed = await showMultiActionPopup(model: model);
  if (!confirmed) return false;

  String error = '';
  Status s = await handleFutureWithAlert(
    errorMessage: () => error,
    progressbarWaitDuration: Duration.zero,
    function: () async {
      final response = await EmployeeService.employeeStatusChange(
        employeeList: employees.map((e) => e.employeeCode).toList(),
        status: status,
      );

      if (!response.responseType.success) {
        error = response.firstError();
        return Status.error;
      }

      return Status.success;
    },
    onSuccess: () {
      final context = Globals.context();
      AppSnackBar.showSnackBarWithText(
        text:
            '${(employees.length > 1 ? model.pluralString : model.singleString).toFirstLetterUpperCase()} ${status ? 'activated' : 'deactivated'}',
      );
      context.read<EmployeeProvider>().getEmployeeList();
    },
  );

  if (s == Status.success) return true;
  return false;
}

Future<SearchResponseModel> _search(String a) async {
  final response = await EmployeeService.getEmployeeList(pageNumber: 1, searchKey: a, filter: null);
  return SearchResponseModel(
    status: (response.responseType.success && response.data != null) ? Status.success : Status.error,
    error: response.firstError(),
    items: (response.data ?? []).map((e) => CommonKeyValueModel(id: e.employeeCode, value: e.name)).toList(),
    searchResultsFor: a,
  );
}

Future<void> _showFilter() async {
  await showRightMenu(const EmployeeFilterSection());
}
