part of '../add_administration_screen.dart';

class _AdministrationDetailsForm extends StatelessWidget {
  final _AddEditAdministrationScreenState state;

  const _AdministrationDetailsForm({required this.state});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: SizedBox(
          width: StaticValues.formWidth(),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FilePickerAndDisplayWidget(
                        file: state.params.image.file,
                        title: 'Id Proof',
                        fileType: FileType.image,
                        onFileSelected: (a) => {state.params.image.reset(a), state._refresh()},
                        onRemoveTap: () => {state.params.image.reset(null), state._refresh()},
                        error: state.params.image.error.errorMessage,
                      ),
                      const SizedBox(width: 32),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: TextFieldWithTitle(
                                title: 'Company Name',
                                controller: state.params.name.controller,
                                required: true,
                                error: state.params.name.error.errorMessage,
                                onChanged: (a) => {state.params.name.resetError(), state._refresh()},
                              ),
                            ),
                            Flexible(
                              child: TextFieldWithTitle(
                                title: 'Contact Person Name',
                                controller: state.params.contactPersonName.controller,
                                required: true,
                                error: state.params.contactPersonName.error.errorMessage,
                                onChanged: (a) => {state.params.contactPersonName.resetError(), state._refresh()},
                              ),
                            ),
                            Flexible(
                              child: TextFieldWithTitle(
                                title: 'Contact Email ID',
                                controller: state.params.contactEmailId.controller,
                                required: true,
                                error: state.params.contactEmailId.error.errorMessage,
                                onChanged: (a) => {state.params.contactEmailId.resetError(), state._refresh()},
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: PhoneNumberField(
                        title: 'Phone',
                        required: true,
                        phoneNumberController: state.params.phone.phoneController,
                        countryCodeController: state.params.phone.codeController,
                        error: state.params.phone.error.errorMessage,
                        onChanged: (a) => {state.params.phone.resetError(), state._refresh()},
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: PhoneNumberField(
                        title: 'Alternate Phone',
                        phoneNumberController: state.params.altPhone.phoneController,
                        countryCodeController: state.params.altPhone.codeController,
                        error: state.params.altPhone.error.errorMessage,
                        onChanged: (a) => {state.params.altPhone.resetError(), state._refresh()},
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: CustomDropdown(
                        items: state.params.plan.options,
                        onSelected: (a) => _onPlanSelected(a as OrganizationPlanModel?),
                        title: 'Plan',
                        required: true,
                        selected: state.params.plan.selected,
                        error: state.params.plan.error.errorMessage,
                      ),
                    ),
                    const SizedBox(width: 24),
                    Flexible(
                      child: TextFieldWithTitle(
                        title: 'Branch Count',
                        controller: state.params.branchCount.controller,
                        required: true,
                        maxLen: 3,
                        inputFormatters: [NumbersOnlyFormatter()],
                        readOnly: state.params.plan.selected?.id != OrganizationPlanModel.custom().id,
                        error: state.params.branchCount.error.errorMessage,
                        onChanged: (a) => {state.params.branchCount.resetError(), state._refresh()},
                      ),
                    ),
                    const SizedBox(width: 24),
                    Flexible(
                      child: TextFieldWithTitle(
                        title: 'User Count ',
                        controller: state.params.userCount.controller,
                        inputFormatters: [NumbersOnlyFormatter()],
                        maxLen: 6,
                        readOnly: state.params.plan.selected?.id != OrganizationPlanModel.custom().id,
                        required: true,
                        error: state.params.userCount.error.errorMessage,
                        onChanged: (a) => {state.params.userCount.resetError(), state._refresh()},
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: CustomDateTimeField(
                        title: 'Expiry Date',
                        required: true,
                        pickMode: DatePickMode.dateOnly,
                        error: state.params.expiryDate.error.errorMessage,
                        initialDateTime: state.params.expiryDate.dateTime,
                        onDateSelected: (a) => {state.params.expiryDate.reset(a), state._refresh()},
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: ToggleButtonField(
                        title: 'Payment Gateway',
                        error: null,
                        isOn: state.params.paymentGateway.value ?? false,
                        onChange: state.params.paymentGateway.resetData,
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: ToggleButtonField(
                        title: 'Approval',
                        error: null,
                        isOn: state.params.approval.value ?? false,
                        onChange: state.params.approval.resetData,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onPlanSelected(OrganizationPlanModel? st) {
    state.params.plan.reset(st);
    state.params.branchCount.reset(st?.branchCount.toString());
    state.params.userCount.reset(st?.userCount.toString());
    state._refresh();
  }
}
