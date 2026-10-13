import 'package:invently/assortment/network/api_helper.dart';
import 'package:invently/assortment/network/api_manager_models.dart';
import 'package:invently/assortment/network/endpoints.dart';
import 'package:invently/models/reports/day_book/day_book_customer_model.dart';
import 'package:invently/models/reports/day_book/day_book_inventory_balance_model.dart';
import 'package:invently/models/reports/day_book/day_book_item_model.dart';
import 'package:invently/models/reports/day_book/day_book_supplies_model.dart';
import 'package:invently/utils/static_values.dart';

class DayBookReportService {
  static Future<ApiResponseModel<List<DayBookItemModel>>> getItemReportList({
    required int pageNumber,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    return await DioHelper(
      method: ApiMethods.get,
      url: Endpoint.dayBookItem(),
      queries: [Query.pageNumber(pageNumber), Query.countLimit(), Query.startDate(startDate), Query.endDate(endDate)],
      fromJson: DayBookItemModel.listFromJson,
    ).call();
  }

  static Future<ApiResponseModel<List<DayBookCustomersModel>>> getCustomerReportList({
    required int pageNumber,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    return await DioHelper(
      method: ApiMethods.get,
      url: Endpoint.dayBookCustomers(),
      queries: [Query.pageNumber(pageNumber), Query.countLimit(), Query.startDate(startDate), Query.endDate(endDate)],
      fromJson: DayBookCustomersModel.listFromJson,
    ).call();
  }

  static Future<ApiResponseModel<List<DayBookInventoryBalanceModel>>> getInventoryBalanceReportList({
    required int pageNumber,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    return await DioHelper(
      method: ApiMethods.get,
      url: Endpoint.dayBookInventoryBalance(),
      queries: [Query.pageNumber(pageNumber), Query.countLimit(), Query.startDate(startDate), Query.endDate(endDate)],
      fromJson: DayBookInventoryBalanceModel.listFromJson,
    ).call();
  }

  static Future<ApiResponseModel<List<DayBookSuppliesModel>>> getSuppliesReportList({
    required int pageNumber,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    return await DioHelper(
      method: ApiMethods.get,
      url: Endpoint.dayBookSupplies(),
      queries: [Query.pageNumber(pageNumber), Query.countLimit(), Query.startDate(startDate), Query.endDate(endDate)],
      fromJson: DayBookSuppliesModel.listFromJson,
    ).call();
  }
}
