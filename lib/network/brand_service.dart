import 'package:invently/assortment/network/api_helper.dart';
import 'package:invently/assortment/network/api_manager_models.dart';
import 'package:invently/assortment/network/endpoints.dart';
import 'package:invently/models/brand/brand_model.dart';
import 'package:invently/utils/static_values.dart';

class BrandService {
  static Future<ApiResponseModel<List<BrandModel>>> getBrandList({
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
      url: Endpoint.brandList(search: searchKey.trim().isNotEmpty),
      queries: [
        Query.pageNumber(pageNumber),
        Query.countLimit(),
        Query.search(searchKey),
      ],
      fromJson: BrandModel.listFromJson,
    ).call();
  }

  static Future<ApiResponseModel<List<BrandModel>>> getAllBrandList({String? accessToken}) async {
    return await DioHelper(
      method: ApiMethods.get,
      url: Endpoint.brandList(),
      queries: [Query.countLimit(pagination: false)],
      fromJson: BrandModel.listFromJson,
      headers: accessToken == null ? null : StaticValues.defaultHeaders(token: accessToken),
    ).call();
  }

  static Future<ApiResponseModel> createBrand(BrandModel model) async {
    return await DioHelper(
      method: ApiMethods.post,
      url: Endpoint.addBrand(),
      body: model.toJson(),
      fromJson: (p0) => {},
    ).call();
  }

  static Future<ApiResponseModel> multiDeleteBrand({required List<String> deleteList}) async {
    return await DioHelper(
      method: ApiMethods.patch,
      url: Endpoint.deleteBrands(),
      body: {'brand_code': deleteList.map((brand) => brand).toList()},
      fromJson: (p0) {},
    ).call();
  }

  static Future<ApiResponseModel> updateBrand(BrandModel model) async {
    return await DioHelper(
      method: ApiMethods.put,
      url: Endpoint.updateBrand(),
      body: model.toJson(),
      fromJson: (p0) => {'brand_code': model.brandCode, 'name': model.name},
    ).call();
  }
}
