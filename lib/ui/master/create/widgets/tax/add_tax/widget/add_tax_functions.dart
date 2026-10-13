part of '../add_tax_screen.dart';

Future<void> _getTax(_AddEditTaxScreenState state) async {
  await _setInitialValues(state);
  state.params.taxModel.resetError();
  state.params.taxModel.setStatus(Status.success);
  state._refresh();
}

Future<void> _setInitialValues(_AddEditTaxScreenState state) async {
  state.params.taxTitle.reset(state.widget.taxName);
  state.params.totalTax.reset(state.widget.totalTax);
  // Agar edit mode hai aur pehle se split data available hai to yaha populate kar sakte ho
  // Filhal default ek empty row rehta hai jo AddTaxParams me already set hai
}

void _addTaxSplit(_AddEditTaxScreenState state) {
  state.params.taxSplits.add(TaxSplitParam());
  state._refresh();
}

void _removeTaxSplit(_AddEditTaxScreenState state, int index) {
  state.params.taxSplits[index].dispose();
  state.params.taxSplits.removeAt(index);
  state._refresh();
}

void _resetErrors(_AddEditTaxScreenState state) => state.params.allParams().forEach((d) => d.resetError());

void _dispose(_AddEditTaxScreenState state) {
  state.params.taxModel.dispose();
  state.params.totalTax.dispose();
  state.params.taxTitle.dispose();
  for (var split in state.params.taxSplits) {
    split.dispose();
  }
}

Future<void> _onSaveTap(_AddEditTaxScreenState state, BuildContext context) async {
  await handleFutureWithAlert(
    errorMessage: () => '',
    function: () async {
      final valid = _validate(state);
      if (valid != null) {
        context.pop();
        final provider = context.read<TaxProvider>();
        await TaxService.createTax(valid);
        provider.clear();
        provider.getTaxList();
      }
      state._refresh();
      return Status.success;
    },
  );
}

Future<void> _onSaveChangeTap(_AddEditTaxScreenState state, BuildContext context) async {
  await handleFutureWithAlert(
    errorMessage: () => '',
    function: () async {
      final valid = _validate(state);
      if (valid != null) {
        context.pop();
        final provider = context.read<TaxProvider>();
        await TaxService.updateTax(valid);
        provider.clear();
        provider.getTaxList();
      }
      state._refresh();
      return Status.success;
    },
  );
}

Future<void> _onDeleteTap(_AddEditTaxScreenState state, BuildContext context) async {
  await handleFutureWithAlert(
    errorMessage: () => '',
    function: () async {
      context.pop();
      final provider = context.read<TaxProvider>();
      await TaxService.multiDeleteTax(deleteList: [state.widget.taxCode]);
      provider.clear();
      provider.getTaxList();
      state._refresh();
      return Status.success;
    },
  );
}

TaxModel? _validate(_AddEditTaxScreenState state) {
  _resetErrors(state);
  AddTaxParams param = state.params;
  String taxTitle = param.taxTitle.text;
  String totalTaxText = param.totalTax.text;

  List<ValidationModel> results = [
    CustomValidators.nameValidator(field: 'Tax Title', data: taxTitle, error: param.taxTitle.error),
    CustomValidators.nameValidator(field: 'Total Tax', data: totalTaxText, error: param.totalTax.error),
  ];

  for (var split in param.taxSplits) {
    results.add(CustomValidators.nameValidator(field: 'Tax Name', data: split.name.text, error: split.name.error));
    results.add(CustomValidators.nameValidator(field: 'Tax %', data: split.tax.text, error: split.tax.error));
  }

  bool isValid = Validator.validate(results);
  if (!isValid) return null;

  final Map<String, double> taxSplitsMap = {
    for (var split in param.taxSplits)
      split.name.text.toLowerCase(): double.tryParse(split.tax.text) ?? 0,
  };

  TaxModel taxModel = TaxModel(
    name: taxTitle,
    disabled: false,
    selected: false,
    totalTax: double.parse(totalTaxText),
    taxSplits: taxSplitsMap,
    taxCode: state.widget.taxCode,
  );

  return taxModel;
}