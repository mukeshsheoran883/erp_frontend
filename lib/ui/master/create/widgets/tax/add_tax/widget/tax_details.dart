part of '../add_tax_screen.dart';

class _TaxDetailsForm extends StatelessWidget {
  final _AddEditTaxScreenState state;

  const _TaxDetailsForm({required this.state});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              Expanded(
                child: TextFieldWithTitle(
                  title: 'Tax Title',
                  controller: state.params.taxTitle.controller,
                  required: true,
                  error: state.params.taxTitle.error.errorMessage,
                  onChanged: (a) => {state.params.taxTitle.resetError(), state._refresh()},
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: TextFieldWithTitle(
                  title: 'Total Tax',
                  controller: state.params.totalTax.controller,
                  required: true,
                  error: state.params.totalTax.error.errorMessage,
                  onChanged: (a) => {state.params.totalTax.resetError(), state._refresh()},
                  suffixIcon: Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8, right: 3),
                    child: AdvancedSwitch(
                      width: 60,
                      onChanged: (value) => value != value,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(width: double.infinity, height: 2, color: Tm.color(Tc.tableDivider)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Row(
            children: [
              Text(
                'Tax Split',
                style: TsDefined.ts22W500(color: Tm.color(Tc.breadcrumbsDefTxt)),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              InkWell(
                onTap: () => _addTaxSplit(state),
                child: SvgImage(Assets.icons.addSquare, height: 22, width: 22, color: Tm.color(Tc.breadcrumbsDefTxt)),
              ),
            ],
          ),
        ),
        Container(width: double.infinity, height: 2, color: Tm.color(Tc.tableDivider)),
        const SizedBox(height: 24),

        // Yaha sab split rows loop hoke render honge
        ...List.generate(state.params.taxSplits.length, (index) {
          final split = state.params.taxSplits[index];
          return Padding(
            padding: const EdgeInsets.only(left: 24, right: 24, bottom: 16),
            child: Row(
              children: [
                Expanded(
                  child: TextFieldWithTitle(
                    title: 'Tax Name',
                    controller: split.name.controller,
                    required: true,
                    error: split.name.error.errorMessage,
                    onChanged: (a) => {split.name.resetError(), state._refresh()},
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: TextFieldWithTitle(
                    title: 'Tax%',
                    controller: split.tax.controller,
                    required: true,
                    error: split.tax.error.errorMessage,
                    onChanged: (a) => {split.tax.resetError(), state._refresh()},
                  ),
                ),
                // Pehli row ko delete na hone do, baaki ko delete option do
                if (state.params.taxSplits.length > 1)
                  Padding(
                    padding: const EdgeInsets.only(left: 12, top: 20),
                    child: InkWell(
                      onTap: () => _removeTaxSplit(state, index),
                      child: SvgImage(Assets.icons.trash, height: 20, width: 20, color: Tm.color(Tc.redActLight)),
                    ),
                  ),
              ],
            ),
          );
        }),
      ],
    );
  }
}