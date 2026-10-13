import 'package:invently/assortment/network/api_manager_models.dart';
import 'package:invently/models/common/common_id_value_model.dart';
import 'package:invently/models/common/country_codes.dart';
import 'package:invently/models/common/filter_model.dart';
import 'package:invently/models/common/form_models.dart';
import 'package:invently/provider/master/branch_provider.dart';
import 'package:invently/widgets/custom_drop_down.dart';
import 'package:invently/widgets/form_widgets/country_drop_down.dart';
import 'package:invently/widgets/form_widgets/state_drop_down.dart';
import 'package:invently/widgets/page_widgets/filter_section.dart';
import 'package:invently/widgets/text_widget/text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BranchFilterSection extends StatefulWidget {
  const BranchFilterSection({super.key});

  @override
  State<BranchFilterSection> createState() => _BranchFilterSectionState();
}

class _BranchFilterSectionState extends State<BranchFilterSection> {
  ValueNotifier<List<CommonKeyValueModel>> type = ValueNotifier([
    CommonKeyValueModel(id: 'branch', value: 'branch'),
    CommonKeyValueModel(id: 'warehouse', value: 'warehouse'),
  ]);
  BranchFilterModel filterModel = BranchFilterModel();

  _getBranch() async {
    filterModel.country.options = await Countries.loadCodesFromFile();
    _refresh();
  }

  @override
  void initState() {
    final provider = context.read<BranchProvider>();
    if (provider.filterModel != null) filterModel = filterModel.copy(provider.filterModel!);
    _getBranch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BranchProvider>(
      builder: (context, provider, child) {
        return FilterSection(
          onApply: () => provider.applyFilter(filterModel),
          onClear: () => provider.applyFilter(null),
          child: Column(
            children: [
              CustomDropdown(
                items: type,
                onSelected: _onTypeSelected,
                title: 'Type',
                selected: filterModel.typeSelected,
                error: null,
              ),
              CountryDropDown(
                onSelected: _onCountrySelected,
                selectedCountry: filterModel.country.selected,
                required: true,
                countries: filterModel.country.options,
                error: filterModel.country.error.errorMessage,
              ),
              StateDropDown(
                onSelected: (a) => {filterModel.state.reset(a), _refresh()},
                states: filterModel.country.selected?.states ?? [],
                required: true,
                selectedState: filterModel.state.value,
                error: filterModel.state.error.errorMessage,
              ),
              TextFieldWithTitle(
                title: 'Street',
                controller: filterModel.street.controller,
                required: true,
                error: filterModel.street.error.errorMessage,
                onChanged: (a) => {filterModel.street.resetError(), _refresh()},
              ),
            ],
          ),
        );
      },
    );
  }

  void _onCountrySelected(Country? a) {
    if (filterModel.country.selected != a) filterModel.country.reset(null);
    filterModel.country.reset(a);
    _refresh();
  }

  void _onTypeSelected(a) {
    filterModel.typeSelected = a;
    _refresh();
  }

  void _refresh() => mounted ? setState(() {}) : null;
}

class BranchFilterModel extends FilterModel<BranchFilterModel> {
  CommonKeyValueModel? typeSelected;
  DropDownParam<Country> country = DropDownParam(options: []);
  StringParam state = StringParam();
  TextFieldParam street = TextFieldParam();

  @override
  List<UrlQuery> getFilterQueries() {
    return [
      UrlQuery(key: 'type', value: typeSelected?.id),
      UrlQuery(key: 'country', value: country.selected?.name),
      UrlQuery(key: 'state', value: state.value),
      UrlQuery(key: 'street', value: street.text),
    ];
  }

  @override
  BranchFilterModel copy(BranchFilterModel copyFrom) {
    final newModel = BranchFilterModel();
    newModel.typeSelected = copyFrom.typeSelected;
    newModel.country = copyFrom.country;
    newModel.state = copyFrom.state;
    newModel.street = copyFrom.street;
    return newModel;
  }
}
