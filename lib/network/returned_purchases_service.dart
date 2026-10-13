import 'package:invently/assortment/network/api_helper.dart';
import 'package:invently/assortment/network/api_manager_models.dart';
import 'package:invently/assortment/network/endpoints.dart';
import 'package:invently/models/purchase/returned_purchases_model.dart';
import 'package:invently/ui/purchase/returned_purchases/widgets/filter_section.dart';
import 'package:invently/utils/static_values.dart';

class ReturnedPurchasesService {
  static UrlQuery _returnedPurchaseCode(String returnedPurchaseCode) => UrlQuery(key: 'return_code', value: returnedPurchaseCode);

  static Future<ApiResponseModel<List<ReturnedPurchaseModel>>> getReturnedPurchaseList({
    required int pageNumber,
    required String searchKey,
    required ReturnedPurchaseFilterModel? filter,
  }) async {
    return await DioHelper(
      method: ApiMethods.get,
      url: Endpoint.returnedPurchaseList(search: searchKey.trim().isNotEmpty),
      queries: [
        Query.pageNumber(pageNumber),
        Query.countLimit(),
        Query.search(searchKey),
        if (filter != null) ...filter.getFilterQueries(),
      ],
      fromJson: ReturnedPurchaseModel.listFromJson,
    ).call();
  }

  static Future<ApiResponseModel<ReturnedPurchaseModel>> getReturnedPurchase({required String purchaseCode}) async {
    return await DioHelper(
      method: ApiMethods.get,
      url: Endpoint.getReturnedPurchase(),
      queries: [_returnedPurchaseCode(purchaseCode)],
      fromJson: ReturnedPurchaseModel.fromJson,
    ).call();
  }


  static Future<ApiResponseModel<ReturnedPurchaseModel>> getReturnedPurchaseDummy({required String purchaseCode}) async {
    return await DioHelper(
      method: ApiMethods.get,
      url: Endpoint.getReturnedPurchaseDummy(),
      // isDummy: true,
      // queries: [_returnedPurchaseCode(purchaseCode)],
      fromJson: ReturnedPurchaseModel.fromJson,
    ).call();
  }

  static Future<ApiResponseModel> createReturnedPurchase(ReturnedPurchaseModel model) async {
    return await DioHelper(
      method: ApiMethods.post,
      url: Endpoint.addReturnedPurchase(),
      body: model.toJson(),
      fromJson: (p0) => {},
    ).call();
  }

  static Future<ApiResponseModel> multiDeletePurchase({required List<String> deleteList}) async {
    return await DioHelper(
      method: ApiMethods.patch,
      url: Endpoint.deleteReturnedPurchase(),
      body: {'purchase_code': deleteList.map((supplier) => supplier).toList()},
      fromJson: (p0) {},
    ).call();
  }

  static Future<ApiResponseModel> updateReturnedPurchase(ReturnedPurchaseModel model) async {
    return await DioHelper(
      method: ApiMethods.put,
      url: Endpoint.updateReturnedPurchase(),
      body: model.toJson(),
      fromJson: (p0) => {},
    ).call();
  }
}
