import 'package:invently/assortment/network/api_helper.dart';
import 'package:invently/assortment/network/api_manager_models.dart';
import 'package:invently/assortment/network/endpoints.dart';
import 'package:invently/models/purchase/stock_completed_transfer_model.dart';
import 'package:invently/utils/static_values.dart';

class StockCompletedTransferService {
  static UrlQuery _stockCompletedTransferCode(String stockCompletedTransferCode) => UrlQuery(key: 'stock_pending_transfer_code', value: stockCompletedTransferCode);

  static Future<ApiResponseModel<List<StockCompletedTransferModel>>> getStockCompletedTransferList({
    required int pageNumber,
    required String searchKey,
    // required ReturnedPurchaseFilterModel? filter,
  }) async {
    return await DioHelper(
      method: ApiMethods.get,
      url: Endpoint.stockCompletedTransferList(search: searchKey.trim().isNotEmpty),
      queries: [
        Query.pageNumber(pageNumber),
        Query.countLimit(),
        Query.search(searchKey),
        // if (filter != null) ...filter.getFilterQueries(),
      ],
      fromJson: StockCompletedTransferModel.listFromJson,
    ).call();
  }

  static Future<ApiResponseModel<StockCompletedTransferModel>> getStockCompletedTransfer({required String stockCompletedTransferCode}) async {
    return await DioHelper(
      method: ApiMethods.get,
      url: Endpoint.getStockAvailable(),
      queries: [_stockCompletedTransferCode(stockCompletedTransferCode)],
      fromJson: StockCompletedTransferModel.fromJson,
    ).call();
  }

  static Future<ApiResponseModel> createStockCompletedTransfer(StockCompletedTransferModel model) async {
    return await DioHelper(
      method: ApiMethods.post,
      url: Endpoint.addStockAvailable(),
      body: model.toJson(),
      fromJson: (p0) => {},
    ).call();
  }

  static Future<ApiResponseModel> multiStockCompletedTransfer({required List<String> deleteList}) async {
    return await DioHelper(
      method: ApiMethods.patch,
      url: Endpoint.deleteStockAvailable(),
      body: {'stock_available_code': deleteList.map((stockAvailable) => stockAvailable).toList()},
      fromJson: (p0) {},
    ).call();
  }

  static Future<ApiResponseModel> updateStockCompletedTransfer(StockCompletedTransferModel model) async {
    return await DioHelper(
      method: ApiMethods.put,
      url: Endpoint.updateStockAvailable(),
      body: model.toJson(),
      fromJson: (p0) => {},
    ).call();
  }
}
