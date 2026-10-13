import 'package:invently/assortment/extensions/string_extensions.dart';
import 'package:invently/assortment/network/api_manager_models.dart';
import 'package:invently/models/common/common_id_value_model.dart';
import 'package:invently/models/common/filter_model.dart';
import 'package:invently/models/common/form_models.dart';
import 'package:invently/models/supplier/supplier_model.dart';
import 'package:invently/network/supplier_service.dart';
import 'package:invently/provider/sales/bill_history_provider.dart';
import 'package:invently/utils/static_values.dart';
import 'package:invently/utils/theme/colors/colors.dart';
import 'package:invently/utils/theme/text_style/text_styles.dart';
import 'package:invently/widgets/custom_drop_down.dart';
import 'package:invently/widgets/date_time_picker/date_time_field.dart';
import 'package:invently/widgets/date_time_picker/date_time_picker.dart';
import 'package:invently/widgets/page_widgets/filter_section.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BillHistoryFilterSection extends StatefulWidget {
  const BillHistoryFilterSection({super.key});

  @override
  State<BillHistoryFilterSection> createState() => _BillHistoryFilterSectionState();
}

class _BillHistoryFilterSectionState extends State<BillHistoryFilterSection> {
  ValueNotifier<List<CommonKeyValueModel>> supplier = ValueNotifier([]);

  BillHistoryFilterModel filterModel = BillHistoryFilterModel();

  _getPurchase() async {
    final response = await Future.wait([
      SupplierService.getAllSupplierList(),
    ]);

    ApiResponseModel<List<SupplierModel>> supplierResponse = response[0];

    supplier.value = supplierResponse.data!
        .map((e) => CommonKeyValueModel(id: e.supplierCode, value: e.name.toPascalCase()))
        .toList();
  }

  @override
  void initState() {
    _getPurchase();
    final provider = context.read<BillHistoryProvider>();
    if (provider.filterModel != null) filterModel = filterModel.copy(provider.filterModel!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BillHistoryProvider>(
      builder: (context, provider, child) {
        return FilterSection(
          onApply: () => provider.applyFilter(filterModel),
          onClear: () => provider.applyFilter(null),
          child: Column(
            children: [
              CustomDropdown(
                items: supplier,
                onSelected: _onSupplierSelected,
                title: 'Supplier',
                selected: filterModel.supplierStatusSelected,
                error: null,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text.rich(
                    TextSpan(
                      text: 'Added Date & Time',
                      style: Ts.lgRegular(color: Tm.color(Tc.ipfTitle)),
                      children: [TextSpan(text: ' *', style: Ts.lgRegular(color: Tm.color(Tc.redDef)))],
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: CustomDateTimeField(
                          title: '',
                          pickMode: DatePickMode.timeOnly,
                          error: filterModel.time?.error.errorMessage,
                          initialDateTime: filterModel.time?.dateTime,
                          onDateSelected: (a) => {filterModel.time?.reset(a), _refresh()},
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: CustomDateTimeField(
                          title: '',
                          required: false,
                          pickMode: DatePickMode.dateOnly,
                          error: filterModel.date?.error.errorMessage,
                          initialDateTime: filterModel.date?.dateTime,
                          onDateSelected: (a) => {
                            filterModel.date?.reset(a),
                            _refresh(),
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _onSupplierSelected(a) {
    filterModel.supplierStatusSelected = a;
    _refresh();
  }

  void _refresh() => mounted ? setState(() {}) : null;
}

class BillHistoryFilterModel extends FilterModel<BillHistoryFilterModel> {
  CommonKeyValueModel? supplierStatusSelected;
  DateTimeParam? date = DateTimeParam();
  DateTimeParam? time = DateTimeParam();

  @override
  List<UrlQuery> getFilterQueries() {
    return [
      UrlQuery(key: 'supplier', value: supplierStatusSelected?.id),
      UrlQuery(
        key: 'date',
        value: date!.dateTime != null ? StaticValues.commonDateFormatSlash.format(date!.dateTime!) : '',
      ),
      UrlQuery(key: 'time', value: time!.dateTime != null ? StaticValues.commonTimeFormat.format(time!.dateTime!) : ''),
    ];
  }

  @override
  BillHistoryFilterModel copy(BillHistoryFilterModel copyFrom) {
    final newModel = BillHistoryFilterModel();
    newModel.supplierStatusSelected = copyFrom.supplierStatusSelected;
    newModel.date = copyFrom.date;
    newModel.time = copyFrom.time;
    return newModel;
  }
}
