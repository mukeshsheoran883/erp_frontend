
part of '../add_employee_screen.dart';

class _EmployeeAccessForm extends StatelessWidget {
  final _AddEditEmployeeScreenState state;

  const _EmployeeAccessForm({required this.state});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: SizedBox(
          width: StaticValues.formWidth(),
          child: CustomChoiceChipField(
            title: 'Shop Access',
            hint: 'Search to grant access to shops',
            required: true,
            height: context.percentHeight * 40,
            items: state.params.shop.options,
            selectedItems: state.params.shop.selected,
            onRemoveTap: _onRemoveTap,
            onAddTap: _onAddTap,
            error: state.params.shop.error.errorMessage,
          ),
        ),
      ),
    );
  }

  void _onAddTap(CommonKeyValueModel a) {
    a.value = a.value.toPascalCase();
    state.params.shop.selected.add(a);
    state.params.shop.resetError();
    state._refresh();
  }

  void _onRemoveTap(CommonKeyValueModel a) {
    state.params.shop.selected.removeWhere((e) => e.id == a.id);
    state.params.shop.resetError();
    state._refresh();
  }
}
