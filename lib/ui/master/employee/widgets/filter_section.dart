
import 'package:invently/assortment/network/api_manager_models.dart';
import 'package:invently/models/common/common_id_value_model.dart';
import 'package:invently/models/common/filter_model.dart';
import 'package:invently/provider/master/employee_provider.dart';
import 'package:invently/widgets/custom_drop_down.dart';
import 'package:invently/widgets/page_widgets/filter_section.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EmployeeFilterSection extends StatefulWidget {
  const EmployeeFilterSection({super.key});

  @override
  State<EmployeeFilterSection> createState() => _EmployeeFilterSectionState();
}

class _EmployeeFilterSectionState extends State<EmployeeFilterSection> {
  ValueNotifier<List<CommonKeyValueModel>> employeeStatus = ValueNotifier([
    CommonKeyValueModel(id: 'true', value: 'Active'),
    CommonKeyValueModel(id: 'false', value: 'Inactive'),
  ]);

  EmployeeFilterModel filterModel = EmployeeFilterModel();

  @override
  void initState() {
    final provider = context.read<EmployeeProvider>();
    if (provider.filterModel != null) filterModel = filterModel.copy(provider.filterModel!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EmployeeProvider>(
      builder: (context, provider, child) {
        return FilterSection(
          onApply: () => provider.applyFilter(filterModel),
          onClear: () => provider.applyFilter(null),
          child: Column(
            children: [
              CustomDropdown(
                items: employeeStatus,
                onSelected: _onStatusSelected,
                title: 'Emp. Status',
                selected: filterModel.employeeStatusSelected,
                error: null,
              ),
            ],
          ),
        );
      },
    );
  }

  void _onStatusSelected(a) {
    filterModel.employeeStatusSelected = a;
    _refresh();
  }

  void _refresh() => mounted ? setState(() {}) : null;
}

class EmployeeFilterModel extends FilterModel<EmployeeFilterModel> {
  CommonKeyValueModel? employeeStatusSelected;

  @override
  List<UrlQuery> getFilterQueries() {
    return [
      UrlQuery(key: 'is_active', value: employeeStatusSelected?.id),
    ];
  }

  @override
  EmployeeFilterModel copy(EmployeeFilterModel copyFrom) {
    final newModel = EmployeeFilterModel();
    newModel.employeeStatusSelected = copyFrom.employeeStatusSelected;

    return newModel;
  }
}
