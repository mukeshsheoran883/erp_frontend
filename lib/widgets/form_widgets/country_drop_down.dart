
import 'package:invently/models/common/common_id_value_model.dart';
import 'package:invently/models/common/country_codes.dart';
import 'package:invently/widgets/custom_drop_down.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class CountryDropDown extends StatefulWidget {
  final String title;
  final bool required;
  final Function(Country?)? onSelected;
  final Country? selectedCountry;
  final List<Country> countries;
  final String? error;

  const CountryDropDown({
    super.key,
    this.title = 'Country',
    this.required = false,
    required this.onSelected,
    required this.countries,
    this.selectedCountry,
    this.error,
  });

  @override
  State<CountryDropDown> createState() => _CountryDropDownState();
}

class _CountryDropDownState extends State<CountryDropDown> {
  late TextEditingController searchController;

  ValueNotifier<List<CommonKeyValueModel>> countries = ValueNotifier([]);

  @override
  void initState() {
    searchController = TextEditingController();
    searchController.addListener(_listener);
    super.initState();
  }

  void _listener() {
    String text = searchController.text.trim().toLowerCase();
    final allCountries = widget.countries.map((e) => CommonKeyValueModel(id: e.name, value: e.name)).toList();

    countries.value =
        text.isEmpty ? allCountries : allCountries.where((e) => e.value.toLowerCase().trim().startsWith(text)).toList();
  }

  @override
  void dispose() {
    searchController.removeListener(_listener);
    searchController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomDropdown(
      items: countries,
      onSelected: (a) => widget.onSelected?.call(widget.countries.firstWhereOrNull((e) => e.name == a?.id)),
      title: widget.title,
      required: widget.required,
      searchController: searchController,
      error: widget.error,
      onClearTap: () => searchController.text = '',
      selected: widget.selectedCountry == null
          ? null
          : CommonKeyValueModel(id: widget.selectedCountry!.name, value: widget.selectedCountry!.name),
    );
  }
}
