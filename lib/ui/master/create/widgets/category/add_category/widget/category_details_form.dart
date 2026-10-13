part of '../add_category_screen.dart';

class _CategoryDetailsForm extends StatelessWidget {
  final _AddEditCategoryScreenState state;

  const _CategoryDetailsForm({required this.state});

  @override
  Widget build(BuildContext context) {
    return TextFieldWithTitle(
      title: 'Category Name',
      controller: state.params.name.controller,
      required: true,
      error: state.params.name.error.errorMessage,
      onChanged: (a) => {state.params.name.resetError(), state._refresh()},
    );
  }
}
