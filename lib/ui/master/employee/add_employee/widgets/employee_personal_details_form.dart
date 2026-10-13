
part of '../add_employee_screen.dart';

class _EmployeePersonalDetailsForm extends StatelessWidget {
  final _AddEditEmployeeScreenState state;

  const _EmployeePersonalDetailsForm({required this.state});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: SizedBox(
          width: StaticValues.formWidth(),
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
                      fileSizeText: '3 MB max file size',
                      title: 'Employee Image',
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
                              title: 'Employee Name',
                              controller: state.params.name.controller,
                              required: true,
                              error: state.params.name.error.errorMessage,
                              onChanged: (a) => {state.params.name.resetError(), state._refresh()},
                            ),
                          ),
                          Flexible(
                            child: TextFieldWithTitle(
                              title: 'Employee Email',
                              controller: state.params.email.controller,
                              required: true,
                              error: state.params.email.error.errorMessage,
                              onChanged: (a) => {state.params.email.resetError(), state._refresh()},
                            ),
                          ),
                          Flexible(
                            child: Row(
                              children: [
                                Expanded(
                                  child: CustomDateTimeField(
                                    title: 'Date of Birth',
                                    required: true,
                                    pickMode: DatePickMode.dateOnly,
                                    error: state.params.dateOfBirth.error.errorMessage,
                                    initialDateTime: state.params.dateOfBirth.dateTime,
                                    onDateSelected: (a) => {state.params.dateOfBirth.reset(a), state._refresh()},
                                  ),
                                ),
                                const SizedBox(width: 24),
                                Expanded(
                                  child: IgnorePointer(
                                    ignoring: state.widget.employeeCode == null,
                                    child: CustomDropdown(
                                      items: state.params.status.options,
                                      onSelected: _onStatusSelected,
                                      title: 'Emp. Status',
                                      required: true,
                                      selected: state.params.status.selected,
                                      error: state.params.status.error.errorMessage,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Row(
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
                children: [
                  Expanded(
                    child: CountryDropDown(
                      onSelected: _onCountrySelected,
                      selectedCountry: state.params.country.selected,
                      required: true,
                      countries: state.params.country.options,
                      error: state.params.country.error.errorMessage,
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: StateDropDown(
                      onSelected: (a) => {state.params.state.reset(a), state._refresh()},
                      states: state.params.country.selected?.states ?? [],
                      required: true,
                      selectedState: state.params.state.value,
                      error: state.params.state.error.errorMessage,
                    ),
                  ),
                ],
              ),
              TextFieldWithTitle(
                title: 'Address',
                maxLen: 300,
                controller: state.params.address.controller,
                required: true,
                error: state.params.address.error.errorMessage,
                onChanged: (a) => {state.params.address.resetError(), state._refresh()},
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onCountrySelected(Country? a) {
    if (state.params.country.selected != a) state.params.state.reset(null);
    state.params.country.reset(a);
    state._refresh();
  }

  void _onStatusSelected(CommonKeyValueModel? st) {
    state.params.status.reset(st);
    state._refresh();
  }
}
