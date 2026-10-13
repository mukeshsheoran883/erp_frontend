import 'package:invently/assortment/network/api_helper.dart';
import 'package:invently/assortment/network/api_manager_models.dart';
import 'package:invently/assortment/network/endpoints.dart';
import 'package:invently/models/purchase/stock_pending_transfer_model.dart';
import 'package:invently/utils/static_values.dart';

class StockPendingTransferService {
  static UrlQuery _stockPendingTransferCode(String stockPendingTransferCode) =>
      UrlQuery(key: 'stock_pending_transfer_code', value: stockPendingTransferCode);

  static Future<ApiResponseModel<List<StockPendingTransferModel>>> getStockPendingTransferList({
    required int pageNumber,
    required String searchKey,
    // required ReturnedPurchaseFilterModel? filter,
  }) async {
    return await DioHelper(
      method: ApiMethods.get,
      url: Endpoint.stockPendingTransferList(
        search: searchKey.trim().isNotEmpty,
      ),
      queries: [
        Query.pageNumber(pageNumber),
        Query.countLimit(),
        Query.search(searchKey),
        // if (filter != null) ...filter.getFilterQueries(),
      ],
      fromJson: StockPendingTransferModel.listFromJson,
    ).call();
  }

  static Future<ApiResponseModel<StockPendingTransferModel>> getStockPendingTransfer(
      {required String stockPendingTransferCode}) async {
    return await DioHelper(
      method: ApiMethods.get,
      url: Endpoint.getStockPendingTransfer(),
      queries: [_stockPendingTransferCode(stockPendingTransferCode)],
      fromJson: StockPendingTransferModel.fromJson,
    ).call();
  }

  static Future<ApiResponseModel> createStockPendingTransfer(StockPendingTransferModel model) async {
    return await DioHelper(
      method: ApiMethods.post,
      url: Endpoint.addStockAvailable(),
      body: model.toJson(),
      fromJson: (p0) => {},
    ).call();
  }

  static Future<ApiResponseModel> multiStockPendingTransfer({required List<String> deleteList}) async {
    return await DioHelper(
      method: ApiMethods.patch,
      url: Endpoint.deleteStockAvailable(),
      body: {'stock_available_code': deleteList.map((stockAvailable) => stockAvailable).toList()},
      fromJson: (p0) {},
    ).call();
  }

  static Future<ApiResponseModel> updateStockPendingTransfer(StockPendingTransferModel model) async {
    return await DioHelper(
      method: ApiMethods.put,
      url: Endpoint.updateStockAvailable(),
      body: model.toJson(),
      fromJson: (p0) => {},
    ).call();
  }
}
