part of 'administration_screen.dart';

Future<void> _onMenuTap(AdministrationModel administration, AppMenuParams params) async {
  await showAppMenu(
    params: params,
    childrenBuilder: (closeFunction) {
      return [
        AppMenuButtons.viewButton(() => {closeFunction(), _viewOrganizationDetails(administration.name)}),
        AppMenuButtons.editButton(
          () => {
            closeFunction(),
            AppNavigator.navigate(
              AppRoutes.administrationEdit(data: AddEditAdministrationScreen(administrationCode: administration.name)),
            ),
          },
        ),
        AppMenuButtons.textButton(text: 'Copy URL', onTap: () {}),
        AppMenuButtons.textButton(text: 'Renew', onTap: () {}),
        AppMenuButtons.divider(),
        AppMenuButtons.deleteButton(
          () {
            closeFunction();
            _deleteAdministration([administration]);
          },
        ),
      ];
    },
  );
}

Future<void> _viewOrganizationDetails(String organizationName) async {
  await showRightMenu(AdministrationDetails(administrationCode: organizationName));
}

Future<bool> _deleteAdministration(List<AdministrationModel> administration) async {
  final model = MultiSelectModel(
    items: administration.map((e) => e.name.toPascalCase()).toList(),
    singleString: 'administration',
    pluralString: 'administrations',
  );

  bool confirmed = await showMultiDeletePopup(model: model);

  if (!confirmed) return false;

  String error = '';
  Status s = await handleFutureWithAlert(
    errorMessage: () => error,
    progressbarWaitDuration: Duration.zero,
    function: () async {
      final response =
          await AdministrationService.multiDeleteOrganization(deleteList: administration.map((e) => e.name).toList());

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
            '${(administration.length > 1 ? model.pluralString : model.singleString).toFirstLetterUpperCase()} deleted',
      );
      context.read<AdministrationProvider>().getOrganizationList();
    },
  );

  if (s == Status.success) return true;
  return false;
}

Future<SearchResponseModel> _search(String a) async {
  final response = await AdministrationService.getOrganizationList(
    pageNumber: 1,
    searchKey: a,
  );
  return SearchResponseModel(
    status: (response.responseType.success && response.data != null) ? Status.success : Status.error,
    error: response.firstError(),
    items: (response.data ?? []).map((e) => CommonKeyValueModel(id: e.name, value: e.name)).toList(),
    searchResultsFor: a,
  );
}
