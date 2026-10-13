import 'package:invently/assortment/network/api_helper.dart';
import 'package:invently/assortment/network/api_manager_models.dart';
import 'package:invently/assortment/network/endpoints.dart';
import 'package:invently/models/purchase/purchase_model.dart';
import 'package:invently/ui/purchase/purchase_list/widgets/filter_section.dart';
import 'package:invently/utils/static_values.dart';

class PurchaseService {
  static UrlQuery _purchaseCode(String purchaseCode) => UrlQuery(key: 'purchase_code', value: purchaseCode);

  static Future<ApiResponseModel<List<PurchaseModel>>> getPurchaseList({
    required int pageNumber,
    required String searchKey,
    required PurchaseFilterModel? filter,
  }) async {
    return await DioHelper(
      method: ApiMethods.get,
      url: Endpoint.purchaseList(search: searchKey.trim().isNotEmpty),
      queries: [
        Query.pageNumber(pageNumber),
        Query.countLimit(),
        Query.search(searchKey),
        if (filter != null) ...filter.getFilterQueries(),
      ],
      fromJson: PurchaseModel.listFromJson,
    ).call();
  }

  static Future<ApiResponseModel<PurchaseEditModel>> getPurchase({required String purchaseCode}) async {
    return await DioHelper(
      method: ApiMethods.get,
      url: Endpoint.getPurchase(),
      queries: [_purchaseCode(purchaseCode)],
      fromJson: PurchaseEditModel.fromJson,
    ).call();
  }

  static Future<ApiResponseModel<PurchaseDetailModel>> getPurchases({required String purchaseCode}) async {
    return await DioHelper(
      method: ApiMethods.get,
      url: Endpoint.getPurchase(),
      queries: [_purchaseCode(purchaseCode)],
      fromJson: PurchaseDetailModel.fromJson,
    ).call();
  }

  static Future<ApiResponseModel> createPurchase(PurchaseCreateModel model) async {
    return await DioHelper(
      method: ApiMethods.post,
      url: Endpoint.addPurchase(),
      body: model.toJson(),
      fromJson: (p0) => {},
    ).call();
  }

  static Future<ApiResponseModel> multiDeletePurchase({required List<String> deleteList}) async {
    return await DioHelper(
      method: ApiMethods.patch,
      url: Endpoint.multiDeleteItem(),
      body: {'purchase_code': deleteList.map((supplier) => supplier).toList()},
      fromJson: (p0) {},
    ).call();
  }

  static Future<ApiResponseModel> updatePurchase(PurchaseCreateModel model) async {
    return await DioHelper(
      method: ApiMethods.put,
      url: Endpoint.updateItem(),
      body: model.toJson(),
      fromJson: (p0) => {},
    ).call();
  }
}