import 'package:invently/assortment/network/api_helper.dart';
import 'package:invently/assortment/network/api_manager_models.dart';
import 'package:invently/assortment/network/endpoints.dart';
import 'package:invently/models/reports/general_report/purchase_report_model.dart';
import 'package:invently/models/reports/general_report/quotation_report_model.dart';
import 'package:invently/models/reports/general_report/sales_report_model.dart';
import 'package:invently/models/reports/general_report/stock_report_model.dart';
import 'package:invently/utils/static_values.dart';

class GeneralReportService {
  static Future<ApiResponseModel<List<PurchaseReportModel>>> getPurchaseReportList({
    required int pageNumber,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    return await DioHelper(
      method: ApiMethods.get,
      url: Endpoint.purchaseReport(),
      queries: [Query.pageNumber(pageNumber), Query.countLimit(), Query.startDate(startDate), Query.endDate(endDate)],
      fromJson: PurchaseReportModel.listFromJson,
    ).call();
  }

  static Future<ApiResponseModel<List<StockReportModel>>> getStockReportList({
    required int pageNumber,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    return await DioHelper(
      method: ApiMethods.get,
      url: Endpoint.stockReport(),
      queries: [Query.pageNumber(pageNumber), Query.countLimit(), Query.startDate(startDate), Query.endDate(endDate)],
      fromJson: StockReportModel.listFromJson,
    ).call();
  }

  static Future<ApiResponseModel<List<SalesReportModel>>> getSalesReportList({
    required int pageNumber,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    return await DioHelper(
      method: ApiMethods.get,
      url: Endpoint.salesReport(),
      queries: [Query.pageNumber(pageNumber), Query.countLimit(), Query.startDate(startDate), Query.endDate(endDate)],
      fromJson: SalesReportModel.listFromJson,
    ).call();
  }

  static Future<ApiResponseModel<List<QuotationReportModel>>> getQuotationReportList({
    required int pageNumber,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    return await DioHelper(
      method: ApiMethods.get,
      url: Endpoint.quotationReport(),
      queries: [Query.pageNumber(pageNumber), Query.countLimit(), Query.startDate(startDate), Query.endDate(endDate)],
      fromJson: QuotationReportModel.listFromJson,
    ).call();
  }
}
