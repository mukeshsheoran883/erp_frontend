import 'package:invently/assortment/network/api_helper.dart';
import 'package:invently/assortment/network/api_manager_models.dart';
import 'package:invently/assortment/network/endpoints.dart';
import 'package:invently/models/quotations/quotations_model.dart';
import 'package:invently/utils/static_values.dart';

class QuotationsService {
  static UrlQuery _quotationsCode(String quotationsCode) => UrlQuery(key: 'quotations_code', value: quotationsCode);

  static Future<ApiResponseModel<List<QuotationsModel>>> getQuotationsList({
    required int pageNumber,
    required String searchKey,
    // required ReturnedPurchaseFilterModel? filter,
  }) async {
    return await DioHelper(
      method: ApiMethods.get,
      url: Endpoint.quotationsList(search: searchKey.trim().isNotEmpty),
      queries: [
        Query.pageNumber(pageNumber),
        Query.countLimit(),
        Query.search(searchKey),
        // if (filter != null) ...filter.getFilterQueries(),
      ],
      fromJson: QuotationsModel.listFromJson,
    ).call();
  }

  static Future<ApiResponseModel<QuotationsModel>> getQuotations({required String quotationsCode}) async {
    return await DioHelper(
      method: ApiMethods.get,
      url: Endpoint.getQuotations(),
      queries: [_quotationsCode(quotationsCode)],
      fromJson: QuotationsModel.fromJson,
    ).call();
  }

  static Future<ApiResponseModel> createQuotations(QuotationCreateModel model) async {
    return await DioHelper(
      method: ApiMethods.post,
      url: Endpoint.addQuotations(),
      body: model.toJson(),
      fromJson: (p0) => {},
    ).call();
  }

  static Future<ApiResponseModel> multiQuotations({required List<String> deleteList}) async {
    return await DioHelper(
      method: ApiMethods.patch,
      url: Endpoint.deleteQuotations(),
      body: {'quotations_code': deleteList.map((quotations) => quotations).toList()},
      fromJson: (p0) {},
    ).call();
  }

  static Future<ApiResponseModel> updateQuotations(QuotationCreateModel model) async {
    return await DioHelper(
      method: ApiMethods.put,
      url: Endpoint.updateQuotations(),
      body: model.toJson(),
      fromJson: (p0) => {},
    ).call();
  }
}
