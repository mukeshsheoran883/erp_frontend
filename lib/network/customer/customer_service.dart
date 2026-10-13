import 'package:invently/assortment/network/api_helper.dart';
import 'package:invently/assortment/network/api_manager_models.dart';
import 'package:invently/assortment/network/endpoints.dart';
import 'package:invently/models/customer/customer_model.dart';
import 'package:invently/ui/master/customer/widgets/filter_section.dart';
import 'package:invently/utils/static_values.dart';

class CustomerService {
  static UrlQuery _customerCode(String customerCode) => UrlQuery(key: 'customer_code', value: customerCode);

  static Future<ApiResponseModel<List<CustomerModel>>> getCustomerList({
    required int pageNumber,
    required String searchKey,
    required CustomerFilterModel? filter,
  }) async {
    return await DioHelper(
      method: ApiMethods.get,
      url: Endpoint.customerList(search: searchKey.trim().isNotEmpty),
      queries: [
        Query.pageNumber(pageNumber),
        Query.countLimit(),
        Query.search(searchKey),
        if (filter != null) ...filter.getFilterQueries(),
      ],
      fromJson: CustomerModel.listFromJson,
    ).call();
  }

  static Future<ApiResponseModel<CustomerModel>> getCustomer({required String customerCode}) async {
    return await DioHelper(
      method: ApiMethods.get,
      url: Endpoint.getCustomer(),
      queries: [_customerCode(customerCode)],
      fromJson: CustomerModel.fromJson,
    ).call();
  }

  static Future<ApiResponseModel> createCustomer(CustomerModel model) async {
    return await DioHelper(
      method: ApiMethods.post,
      url: Endpoint.addCustomer(),
      body: model.toJson(),
      fromJson: (p0) => {},
    ).call();
  }

  static Future<ApiResponseModel> multiDeleteCustomer({required List<String> deleteList}) async {
    return await DioHelper(
      method: ApiMethods.patch,
      url: Endpoint.deleteCustomer(),
      body: {'customer_code': deleteList.map((customer) => customer).toList()},
      fromJson: (p0) {},
    ).call();
  }

  static Future<ApiResponseModel> updateCustomer(CustomerModel model) async {
    return await DioHelper(
      method: ApiMethods.put,
      url: Endpoint.updateCustomer(),
      body: model.toJson(),
      fromJson: (p0) => {},
    ).call();
  }
}
