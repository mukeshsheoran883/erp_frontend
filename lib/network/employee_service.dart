
import 'package:invently/assortment/network/api_helper.dart';
import 'package:invently/assortment/network/api_manager_models.dart';
import 'package:invently/assortment/network/endpoints.dart';
import 'package:invently/models/user/employee_model.dart';
import 'package:invently/ui/master/employee/widgets/filter_section.dart';
import 'package:invently/utils/static_values.dart';

class EmployeeService {
  static UrlQuery _employeeCode(String employeeCode) => UrlQuery(key: 'employee_code', value: employeeCode);

  static Future<ApiResponseModel<List<UserModel>>> getEmployeeList({
    required int pageNumber,
    required String searchKey,
    required EmployeeFilterModel? filter,
  }) async {
    return await DioHelper(
      method: ApiMethods.get,
      url: Endpoint.employeeList(search: searchKey.trim().isNotEmpty),
      queries: [
        Query.pageNumber(pageNumber),
        Query.countLimit(),
        Query.search(searchKey),
        if (filter != null) ...filter.getFilterQueries(),
      ],
      fromJson: UserModel.listFromJson,
    ).call();
  }

  static Future<ApiResponseModel<UserModel>> getEmployee({required String employeeCode}) async {
    return await DioHelper(
      method: ApiMethods.get,
      url: Endpoint.getEmployee(),
      queries: [_employeeCode(employeeCode)],
      fromJson: UserModel.fromJson,
    ).call();
  }

  static Future<ApiResponseModel> createEmployee(UserModel model) async {
    return await DioHelper(
      method: ApiMethods.post,
      url: Endpoint.addEmployee(),
      body: model.toJson(),
      fromJson: (p0) => {},
    ).call();
  }

  static Future<ApiResponseModel> multiDeleteEmployee({required List<String> deleteList}) async {
    return await DioHelper(
      method: ApiMethods.patch,
      url: Endpoint.multiDeleteEmployee(),
      body: {'employee_code': deleteList.map((brand) => brand).toList()},
      fromJson: (p0) {},
    ).call();
  }

  static Future<ApiResponseModel> updateEmployee(UserModel model) async {
    return await DioHelper(
      method: ApiMethods.put,
      url: Endpoint.updateEmployee(),
      body: model.toJson(),
      fromJson: (p0) => {},
    ).call();
  }

  static Future<ApiResponseModel> employeeStatusChange({
    required List<String> employeeList,
    required bool status,
  }) async {
    return await DioHelper(
      method: ApiMethods.patch,
      url: Endpoint.employeeStatusChange(),
      body: {'employee_code': employeeList.map((brand) => brand).toList(), 'status': status},
      fromJson: (p0) {},
    ).call();
  }
}
