import 'package:invently/assortment/network/api_helper.dart';
import 'package:invently/assortment/network/api_manager_models.dart';
import 'package:invently/assortment/network/endpoints.dart';
import 'package:invently/models/administration/organization_model.dart';
import 'package:invently/utils/static_values.dart';

class AdministrationService {
  static UrlQuery _administrationCode(String administrationCode) => UrlQuery(key: 'name', value: administrationCode);

  static Future<ApiResponseModel<List<AdministrationModel>>> getOrganizationList({
    required int pageNumber,
    required String searchKey,
    String? filterKey,
    String? filterValue,
    String? sortBy,
    String? sortOrder,
    String? value,
  }) async {
    return await DioHelper(
      method: ApiMethods.get,
      url: Endpoint.organizationList(search: searchKey.trim().isNotEmpty),
      queries: [
        Query.pageNumber(pageNumber),
        Query.countLimit(),
        Query.search(searchKey),
        UrlQuery(key: 'filter_key', value: filterKey ?? ''),
        UrlQuery(key: 'filter_value', value: filterValue ?? ''),
        UrlQuery(key: 'sort_by', value: sortBy ?? ''),
        UrlQuery(key: 'sort_order', value: sortOrder ?? ''),
        UrlQuery(key: 'value', value: value ?? ''),
      ],
      fromJson: AdministrationModel.listFromJson,
    ).call();
  }

  static Future<ApiResponseModel<AdministrationModel>> getOrganization({required String organizationName}) async {
    return await DioHelper(
      method: ApiMethods.get,
      url: Endpoint.getOrganization(),
      queries: [_administrationCode(organizationName)],
      fromJson: AdministrationModel.fromJson,
    ).call();
  }

  static Future<ApiResponseModel> createOrganization(AdministrationModel model) async {
    return await DioHelper(
      method: ApiMethods.post,
      url: Endpoint.addOrganization(),
      body: model.toJson(),
      fromJson: (p0) => {},
    ).call();
  }

  static Future<ApiResponseModel> multiDeleteOrganization({required List<String> deleteList}) async {
    return await DioHelper(
      method: ApiMethods.patch,
      url: Endpoint.deleteOrganization(),
      body: {'name': deleteList.map((e) => e).toList()},
      fromJson: (p0) {},
    ).call();
  }

  static Future<ApiResponseModel> updateOrganization(AdministrationModel model) async {
    return await DioHelper(
      method: ApiMethods.put,
      url: Endpoint.updateOrganization(),
      body: model.toJson(),
      fromJson: (p0) => {},
    ).call();
  }
}
