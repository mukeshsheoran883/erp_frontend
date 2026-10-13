part of '../add_customer_screen.dart';

class _CustomerPersonalDetailsForm extends StatelessWidget {
  final _AddEditCustomerScreenState state;

  const _CustomerPersonalDetailsForm({required this.state});

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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    FilePickerAndDisplayWidget(
                      file: state.params.photo.file,
                      fileSizeText: '3 MB max file size',
                      title: 'Image',
                      required: true,
                      fileType: FileType.image,
                      onFileSelected: (a) => {state.params.photo.reset(a), state._refresh()},
                      onRemoveTap: () => {state.params.photo.reset(null), state._refresh()},
                      error: state.params.photo.error.errorMessage,
                    ),
                    const SizedBox(width: 32),
                    FilePickerAndDisplayWidget(
                      file: state.params.idProof.file,
                      fileSizeText: '3 MB max file size',
                      title: 'Id Proof',
                      required: true,
                      fileType: FileType.image,
                      onFileSelected: (a) => {state.params.idProof.reset(a), state._refresh()},
                      onRemoveTap: () => {state.params.idProof.reset(null), state._refresh()},
                      error: state.params.idProof.error.errorMessage,
                    ),
                  ],
                ),
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
                        onChanged: (a) => {state.params.name.resetError(), state._refresh()},
                      ),
                    ),
                    const SizedBox(width: 32),
                    Flexible(
                      child: TextFieldWithTitle(
                        title: 'Email',
                        controller: state.params.email.controller,
                        required: true,
                        error: state.params.email.error.errorMessage,
                        onChanged: (a) => {state.params.email.resetError(), state._refresh()},
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
                        phoneNumberController: state.params.phone.phoneController,
                        countryCodeController: state.params.phone.codeController,
                        error: state.params.phone.error.errorMessage,
                        onChanged: (a) => {state.params.phone.resetError(), state._refresh()},
                      ),
                    ),
                    const SizedBox(width: 24),
                    Flexible(
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: CustomDropdown(
                              items: state.params.unique.options,
                              onSelected: _onIdUniqueSelected,
                              title: 'ID',
                              required: true,
                              selected: state.params.unique.selected,
                              error: state.params.unique.error.errorMessage,
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            flex: 2,
                            child: TextFieldWithTitle(
                              title: 'Unique Number',
                              controller: state.params.uniqueNumber.controller,
                              required: true,
                              error: state.params.uniqueNumber.error.errorMessage,
                              onChanged: (a) => {state.params.uniqueNumber.resetError(), state._refresh()},
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: CustomDropdown(
                        items: state.params.gender.options,
                        onSelected: _onIdGenderSelected,
                        title: 'Gender',
                        required: true,
                        selected: state.params.gender.selected,
                        error: state.params.gender.error.errorMessage,
                      ),
                    ),

                    const SizedBox(width: 32),
                    Flexible(
                      child: TextFieldWithTitle(
                        title: 'Occupation',
                        controller: state.params.occupation.controller,
                        required: true,
                        error: state.params.occupation.error.errorMessage,
                        onChanged: (a) => {state.params.occupation.resetError(), state._refresh()},
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: TextFieldWithTitle(
                        title: 'Education',
                        controller: state.params.education.controller,
                        required: true,
                        error: state.params.education.error.errorMessage,
                        onChanged: (a) => {state.params.education.resetError(), state._refresh()},
                      ),
                    ),
                    const SizedBox(width: 32),
                    Flexible(
                      child: TextFieldWithTitle(
                        title: 'Religion',
                        controller: state.params.religion.controller,
                        required: true,
                        error: state.params.religion.error.errorMessage,
                        onChanged: (a) => {state.params.religion.resetError(), state._refresh()},
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: TextFieldWithTitle(
                        title: 'Blood Group',
                        controller: state.params.bloodGroup.controller,
                        required: true,
                        error: state.params.bloodGroup.error.errorMessage,
                        onChanged: (a) => {state.params.bloodGroup.resetError(), state._refresh()},
                      ),
                    ),
                    const SizedBox(width: 32),
                    Flexible(
                      child: TextFieldWithTitle(
                        title: 'Marital Status',
                        controller: state.params.maritalStatus.controller,
                        required: true,
                        error: state.params.maritalStatus.error.errorMessage,
                        onChanged: (a) => {state.params.maritalStatus.resetError(), state._refresh()},
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: CustomDateTimeField(
                        title: 'Date of Birth',
                        required: true,
                        pickMode: DatePickMode.dateOnly,
                        error: state.params.dateBirth.error.errorMessage,
                        initialDateTime: state.params.dateBirth.dateTime,
                        onDateSelected: (a) => {state.params.dateBirth.reset(a), state._refresh()},
                      ),
                    ),
                    const SizedBox(width: 24),
                    // Expanded(
                    //   child: CustomDateTimeField(
                    //     title: 'Added Date & Time',
                    //     pickMode: DatePickMode.timeOnly,
                    //     error: state.params.date.error.errorMessage,
                    //     initialDateTime: state.params.date.dateTime,
                    //     onDateSelected: (a) => {state.params.date.reset(a), state._refresh()},
                    //   ),
                    // ),

                    // const SizedBox(width: 24),
                    // Expanded(
                    //   child: CustomDateTimeField(
                    //     title: '',
                    //     required: false,
                    //     pickMode: DatePickMode.dateOnly,
                    //     error: state.params.date.error.errorMessage,
                    //     initialDateTime: state.params.date.dateTime,
                    //     onDateSelected: (a) => {state.params.date.reset(a), state._refresh()},
                    //   ),
                    // ),
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
      ),
    );
  }

  void _onIdUniqueSelected(CommonKeyValueModel? st) {
    state.params.unique.reset(st);
    state._refresh();
  }

  void _onIdGenderSelected(CommonKeyValueModel? st) {
    state.params.gender.reset(st);
    state._refresh();
  }

  void _onCountrySelected(Country? a) {
    if (state.params.country.selected != a) state.params.state.reset(null);
    state.params.country.reset(a);
    state._refresh();
  }
}
