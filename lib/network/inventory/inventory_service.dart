import 'package:invently/assortment/network/api_helper.dart';
import 'package:invently/assortment/network/api_manager_models.dart';
import 'package:invently/assortment/network/endpoints.dart';
import 'package:invently/models/inventory/inventory_model.dart';
import 'package:invently/ui/master/customer/widgets/filter_section.dart';
import 'package:invently/utils/static_values.dart';

class InventoryService {
  static UrlQuery _inventoryCode(String inventoryCode) => UrlQuery(key: 'inventory_code', value: inventoryCode);
  static UrlQuery _inventoryId(String inventoryName) => UrlQuery(key: 'inventory_code', value: inventoryName);

  static Future<ApiResponseModel<List<InventoryModel>>> getInventoryList({
    required int pageNumber,
    required String searchKey,
    // required CustomerFilterModel? filter,
  }) async {
    return await DioHelper(
      method: ApiMethods.get,
      url: Endpoint.inventory(search: searchKey.trim().isNotEmpty),
      queries: [
        Query.pageNumber(pageNumber),
        Query.countLimit(),
        Query.search(searchKey),
        // UrlQuery(key: 'filter_key', value: filterKey ?? ''),
        // UrlQuery(key: 'filter_value', value: filterValue ?? ''),
        // UrlQuery(key: 'sort_by', value: sortBy ?? ''),
        // UrlQuery(key: 'sort_order', value: sortOrder ?? ''),
        // UrlQuery(key: 'value', value: value ?? ''),
      ],
      fromJson: InventoryModel.listFromJson,
    ).call();
  }

  static Future<ApiResponseModel<InventoryModel>> getInventory({required String inventoryCode,required String inventoryName,}) async {
    return await DioHelper(
      method: ApiMethods.get,
      url: Endpoint.getInventory(),
      queries: [_inventoryCode(inventoryCode),_inventoryId(inventoryName)],
      fromJson: InventoryModel.fromJson,
    ).call();
  }

  static Future<ApiResponseModel<List<InventoryLogModel>>> getInventoryLog() async {
    return await DioHelper(
      method: ApiMethods.get,
      url: Endpoint.inventoryLogs(),
      fromJson: InventoryLogModel.listFromJson,
    ).call();
  }

  static Future<ApiResponseModel> createInventory(InventoryModel model) async {
    return await DioHelper(
      method: ApiMethods.post,
      url: Endpoint.addInventory(),
      body: model.toJson(),
      fromJson: (p0) => {},
    ).call();
  }

  static Future<ApiResponseModel> multiDeleteInventory({required List<String> deleteList}) async {
    return await DioHelper(
      method: ApiMethods.patch,
      url: Endpoint.deleteInventory(),
      body: {'name': deleteList.map((e) => e).toList()},
      fromJson: (p0) {},
    ).call();
  }

  static Future<ApiResponseModel> updateInventory(InventoryModel model) async {
    return await DioHelper(
      method: ApiMethods.put,
      url: Endpoint.updateInventory(),
      body: model.toJson(),
      fromJson: (p0) => {},
    ).call();
  }
}
