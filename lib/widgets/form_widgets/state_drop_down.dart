
import 'package:invently/models/common/common_id_value_model.dart';
import 'package:invently/widgets/custom_drop_down.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class StateDropDown extends StatefulWidget {
  final String title;
  final bool required;
  final Function(String?)? onSelected;
  final String? selectedState;
  final List<String> states;
  final String? error;

  const StateDropDown({
    super.key,
    this.title = 'State or Province',
    this.required = false,
    required this.onSelected,
    required this.states,
    this.selectedState,
    this.error,
  });

  @override
  State<StateDropDown> createState() => _StateDropDownState();
}

class _StateDropDownState extends State<StateDropDown> {
  late TextEditingController searchController;

  ValueNotifier<List<CommonKeyValueModel>> states = ValueNotifier([]);

  @override
  void initState() {
    searchController = TextEditingController();
    searchController.addListener(_listener);

    super.initState();
  }

  void _listener() {
    String text = searchController.text.trim().toLowerCase();
    final allStates = widget.states.map((e) => CommonKeyValueModel(id: e, value: e)).toList();

    states.value =
        text.isEmpty ? allStates : allStates.where((e) => e.value.toLowerCase().trim().startsWith(text)).toList();
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
      items: states,
      onSelected: (a) => widget.onSelected?.call(widget.states.firstWhereOrNull((e) => e == a?.id)),
      title: widget.title,
      required: widget.required,
      onClearTap: () => searchController.text = '',
      searchController: searchController,
      error: widget.error,
      selected: widget.selectedState == null
          ? null
          : CommonKeyValueModel(id: widget.selectedState!, value: widget.selectedState!),
    );
  }
}
