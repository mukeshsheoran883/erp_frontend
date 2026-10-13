import 'package:invently/assortment/network/api_helper.dart';
import 'package:invently/assortment/network/api_manager_models.dart';
import 'package:invently/assortment/network/endpoints.dart';
import 'package:invently/models/items/item_model.dart';
import 'package:invently/ui/master/items/widgets/filter_section.dart';
import 'package:invently/utils/static_values.dart';

class ItemService {
  static UrlQuery _itemCode(String itemsCode) => UrlQuery(key: 'item_code', value: itemsCode);

  static Future<ApiResponseModel<List<ItemModel>>> getItemsList({
    required int pageNumber,
    required String searchKey,
    required ItemFilterModel? filter,
  }) async {
    return await DioHelper(
      method: ApiMethods.get,
      url: Endpoint.itemList(search: searchKey.trim().isNotEmpty),
      queries: [
        Query.pageNumber(pageNumber),
        Query.countLimit(),
        Query.search(searchKey),
        if (filter != null) ...filter.getFilterQueries(),
      ],
      fromJson: ItemModel.listFromJson,
    ).call();
  }

  static Future<ApiResponseModel<ItemModel>> getItem({required String itemCode}) async {
    return await DioHelper(
      method: ApiMethods.get,
      url: Endpoint.getItem(),
      queries: [_itemCode(itemCode)],
      fromJson: ItemModel.fromJson,
    ).call();
  }

  static Future<ApiResponseModel> createItem(ItemCreateModel model) async {
    return await DioHelper(
      method: ApiMethods.post,
      url: Endpoint.addItem(),
      body: model.toJson(),
      fromJson: (p0) => {},
    ).call();
  }

  static Future<ApiResponseModel> multiDeleteItem({required List<String> deleteList}) async {
    return await DioHelper(
      method: ApiMethods.patch,
      url: Endpoint.multiDeleteItem(),
      body: {'item_code': deleteList.map((supplier) => supplier).toList()},
      fromJson: (p0) {},
    ).call();
  }

  static Future<ApiResponseModel> updateItem(ItemCreateModel model) async {
    return await DioHelper(
      method: ApiMethods.put,
      url: Endpoint.updateItem(),
      body: model.toJson(),
      fromJson: (p0) => {},
    ).call();
  }
}
