import 'package:invently/assortment/network/api_helper.dart';
import 'package:invently/assortment/network/api_manager_models.dart';
import 'package:invently/assortment/network/endpoints.dart';
import 'package:invently/models/supplier/supplier_model.dart';
import 'package:invently/ui/master/supplier/widgets/filter_section.dart';
import 'package:invently/utils/static_values.dart';

class SupplierService {
  static UrlQuery _supplierCode(String suppliersCode) => UrlQuery(key: 'supplier_code', value: suppliersCode);

  static Future<ApiResponseModel<List<SupplierModel>>> getSupplierList({
    required int pageNumber,
    required String searchKey,
    required SupplierFilterModel? filter,
  }) async {
    return await DioHelper(
      method: ApiMethods.get,
      url: Endpoint.supplierList(search: searchKey.trim().isNotEmpty),
      queries: [
        Query.pageNumber(pageNumber),
        Query.countLimit(),
        Query.search(searchKey),
        if (filter != null) ...filter.getFilterQueries(),
      ],
      fromJson: SupplierModel.listFromJson,
    ).call();
  }

  static Future<ApiResponseModel<List<SupplierModel>>> getAllSupplierList({String? accessToken}) async {
    return await DioHelper(
      method: ApiMethods.get,
      url: Endpoint.supplierList(),
      queries: [Query.countLimit(pagination: false)],
      fromJson: SupplierModel.listFromJson,
      headers: accessToken == null ? null : StaticValues.defaultHeaders(token: accessToken),
    ).call();
  }

  static Future<ApiResponseModel<SupplierModel>> getSupplier({required String suppliersCode}) async {
    return await DioHelper(
      method: ApiMethods.get,
      url: Endpoint.getSupplier(),
      queries: [_supplierCode(suppliersCode)],
      fromJson: SupplierModel.fromJson,
    ).call();
  }

  static Future<ApiResponseModel> createSupplier(SupplierModel model) async {
    return await DioHelper(
      method: ApiMethods.post,
      url: Endpoint.addSupplier(),
      body: model.toJson(),
      fromJson: (p0) => {},
    ).call();
  }

  static Future<ApiResponseModel> multiDeleteSupplier({required List<String> deleteList}) async {
    return await DioHelper(
      method: ApiMethods.patch,
      url: Endpoint.multiDeleteSuppliers(),
      body: {'supplier_code': deleteList.map((supplier) => supplier).toList()},
      fromJson: (p0) {},
    ).call();
  }

  static Future<ApiResponseModel> updateSupplier(SupplierModel model) async {
    return await DioHelper(
      method: ApiMethods.put,
      url: Endpoint.updateSupplier(),
      body: model.toJson(),
      fromJson: (p0) => {},
    ).call();
  }
}
