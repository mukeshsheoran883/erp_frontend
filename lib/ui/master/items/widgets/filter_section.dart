import 'package:invently/assortment/extensions/string_extensions.dart';
import 'package:invently/assortment/network/api_manager_models.dart';
import 'package:invently/models/brand/brand_model.dart';
import 'package:invently/models/category/category_model.dart';
import 'package:invently/models/common/common_id_value_model.dart';
import 'package:invently/models/common/filter_model.dart';
import 'package:invently/models/common/form_models.dart';
import 'package:invently/models/supplier/supplier_model.dart';
import 'package:invently/network/brand_service.dart';
import 'package:invently/network/category_service.dart';
import 'package:invently/network/supplier_service.dart';
import 'package:invently/provider/master/item_provider.dart';
import 'package:invently/utils/static_values.dart';
import 'package:invently/utils/theme/colors/colors.dart';
import 'package:invently/utils/theme/text_style/text_styles.dart';
import 'package:invently/widgets/custom_drop_down.dart';
import 'package:invently/widgets/date_time_picker/date_time_field.dart';
import 'package:invently/widgets/date_time_picker/date_time_picker.dart';
import 'package:invently/widgets/page_widgets/filter_section.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ItemFilterSection extends StatefulWidget {
  const ItemFilterSection({super.key});

  @override
  State<ItemFilterSection> createState() => _ItemFilterSectionState();
}

class _ItemFilterSectionState extends State<ItemFilterSection> {
  ValueNotifier<List<CommonKeyValueModel>> brand = ValueNotifier([]);

  ValueNotifier<List<CommonKeyValueModel>> category = ValueNotifier([]);

  ValueNotifier<List<CommonKeyValueModel>> supplier = ValueNotifier([]);

  ItemFilterModel filterModel = ItemFilterModel();

  _getItem() async {
    final response = await Future.wait([
      BrandService.getAllBrandList(),
      CategoryService.getAllCategoryList(),
      SupplierService.getAllSupplierList(),
    ]);

    ApiResponseModel<List<BrandModel>> brandResponse = response[0] as ApiResponseModel<List<BrandModel>>;
    ApiResponseModel<List<CategoryModel>> categoryResponse = response[1] as ApiResponseModel<List<CategoryModel>>;
    ApiResponseModel<List<SupplierModel>> supplierResponse = response[2] as ApiResponseModel<List<SupplierModel>>;

    brand.value =
        brandResponse.data!.map((e) => CommonKeyValueModel(id: e.brandCode, value: e.name.toPascalCase())).toList();
    category.value = categoryResponse.data!
        .map((e) => CommonKeyValueModel(id: e.categoryCode, value: e.name.toPascalCase()))
        .toList();
    supplier.value = supplierResponse.data!
        .map((e) => CommonKeyValueModel(id: e.supplierCode, value: e.name.toPascalCase()))
        .toList();
  }

  @override
  void initState() {
    _getItem();
    final provider = context.read<ItemProvider>();
    if (provider.filterModel != null) filterModel = filterModel.copy(provider.filterModel!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ItemProvider>(
      builder: (context, provider, child) {
        return FilterSection(
          onApply: () => provider.applyFilter(filterModel),
          onClear: () => provider.applyFilter(null),
          child: Column(
            children: [
              CustomDropdown(
                items: brand,
                onSelected: _onBrandSelected,
                title: 'Brand',
                selected: filterModel.brandSelected,
                error: null,
              ),
              CustomDropdown(
                items: category,
                onSelected: _onCategorySelected,
                title: 'Category',
                selected: filterModel.categorySelected,
                error: null,
              ),
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

  void _onBrandSelected(a) {
    filterModel.brandSelected = a;
    _refresh();
  }

  void _onCategorySelected(a) {
    filterModel.categorySelected = a;
    _refresh();
  }

  void _onSupplierSelected(a) {
    filterModel.supplierStatusSelected = a;
    _refresh();
  }

  void _refresh() => mounted ? setState(() {}) : null;
}

class ItemFilterModel extends FilterModel<ItemFilterModel> {
  CommonKeyValueModel? brandSelected;
  CommonKeyValueModel? categorySelected;
  CommonKeyValueModel? supplierStatusSelected;
  DateTimeParam? date = DateTimeParam();
  DateTimeParam? time = DateTimeParam();

  @override
  List<UrlQuery> getFilterQueries() {
    return [
      UrlQuery(key: 'brand', value: brandSelected?.id),
      UrlQuery(key: 'category', value: categorySelected?.id),
      UrlQuery(key: 'supplier', value: supplierStatusSelected?.id),
      UrlQuery(
        key: 'date',
        value: date!.dateTime != null ? StaticValues.commonDateFormatSlash.format(date!.dateTime!) : '',
      ),
      UrlQuery(key: 'time', value: time!.dateTime != null ? StaticValues.commonTimeFormat.format(time!.dateTime!) : ''),
    ];
  }

  @override
  ItemFilterModel copy(ItemFilterModel copyFrom) {
    final newModel = ItemFilterModel();
    newModel.brandSelected = copyFrom.brandSelected;
    newModel.categorySelected = copyFrom.categorySelected;
    newModel.supplierStatusSelected = copyFrom.supplierStatusSelected;
    newModel.date = copyFrom.date;
    newModel.time = copyFrom.time;
    return newModel;
  }
}
