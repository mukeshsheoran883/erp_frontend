import 'package:invently/assortment/network/api_helper.dart';
import 'package:invently/assortment/network/api_manager_models.dart';
import 'package:invently/assortment/network/endpoints.dart';
import 'package:invently/models/sales/return_item_model.dart';
import 'package:invently/ui/sales/return_item/widgets/filter_section.dart';
import 'package:invently/utils/static_values.dart';

class ReturnItemService {
  static UrlQuery _returnItemCode(String returnItemCode) => UrlQuery(key: 'return_item_cod', value: returnItemCode);

  static Future<ApiResponseModel<List<ReturnItemModel>>> getReturnItemList({
    required int pageNumber,
    required String searchKey,
    required ReturnItemFilterModel? filter,
  }) async {
    return await DioHelper(
      method: ApiMethods.get,
      url: Endpoint.returnItemList(search: searchKey.trim().isNotEmpty),
      queries: [
        Query.pageNumber(pageNumber),
        Query.countLimit(),
        Query.search(searchKey),
        if (filter != null) ...filter.getFilterQueries(),
      ],
      fromJson: ReturnItemModel.listFromJson,
    ).call();
  }

  static Future<ApiResponseModel<ReturnItemModel>> getReturnItem({required String returnItemCode}) async {
    return await DioHelper(
      method: ApiMethods.get,
      url: Endpoint.getReturnItem(),
      queries: [_returnItemCode(returnItemCode)],
      fromJson: ReturnItemModel.fromJson,
    ).call();
  }

  static Future<ApiResponseModel> createReturnItem(ReturnCreateModel model) async {
    return await DioHelper(
      method: ApiMethods.post,
      url: Endpoint.addReturnItem(),
      body: model.toJson(),
      fromJson: (p0) => {},
    ).call();
  }

  static Future<ApiResponseModel> multiDeleteReturnItem({required List<String> deleteList}) async {
    return await DioHelper(
      method: ApiMethods.patch,
      url: Endpoint.deleteReturnItem(),
      body: {'return_item_cod': deleteList.map((supplier) => supplier).toList()},
      fromJson: (p0) {},
    ).call();
  }

  static Future<ApiResponseModel> updateReturnItem(ReturnCreateModel model) async {
    return await DioHelper(
      method: ApiMethods.put,
      url: Endpoint.updateReturnItem(),
      body: model.toJson(),
      fromJson: (p0) => {},
    ).call();
  }
}