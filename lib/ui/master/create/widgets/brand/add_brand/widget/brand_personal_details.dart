part of '../aad_brand_screen.dart';

class _BrandDetailsForm extends StatelessWidget {
  final _AddEditBrandScreenState state;

  const _BrandDetailsForm({required this.state});

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
