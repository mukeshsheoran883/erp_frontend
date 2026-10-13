import 'package:invently/assortment/network/api_helper.dart';
import 'package:invently/assortment/network/api_manager_models.dart';
import 'package:invently/assortment/network/endpoints.dart';
import 'package:invently/models/purchase/stock_rejected_transfer_model.dart';
import 'package:invently/utils/static_values.dart';

class StockRejectedTransferService {
  static UrlQuery _stockRejectedTransferCode(String stockRejectedTransferCode) =>
      UrlQuery(key: 'stock_rejected_transfer_code', value: stockRejectedTransferCode);

  static Future<ApiResponseModel<List<StockRejectedTransferModel>>> getStockRejectedTransferList({
    required int pageNumber,
    required String searchKey,
    // required ReturnedPurchaseFilterModel? filter,
  }) async {
    return await DioHelper(
      method: ApiMethods.get,
      url: Endpoint.stockRejectedTransferList(search: searchKey.trim().isNotEmpty),
      queries: [
        Query.pageNumber(pageNumber),
        Query.countLimit(),
        Query.search(searchKey),
        // if (filter != null) ...filter.getFilterQueries(),
      ],
      fromJson: StockRejectedTransferModel.listFromJson,
    ).call();
  }

  static Future<ApiResponseModel<StockRejectedTransferModel>> getStockRejectedTransfer({
    required String stockRejectedTransferCode,
  }) async {
    return await DioHelper(
      method: ApiMethods.get,
      url: Endpoint.getStockAvailable(),
      queries: [_stockRejectedTransferCode(stockRejectedTransferCode)],
      fromJson: StockRejectedTransferModel.fromJson,
    ).call();
  }

  static Future<ApiResponseModel> createStockRejectedTransfer(StockRejectedTransferModel model) async {
    return await DioHelper(
      method: ApiMethods.post,
      url: Endpoint.addStockAvailable(),
      body: model.toJson(),
      fromJson: (p0) => {},
    ).call();
  }

  static Future<ApiResponseModel> multiStockRejectedTransfer({required List<String> deleteList}) async {
    return await DioHelper(
      method: ApiMethods.patch,
      url: Endpoint.deleteStockAvailable(),
      body: {'stock_rejected_code': deleteList.map((stockRejectedTransfer) => stockRejectedTransfer).toList()},
      fromJson: (p0) {},
    ).call();
  }

  static Future<ApiResponseModel> updateStockRejectedTransfer(StockRejectedTransferModel model) async {
    return await DioHelper(
      method: ApiMethods.put,
      url: Endpoint.updateStockAvailable(),
      body: model.toJson(),
      fromJson: (p0) => {},
    ).call();
  }
}
