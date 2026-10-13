import 'package:invently/assortment/network/api_helper.dart';
import 'package:invently/assortment/network/api_manager_models.dart';
import 'package:invently/assortment/network/endpoints.dart';
import 'package:invently/models/pos/pos_model.dart';
import 'package:invently/utils/static_values.dart';

class PosService {
  static UrlQuery _posCode(String posCode) => UrlQuery(key: 'pos_code', value: posCode);
  static UrlQuery _status(String status) => UrlQuery(key: 'status', value: status);

  static Future<ApiResponseModel<List<PosModel>>> getPosList({
    required int pageNumber,
    required String searchKey,
    required String status,
    // required CustomerFilterModel? filter,
  }) async {
    return await DioHelper(
      method: ApiMethods.get,
      url: Endpoint.pos(search: searchKey.trim().isNotEmpty),
      queries: [
        Query.pageNumber(pageNumber),
        Query.countLimit(),
        Query.search(searchKey),
        _status(status),
        // UrlQuery(key: 'filter_key', value: filterKey ?? ''),
        // UrlQuery(key: 'filter_value', value: filterValue ?? ''),
        // UrlQuery(key: 'sort_by', value: sortBy ?? ''),
        // UrlQuery(key: 'sort_order', value: sortOrder ?? ''),
        // UrlQuery(key: 'value', value: value ?? ''),
      ],
      fromJson: PosModel.listFromJson,
    ).call();
  }

  static Future<ApiResponseModel<PosModel>> getPos({required String posCode,required String posId,}) async {
    return await DioHelper(
      method: ApiMethods.get,
      url: Endpoint.getPos(),
      queries: [_posCode(posCode),],
      fromJson: PosModel.fromJson,
    ).call();
  }

  static Future<ApiResponseModel> createPos(PosModel model) async {
    return await DioHelper(
      method: ApiMethods.post,
      url: Endpoint.addPos(),
      body: model.toJson(),
      fromJson: (p0) => {},
    ).call();
  }

// static Future<ApiResponseModel> multiDeleteInventory({required List<String> deleteList}) async {
//   return await DioHelper(
//     method: ApiMethods.patch,
//     url: Endpoint.deleteInventory(),
//     body: {'name': deleteList.map((e) => e).toList()},
//     fromJson: (p0) {},
//   ).call();
// }
//
// static Future<ApiResponseModel> updateInventory(InventoryModel model) async {
//   return await DioHelper(
//     method: ApiMethods.put,
//     url: Endpoint.updateInventory(),
//     body: model.toJson(),
//     fromJson: (p0) => {},
//   ).call();
// }

  static Future<ApiResponseModel> confirmPos({required int posId}) async {
    return await DioHelper(
      method: ApiMethods.put,
      url: Endpoint.posConfirm(),
      body: {'pos_id': posId},
      fromJson: (p0) => {},
    ).call();
  }

  static Future<ApiResponseModel> executePos({required int posId}) async {
    return await DioHelper(
      method: ApiMethods.post,
      url: Endpoint.posExecute(),
      body: {'pos_id': posId},
      fromJson: (p0) => {},
    ).call();
  }

   static Future<ApiResponseModel> dispatchConfirmPos({required int posId}) async {
    return await DioHelper(
      method: ApiMethods.put,
      url: Endpoint.posDispatchConfirm(),
      body: {'pos_id': posId},
      fromJson: (p0) => {},
    ).call();
  }

  static Future<ApiResponseModel> cancelPos({required int posId}) async {
    return await DioHelper(
      method: ApiMethods.put,
      url: Endpoint.posCancel(),
      body: {'pos_id': posId},
      fromJson: (p0) => {},
    ).call();
  }


  static Future<ApiResponseModel> sendPos({required int posId}) async {
    return await DioHelper(
      method: ApiMethods.put,
      url: Endpoint.posSend(),
      body: {'pos_id': posId},
      fromJson: (p0) => {},
    ).call();
  }



  static Future<ApiResponseModel> inventoryConfirmPos({required int posId}) async {
    return await DioHelper(
      method: ApiMethods.put,
      url: Endpoint.posInventoryConfirm(),
      body: {'pos_id': posId},
      fromJson: (p0) => {},
    ).call();
  }

  static Future<ApiResponseModel> deletePos({required int posId}) async {
    return await DioHelper(
      method: ApiMethods.delete,
      url: Endpoint.posDelete(),
      body: {'pos_id': posId},
      fromJson: (p0) => {},
    ).call();
  }
  static Future<ApiResponseModel> dispatchAddDetailsPos({
    required int posId,
    required String logisticsCompany,
    required String logisticsCharges,
  }) async {
    return await DioHelper(
      method: ApiMethods.put,
      url: Endpoint.posDispatchAddDetails(),
      body: {
        'pos_id': posId,
        'logistics_company': logisticsCompany,
        'logistics_charges': logisticsCharges,
      },
      fromJson: (p0) => {},
    ).call();
  }
}
