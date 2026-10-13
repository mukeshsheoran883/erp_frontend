part of '../add_supplier_screen.dart';

class _SupplierDetailsForm extends StatelessWidget {
  final _AddEditSupplierScreenState state;

  const _SupplierDetailsForm({required this.state});

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
                      file: state.params.image.file,
                      fileSizeText: '3 MB max file size',
                      title: 'Supplier Image',
                      required: true,
                      fileType: FileType.image,
                      onFileSelected: (a) => {state.params.image.reset(a), state._refresh()},
                      onRemoveTap: () => {state.params.image.reset(null), state._refresh()},
                      error: state.params.image.error.errorMessage,
                    ),
                    const SizedBox(width: 32),
                    FilePickerAndDisplayWidget(
                      file: state.params.idImage.file,
                      fileSizeText: '3 MB max file size',
                      title: 'Id Proof',
                      required: true,
                      fileType: FileType.image,
                      onFileSelected: (a) => {state.params.idImage.reset(a), state._refresh()},
                      onRemoveTap: () => {state.params.idImage.reset(null), state._refresh()},
                      error: state.params.idImage.error.errorMessage,
                    ),
                  ],
                ),
                Row(
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
                    const SizedBox(width: 24),
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
                    Expanded(
                      child: PhoneNumberField(
                        title: 'Alternate Phone',
                        required: true,
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
                Row(
                  children: [
                    Expanded(
                      child: CustomDropdown(
                        items: state.params.id.options,
                        onSelected: _onIdUniqueSelected,
                        title: 'Unique ID Type',
                        required: true,
                        selected: state.params.id.selected,
                        error: state.params.id.error.errorMessage,
                      ),
                    ),
                    const SizedBox(width: 24),
                    Flexible(
                      child: TextFieldWithTitle(
                        title: 'Unique Id Number',
                        controller: state.params.idNumber.controller,
                        error: state.params.idNumber.error.errorMessage,
                        onChanged: (a) => {state.params.idNumber.resetError(), state._refresh()},
                      ),
                    ),
                    const SizedBox(width: 24),
                    Flexible(
                      child: TextFieldWithTitle(
                        title: 'GST Number',
                        controller: state.params.gstNumber.controller,
                        required: true,
                        error: state.params.gstNumber.error.errorMessage,
                        onChanged: (a) => {state.params.gstNumber.resetError(), state._refresh()},
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

  void _onCountrySelected(Country? a) {
    if (state.params.country.selected != a) state.params.state.reset(null);
    state.params.country.reset(a);
    state._refresh();
  }

  void _onIdUniqueSelected(CommonKeyValueModel? st) {
    state.params.id.reset(st);
    state._refresh();
  }
}
