import 'package:invently/assortment/network/api_helper.dart';
import 'package:invently/assortment/network/api_manager_models.dart';
import 'package:invently/assortment/network/endpoints.dart';
import 'package:invently/models/tax/tax_model.dart';
import 'package:invently/utils/static_values.dart';

class TaxService {
  static UrlQuery _taxCode(String taxCode) => UrlQuery(key: 'tax_code', value: taxCode);

  static Future<ApiResponseModel<List<TaxModel>>> getTaxList({
    required int pageNumber,
    required String searchKey,
    String? filterKey,
    String? filterValue,
    String? sortBy,
    String? sortOrder,
    String? value,
  }) async {
    return await DioHelper(
      method: ApiMethods.get,
      url: Endpoint.taxList(search: searchKey.trim().isNotEmpty),
      queries: [
        Query.pageNumber(pageNumber),
        Query.countLimit(),
        Query.search(searchKey),
      ],
      fromJson: TaxModel.listFromJson,
    ).call();
  }

  static Future<ApiResponseModel<List<TaxModel>>> getAllTaxList({String? accessToken}) async {
    return await DioHelper(
      method: ApiMethods.get,
      url: Endpoint.taxList(),
      queries: [Query.countLimit(pagination: false)],
      fromJson: TaxModel.listFromJson,
      headers: accessToken == null ? null : StaticValues.defaultHeaders(token: accessToken),
    ).call();
  }

  static Future<ApiResponseModel<TaxModel>> getTax({required String taxCode}) async {
    return await DioHelper(
      method: ApiMethods.get,
      url: Endpoint.getTex(),
      queries: [_taxCode(taxCode)],
      fromJson: TaxModel.fromJson,
    ).call();
  }

  static Future<ApiResponseModel> createTax(TaxModel model) async {
    return await DioHelper(
      method: ApiMethods.post,
      url: Endpoint.addTax(),
      body: model.toJson(),
      fromJson: (p0) => {},
    ).call();
  }

  static Future<ApiResponseModel> multiDeleteTax({required List<String> deleteList}) async {
    return await DioHelper(
      method: ApiMethods.patch,
      url: Endpoint.deleteTaxes(),
      body: {'tax_codes': deleteList.map((e) => e).toList()},
      fromJson: (p0) {},
    ).call();
  }

  static Future<ApiResponseModel> updateTax(TaxModel model) async {
    return await DioHelper(
      method: ApiMethods.put,
      url: Endpoint.updateTax(),
      body: model.toJson(),
      fromJson: (p0) => {},
    ).call();
  }
}
