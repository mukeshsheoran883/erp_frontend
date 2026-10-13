import 'package:invently/assortment/network/api_helper.dart';
import 'package:invently/assortment/network/api_manager_models.dart';
import 'package:invently/assortment/network/endpoints.dart';
import 'package:invently/models/reports/overview/customer_report_model.dart';
import 'package:invently/models/reports/overview/inventory_balance_report_model.dart';
import 'package:invently/models/reports/overview/item_report_model.dart';
import 'package:invently/models/reports/overview/supplies_report_model.dart';
import 'package:invently/utils/static_values.dart';

class OverviewReportService {

  static Future<ApiResponseModel<List<OverviewItemModel>>> getItemReportList({
    required int pageNumber,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    return await DioHelper(
      method: ApiMethods.get,
      url: Endpoint.overviewItem(),
      queries: [Query.pageNumber(pageNumber), Query.countLimit(), Query.startDate(startDate), Query.endDate(endDate)],
      fromJson: OverviewItemModel.listFromJson,
    ).call();
  }

  static Future<ApiResponseModel<List<OverviewCustomersModel>>> getCustomerReportList({
    required int pageNumber,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    return await DioHelper(
      method: ApiMethods.get,
      url: Endpoint.overviewCustomers(),
      queries: [Query.pageNumber(pageNumber), Query.countLimit(), Query.startDate(startDate), Query.endDate(endDate)],
      fromJson: OverviewCustomersModel.listFromJson,
    ).call();
  }

  static Future<ApiResponseModel<List<OverviewInventoryBalanceModel>>> getInventoryBalanceReportList({
    required int pageNumber,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    return await DioHelper(
      method: ApiMethods.get,
      url: Endpoint.overviewInventoryBalance(),
      queries: [Query.pageNumber(pageNumber), Query.countLimit(), Query.startDate(startDate), Query.endDate(endDate)],
      fromJson: OverviewInventoryBalanceModel.listFromJson,
    ).call();
  }

  static Future<ApiResponseModel<List<OverviewSuppliesModel>>> getSuppliesReportList({
    required int pageNumber,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    return await DioHelper(
      method: ApiMethods.get,
      url: Endpoint.overviewSupplies(),
      queries: [Query.pageNumber(pageNumber), Query.countLimit(), Query.startDate(startDate), Query.endDate(endDate)],
      fromJson: OverviewSuppliesModel.listFromJson,
    ).call();
  }
}
