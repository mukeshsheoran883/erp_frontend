part of '../add_dispatch_details_screen.dart';

Future<void> _getDispatchDetails(_AddDispatchDetailsScreenState state) async {
  state._refresh();
}

void _resetErrors(_AddDispatchDetailsScreenState state) =>
    state.params.allParams().forEach((d) => d.resetError());

void _dispose(_AddDispatchDetailsScreenState state) {
  state.params.dispose();
}

Future<void> _onSubmitTap(
    _AddDispatchDetailsScreenState state, BuildContext context) async {
  await handleFutureWithAlert(
    errorMessage: () => '',
    function: () async {
      final valid = _validate(state);
      if (valid != null) {
        context.pop();

        final response = await PosService.dispatchAddDetailsPos(
          posId: state.widget.posId,
          logisticsCompany: valid.logisticsCompany,
          logisticsCharges: valid.logisticsCharges,
        );

        if (response.responseType.success) {
          final ctx = Globals.context();
          AppSnackBar.showSnackBarWithText(
              text: 'Dispatch details added successfully');
          ctx.read<PosProvider>().getPosList();
        } else {
          AppSnackBar.showSnackBarWithText(text: response.firstError());
        }
      }
      state._refresh();
      return Status.success;
    },
  );
}

class _DispatchDetailsFormData {
  final String logisticsCompany;
  final String logisticsCharges;

  _DispatchDetailsFormData({
    required this.logisticsCompany,
    required this.logisticsCharges,
  });
}

_DispatchDetailsFormData? _validate(_AddDispatchDetailsScreenState state) {
  _resetErrors(state);
  AddDispatchDetailsParams param = state.params;
  String logisticsCompany = param.logisticsCompany.text;
  String logisticsCharges = param.logisticsCharges.text;

  // NOTE: reusing nameValidator here to match how this codebase validates
  // numeric-looking fields elsewhere (e.g. totalTax in the Tax screen also
  // used nameValidator rather than a dedicated number validator). Swap
  // this for a proper numeric validator if one exists in your project.
  List<ValidationModel> results = [
    CustomValidators.nameValidator(
      field: 'Logistics Company',
      data: logisticsCompany,
      error: param.logisticsCompany.error,
    ),
    CustomValidators.nameValidator(
      field: 'Logistics Charges',
      data: logisticsCharges,
      error: param.logisticsCharges.error,
    ),
  ];

  bool isValid = Validator.validate(results);
  if (!isValid) return null;

  return _DispatchDetailsFormData(
    logisticsCompany: logisticsCompany,
    logisticsCharges: logisticsCharges,
  );
}