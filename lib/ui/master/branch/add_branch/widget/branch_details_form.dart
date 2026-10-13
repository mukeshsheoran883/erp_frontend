part of '../add_branch_screen.dart';

class _BranchDetailsForm extends StatelessWidget {
  final _AddEditBranchScreenState state;

  const _BranchDetailsForm({required this.state});

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
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: TextFieldWithTitle(
                        title: 'Name',
                        controller: state.params.name.controller,
                        required: true,
                        error: state.params.name.error.errorMessage,
                        onChanged: (a) =>
                            {state.params.name.resetError(), state._refresh()},
                      ),
                    ),
                    const SizedBox(width: 32),
                    Expanded(
                      child: CustomDropdown(
                        items: state.params.type.options,
                        onSelected: _onStatusSelected,
                        title: 'Type',
                        required: true,
                        selected: state.params.type.selected,
                        error: state.params.type.error.errorMessage,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: PhoneNumberField(
                        title: 'Phone',
                        required: true,
                        phoneNumberController:
                            state.params.phone.phoneController,
                        countryCodeController:
                            state.params.phone.codeController,
                        error: state.params.phone.error.errorMessage,
                        onChanged: (a) =>
                            {state.params.phone.resetError(), state._refresh()},
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: PhoneNumberField(
                        title: 'Alternate Phone',
                        required: true,
                        phoneNumberController:
                            state.params.altPhone.phoneController,
                        countryCodeController:
                            state.params.altPhone.codeController,
                        error: state.params.altPhone.error.errorMessage,
                        onChanged: (a) => {
                          state.params.altPhone.resetError(),
                          state._refresh()
                        },
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
                        onSelected: (a) =>
                            {state.params.state.reset(a), state._refresh()},
                        states: state.params.country.selected?.states ?? [],
                        required: true,
                        selectedState: state.params.state.value,
                        error: state.params.state.error.errorMessage,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Flexible(
                      child: TextFieldWithTitle(
                        title: 'Email',
                        controller: state.params.email.controller,
                        required: true,
                        error: state.params.email.error.errorMessage,
                        onChanged: (a) => {state.params.email.resetError(), state._refresh()},
                      ),
                    ),
                    const SizedBox(width: 24),
                    Flexible(
                      child: TextFieldWithTitle(
                        title: 'Building No. & Street No.',
                        maxLen: 300,
                        controller: state.params.buildingStreet.controller,
                        required: true,
                        error: state.params.buildingStreet.error.errorMessage,
                        onChanged: (a) => {
                          state.params.buildingStreet.resetError(),
                          state._refresh()
                        },
                      ),
                    ),
                  ],
                ),
                TextFieldWithTitle(
                  title: 'Website URL',
                  maxLen: 300,
                  controller: state.params.website.controller,
                  required: true,
                  error: state.params.website.error.errorMessage,
                  onChanged: (a) =>
                      {state.params.website.resetError(), state._refresh()},
                ),
              ],
            ),
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
    state.params.type.reset(st);
    state._refresh();
  }
}
