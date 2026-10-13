import 'package:invently/assortment/network/api_helper.dart';
import 'package:invently/assortment/network/api_manager_models.dart';
import 'package:invently/assortment/network/endpoints.dart';
import 'package:invently/models/sales/bill_history_model.dart';
import 'package:invently/ui/sales/bill_history/widgets/filter_section.dart';
import 'package:invently/utils/static_values.dart';

class BillHistoryService {
  static UrlQuery _billHistoryCode(String billHistoryCode) => UrlQuery(key: 'bill_number', value: billHistoryCode);

  static Future<ApiResponseModel<List<BillHistoryModel>>> getBillHistoryList({
    required int pageNumber,
    required String searchKey,
    required BillHistoryFilterModel? filter,
  }) async {
    return await DioHelper(
      method: ApiMethods.get,
      url: Endpoint.billHistoryList(search: searchKey.trim().isNotEmpty),
      queries: [
        Query.pageNumber(pageNumber),
        Query.countLimit(),
        Query.search(searchKey),
        if (filter != null) ...filter.getFilterQueries(),
      ],
      fromJson: BillHistoryModel.listFromJson,
    ).call();
  }

  static Future<ApiResponseModel<BillHistoryModel>> getBillHistory({required String billHistoryCode}) async {
    return await DioHelper(
      method: ApiMethods.get,
      url: Endpoint.getBillHistory(),
      queries: [_billHistoryCode(billHistoryCode)],
      fromJson: BillHistoryModel.fromJson,
    ).call();
  }

  static Future<ApiResponseModel> createBillHistory(BillHistoryModel model) async {
    return await DioHelper(
      method: ApiMethods.post,
      url: Endpoint.addBillHistory(),
      body: model.toJson(),
      fromJson: (p0) => {},
    ).call();
  }

  static Future<ApiResponseModel> multiDeleteBillHistory({required List<String> deleteList}) async {
    return await DioHelper(
      method: ApiMethods.patch,
      url: Endpoint.deleteBillHistory(),
      body: {'bill_history_cod': deleteList.map((supplier) => supplier).toList()},
      fromJson: (p0) {},
    ).call();
  }

  static Future<ApiResponseModel> updateBillHistory(BillHistoryModel model) async {
    return await DioHelper(
      method: ApiMethods.put,
      url: Endpoint.updateBillHistory(),
      body: model.toJson(),
      fromJson: (p0) => {},
    ).call();
  }
}
