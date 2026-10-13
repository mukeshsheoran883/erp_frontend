part of '../add_dispatch_details_screen.dart';

class _DispatchDetailsForm extends StatelessWidget {
  final _AddDispatchDetailsScreenState state;

  const _DispatchDetailsForm({required this.state});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextFieldWithTitle(
          title: 'Logistics Company',
          controller: state.params.logisticsCompany.controller,
          required: true,
          error: state.params.logisticsCompany.error.errorMessage,
          onChanged: (a) => {
            state.params.logisticsCompany.resetError(),
            state._refresh(),
          },
        ),
        const SizedBox(height: 16),
        TextFieldWithTitle(
          title: 'Logistics Charges',
          controller: state.params.logisticsCharges.controller,
          required: true,
          // keyboardType: TextInputType.number,
          error: state.params.logisticsCharges.error.errorMessage,
          onChanged: (a) => {
            state.params.logisticsCharges.resetError(),
            state._refresh(),
          },
        ),
      ],
    );
  }
}