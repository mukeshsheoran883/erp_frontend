import 'package:invently/assortment/network/api_helper.dart';
import 'package:invently/assortment/network/api_manager_models.dart';
import 'package:invently/assortment/network/endpoints.dart';
import 'package:invently/models/reports/gst_report/gst_one_model.dart';
import 'package:invently/models/reports/gst_report/gst_two_model.dart';
import 'package:invently/utils/static_values.dart';

class GstReportService {
  static Future<ApiResponseModel<List<GstOneModel>>> getGSTOneReportList({
    required int pageNumber,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    return await DioHelper(
      method: ApiMethods.get,
      url: Endpoint.gst1Report(),
      queries: [Query.pageNumber(pageNumber), Query.countLimit(), Query.startDate(startDate), Query.endDate(endDate)],
      fromJson: GstOneModel.listFromJson,
    ).call();
  }

  static Future<ApiResponseModel<List<GstTwoModel>>> getGSTTwoReportList({
    required int pageNumber,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    return await DioHelper(
      method: ApiMethods.get,
      url: Endpoint.gst2Report(),
      queries: [Query.pageNumber(pageNumber), Query.countLimit(), Query.startDate(startDate), Query.endDate(endDate)],
      fromJson: GstTwoModel.listFromJson,
    ).call();
  }
}
