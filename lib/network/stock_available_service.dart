import 'package:invently/assortment/network/api_helper.dart';
import 'package:invently/assortment/network/api_manager_models.dart';
import 'package:invently/assortment/network/endpoints.dart';
import 'package:invently/models/purchase/stock_available_model.dart';
import 'package:invently/utils/static_values.dart';

class StockAvailableService {
  static UrlQuery _stockAvailableCode(String stockAvailableCode) =>
      UrlQuery(key: 'stock_available_code', value: stockAvailableCode);

  static Future<ApiResponseModel<List<StockAvailableModel>>> getStockAvailableList({
    required int pageNumber,
    required String searchKey,
    // required ReturnedPurchaseFilterModel? filter,
  }) async {
    return await DioHelper(
      method: ApiMethods.get,
      url: Endpoint.stockAvailableList(search: searchKey.trim().isNotEmpty),
      queries: [
        Query.pageNumber(pageNumber),
        Query.countLimit(),
        Query.search(searchKey),
        // if (filter != null) ...filter.getFilterQueries(),
      ],
      fromJson: StockAvailableModel.listFromJson,
    ).call();
  }

  static Future<ApiResponseModel<StockAvailableModel>> getStockAvailable({required String stockAvailableCode}) async {
    return await DioHelper(
      method: ApiMethods.get,
      url: Endpoint.getStockAvailable(),
      queries: [_stockAvailableCode(stockAvailableCode)],
      fromJson: StockAvailableModel.fromJson,
    ).call();
  }

  static Future<ApiResponseModel> createStockAvailable(StockAvailableModel model) async {
    return await DioHelper(
      method: ApiMethods.post,
      url: Endpoint.addStockAvailable(),
      body: model.toJson(),
      fromJson: (p0) => {},
    ).call();
  }

  static Future<ApiResponseModel> multiStockAvailable({required List<String> deleteList}) async {
    return await DioHelper(
      method: ApiMethods.patch,
      url: Endpoint.deleteStockAvailable(),
      body: {'stock_available_code': deleteList.map((stockAvailable) => stockAvailable).toList()},
      fromJson: (p0) {},
    ).call();
  }

  static Future<ApiResponseModel> updateStockAvailable(StockAvailableModel model) async {
    return await DioHelper(
      method: ApiMethods.put,
      url: Endpoint.updateStockAvailable(),
      body: model.toJson(),
      fromJson: (p0) => {},
    ).call();
  }
}
