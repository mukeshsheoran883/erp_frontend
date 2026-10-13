part of '../add_items_screen.dart';

class _ItemDetailsForm extends StatefulWidget {
  final _AddEditItemScreenState state;

  const _ItemDetailsForm({required this.state});

  @override
  State<_ItemDetailsForm> createState() => _ItemDetailsFormState();
}

class _ItemDetailsFormState extends State<_ItemDetailsForm> {
  _AddEditItemScreenState get state => widget.state;

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
                        fileSizeText: '3 MB max file size',
                        title: 'Item Image',
                        required: true,
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
                                title: 'Item Name',
                                controller: state.params.name.controller,
                                required: true,
                                error: state.params.name.error.errorMessage,
                                onChanged: (a) => {state.params.name.resetError(), state._refresh()},
                              ),
                            ),
                            Flexible(
                              child: TextFieldWithTitle(
                                title: 'Description',
                                controller: state.params.description.controller,
                                required: true,
                                error: state.params.description.error.errorMessage,
                                onChanged: (a) => {state.params.description.resetError(), state._refresh()},
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
                      child: CustomDropdown(
                        items: state.params.brand.options,
                        onSelected: _onBrandSelected,
                        title: 'Brand',
                        required: true,
                        selected: state.params.brand.selected,
                        error: state.params.brand.error.errorMessage,
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: CustomDropdown(
                        items: state.params.category.options,
                        onSelected: _onCategorySelected,
                        title: 'Category',
                        required: true,
                        selected: state.params.category.selected,
                        error: state.params.category.error.errorMessage,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: CustomDropdown(
                        items: state.params.supplier.options,
                        onSelected: _onSupplierSelected,
                        title: 'Supplier',
                        required: true,
                        selected: state.params.supplier.selected,
                        error: state.params.supplier.error.errorMessage,
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: CustomDateTimeField(
                        title: 'Added Date & Time',
                        required: true,
                        pickMode: DatePickMode.dateAndTime,
                        error: state.params.date.error.errorMessage,
                        initialDateTime: state.params.date.dateTime,
                        onDateSelected: (a) => {state.params.date.reset(a), state._refresh()},
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: CustomDropdown(
                        items: state.params.tax.options,
                        onSelected: _onTexSelected,
                        title: 'Tax',
                        required: true,
                        selected: state.params.tax.selected,
                        error: state.params.tax.error.errorMessage,
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: TextFieldWithTitle(
                        title: 'Hsn Code',
                        controller: state.params.hsnCode.controller,
                        required: true,
                        error: state.params.hsnCode.error.errorMessage,
                        onChanged: (a) => {state.params.hsnCode.resetError(), state._refresh()},
                      ),
                    ),
                  ],
                ),
                Flexible(
                  child: TextFieldWithTitle(
                    title: 'QR Code',
                    controller: state.params.qrCode.controller,
                    required: true,
                    readOnly: state.params.barQrAuto.value ?? false,
                    error: state.params.qrCode.error.errorMessage,
                    onChanged: (a) => {state.params.qrCode.resetError(), state._refresh()},
                    suffixIcon: Padding(
                      padding: const EdgeInsets.only(right: 16.0, top: 8.0, bottom: 8.0),
                      child: SizedBox(
                        width: 122,
                        child: Row(
                          children: [
                            Container(color: Tm.color(Tc.ipfTitle), width: 2, height: 28),
                            const SizedBox(width: 12),
                            AdvancedSwitch(
                              width: 60,
                              initialValue: state.params.barQrAuto.value ?? false,
                              onChanged: (value) {
                                if (value == true) {
                                  state.params.qrCode.controller.clear();
                                  FocusScope.of(context).unfocus();
                                }
                                state.params.barQrAuto.reset(value);
                                state._refresh();
                              },
                            ),
                            const SizedBox(width: 8),
                            Text('Auto', style: Ts.rgRegular(color: Tm.color(Tc.dropItemDefTxt))),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFieldWithTitle(
                        title: 'SKU Code',
                        controller: state.params.skuCode.controller,
                        required: false,
                        error: state.params.skuCode.error.errorMessage,
                        onChanged: (a) => {state.params.skuCode.resetError(), state._refresh()},
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: TextFieldWithTitle(
                        title: 'No. of Packets',
                        controller: state.params.noOfPackets.controller,
                        required: true,
                        error: state.params.noOfPackets.error.errorMessage,
                        onChanged: (a) => {state.params.noOfPackets.resetError(), state._refresh()},
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: PriceTextField(
                        title: 'Plain Price',
                        controller: state.params.plainPrice.controller,
                        error: state.params.plainPrice.error.errorMessage,
                        onChange: (a) => {state.params.plainPrice.resetError(), state._refresh()},
                        hint: 'Plain price',removeAllProps: false,
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: PriceTextField(
                        title: 'Printed Price',
                        removeAllProps: false,
                        controller: state.params.printedPrice.controller,
                        error: state.params.printedPrice.error.errorMessage,
                        onChange: (a) => {state.params.printedPrice.resetError(), state._refresh()},
                        hint: 'Printed price',
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: TextFieldWithTitle(
                        title: 'MOQ',
                        controller: state.params.moq.controller,
                        required: true,
                        error: state.params.moq.error.errorMessage,
                        onChanged: (a) => {state.params.moq.resetError(), state._refresh()},
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Attributes', style: Ts.lgRegular(color: Tm.color(Tc.ipfTitle))),
                ),
                const SizedBox(height: 8),
                ...state.params.attributes.asMap().entries.map((entry) {
                  final index = entry.key;
                  final attr = entry.value;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      spacing: 12,
                      children: [
                        Expanded(
                          child: TextFieldWithTitle(
                            title: null,
                            hint: 'Attribute name',
                            controller: attr.key.controller,
                            error: attr.key.error.errorMessage,
                            onChanged: (a) => {attr.key.resetError(), state._refresh()},
                          ),
                        ),
                        Expanded(
                          child: TextFieldWithTitle(
                            title: null,
                            hint: 'Value',
                            controller: attr.value.controller,
                            error: attr.value.error.errorMessage,
                            onChanged: (a) => {attr.value.resetError(), state._refresh()},
                          ),
                        ),
                        Expanded(
                          child: TextFieldWithTitle(
                            title: null,
                            hint: 'Unit (optional)',
                            controller: attr.unit.controller,
                            error: attr.unit.error.errorMessage,
                            onChanged: (a) => {attr.unit.resetError(), state._refresh()},
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline),
                          onPressed: state.params.attributes.length < 2 ? null : () => _removeAttribute(index),
                        ),
                        if (index == state.params.attributes.length - 1)
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline),
                            onPressed: _addAttribute,
                          ),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Other Images', style: Ts.lgRegular(color: Tm.color(Tc.ipfTitle))),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    ...state.params.otherImages.asMap().entries.map((entry) {
                      final index = entry.key;
                      final file = entry.value;
                      return FilePickerAndDisplayWidget(
                        file: file.file,
                        fileSizeText: '3 MB max file size',
                        title: 'Image ${index + 1}',
                        required: false,
                        fileType: FileType.image,
                        onFileSelected: (a) => {file.reset(a), state._refresh()},
                        onRemoveTap: () => {state.params.otherImages.removeAt(index), state._refresh()},
                        error: file.error.errorMessage,
                      );
                    }),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline),
                      onPressed: () {
                        state.params.otherImages.add(FileParam());
                        state._refresh();
                      },
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

  void _onBrandSelected(CommonKeyValueModel? st) {
    state.params.brand.reset(st);
    state._refresh();
  }

  void _onCategorySelected(CommonKeyValueModel? st) {
    state.params.category.reset(st);
    state._refresh();
  }

  void _onSupplierSelected(CommonKeyValueModel? st) {
    state.params.supplier.reset(st);
    state._refresh();
  }

  void _onTexSelected(CommonKeyValueModel? st) {
    state.params.tax.reset(st);
    state._refresh();
  }

  void _addAttribute() {
    state.params.attributes.add(AttributeEntry.empty());
    state._refresh();
  }

  void _removeAttribute(int index) {
    state.params.attributes.removeAt(index);
    state._refresh();
  }
}