
part of 'main_home_screen.dart';

Future<void> _getUserDetails(_MainHomeScreenState state) async {
  state.employee.reset(null);
  state.employee.setStatus(Status.loading);
  state._refresh();
  final response = await CommonApiServices.getCurrentUserDetails();

  if (!response.responseType.success || response.data == null) {
    state.employee.setStatus(Status.error);
    state.employee.setError('Failed to fetch user information. ${response.firstError()}.');

    state._refresh();
    return;
  }

  await Globals.context().read<AuthenticationProvider>().updateCurrentUser(response.data!, null);
  state.employee.reset(response.data);
  state.employee.setStatus(Status.success);
  state._refresh();
}
