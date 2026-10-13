import 'package:invently/assortment/network/api_manager_models.dart';
import 'package:invently/models/common/country_codes.dart';
import 'package:invently/models/common/filter_model.dart';
import 'package:invently/models/common/form_models.dart';
import 'package:invently/provider/master/customer_provider.dart';
import 'package:invently/widgets/form_widgets/country_drop_down.dart';
import 'package:invently/widgets/form_widgets/state_drop_down.dart';
import 'package:invently/widgets/page_widgets/filter_section.dart';
import 'package:invently/widgets/text_widget/text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomerFilterSection extends StatefulWidget {
  const CustomerFilterSection({super.key});

  @override
  State<CustomerFilterSection> createState() => _CustomerFilterSectionState();
}

class _CustomerFilterSectionState extends State<CustomerFilterSection> {
  CustomerFilterModel filterModel = CustomerFilterModel();

  _getCustomer() async {
    filterModel.country.options = await Countries.loadCodesFromFile();
    _refresh();
  }

  @override
  void initState() {
    final provider = context.read<CustomerProvider>();
    if (provider.filterModel != null) filterModel = filterModel.copy(provider.filterModel!);
    _getCustomer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CustomerProvider>(
      builder: (context, provider, child) {
        return FilterSection(
          onApply: () => provider.applyFilter(filterModel),
          onClear: () => provider.applyFilter(null),
          child: Column(
            children: [
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

  void _refresh() => mounted ? setState(() {}) : null;
}

class CustomerFilterModel extends FilterModel<CustomerFilterModel> {
  DropDownParam<Country> country = DropDownParam(options: []);
  StringParam state = StringParam();
  TextFieldParam street = TextFieldParam();

  @override
  List<UrlQuery> getFilterQueries() {
    return [
      UrlQuery(key: 'country', value: country.selected?.name),
      UrlQuery(key: 'state', value: state.value),
      UrlQuery(key: 'street', value: street.text),
    ];
  }

  @override
  CustomerFilterModel copy(CustomerFilterModel copyFrom) {
    final newModel = CustomerFilterModel();
    newModel.country = copyFrom.country;
    newModel.state = copyFrom.state;
    newModel.street = copyFrom.street;
    return newModel;
  }
}
