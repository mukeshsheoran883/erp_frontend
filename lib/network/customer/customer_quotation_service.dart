import 'package:invently/assortment/network/api_helper.dart';
import 'package:invently/assortment/network/api_manager_models.dart';
import 'package:invently/assortment/network/endpoints.dart';
import 'package:invently/models/customer/customer_quotation_model.dart';
import 'package:invently/models/customer/customer_quotation_status_model.dart';
import 'package:invently/ui/master/customer/widgets/filter_section.dart';
import 'package:invently/utils/static_values.dart';

class CustomerQuotationService {
  static UrlQuery _customerQuotationCode(String customerQuotationCode) =>
      UrlQuery(key: 'customer_quotation_id', value: customerQuotationCode);

  static Future<ApiResponseModel<List<CustomerQuotationModel>>>
      getCustomerQuotationList({
    required int pageNumber,
    required String searchKey,
    required CustomerFilterModel? filter,
  }) async {
    return await DioHelper(
      method: ApiMethods.get,
      url: Endpoint.customerQuotationList(search: searchKey.trim().isNotEmpty),
      queries: [
        Query.pageNumber(pageNumber),
        Query.countLimit(),
        Query.search(searchKey),
        if (filter != null) ...filter.getFilterQueries(),
      ],
      fromJson: CustomerQuotationModel.listFromJson,
    ).call();
  }

  static Future<ApiResponseModel<CustomerQuotationModel>> getCustomerQuotation(
      {required String customerQuotationCode}) async {
    return await DioHelper(
      method: ApiMethods.get,
      url: Endpoint.getCustomerQuotation(),
      queries: [_customerQuotationCode(customerQuotationCode)],
      fromJson: CustomerQuotationModel.fromJson,
    ).call();
  }

  static Future<ApiResponseModel> createCustomerQuotation(
      CustomerQuotationModel model) async {
    return await DioHelper(
      method: ApiMethods.post,
      url: Endpoint.addCustomerQuotation(),
      body: model.toJson(),
      fromJson: (p0) => {},
    ).call();
  }
  static Future<ApiResponseModel> customerQuotationStats(
      CustomerQuotationStatusModel model,) async {
    return await DioHelper(
      method: ApiMethods.put,
      url: Endpoint.reviewCustomerQuotation(),
      body: model.toJson(),
      fromJson: (p0) => {},
    ).call();
  }

// static Future<ApiResponseModel> multiDeleteCustomerQuotation({required List<String> deleteList}) async {
//   return await DioHelper(
//     method: ApiMethods.patch,
//     url: Endpoint.deleteCustomerQuotation(),
//     body: {'customer_quotation_code': deleteList.map((customer) => customer).toList()},
//     fromJson: (p0) {},
//   ).call();
// }
//
// static Future<ApiResponseModel> updateCustomerQuotation(CustomerQuotationModel model) async {
//   return await DioHelper(
//     method: ApiMethods.put,
//     url: Endpoint.updateCustomerQuotation(),
//     body: model.toJson(),
//     fromJson: (p0) => {},
//   ).call();
// }
}
