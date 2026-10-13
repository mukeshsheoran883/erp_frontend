import 'package:invently/assortment/network/api_helper.dart';
import 'package:invently/assortment/network/api_manager_models.dart';
import 'package:invently/assortment/network/endpoints.dart';
import 'package:invently/models/category/category_model.dart';
import 'package:invently/utils/static_values.dart';

class CategoryService {
  static Future<ApiResponseModel<List<CategoryModel>>> getCategoryList({
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
      url: Endpoint.categoryList(search: searchKey.trim().isNotEmpty),
      queries: [
        Query.pageNumber(pageNumber),
        Query.countLimit(),
        Query.search(searchKey),
      ],
      fromJson: CategoryModel.listFromJson,
    ).call();
  }

  static Future<ApiResponseModel<List<CategoryModel>>> getAllCategoryList({String? accessToken}) async {
    return await DioHelper(
      method: ApiMethods.get,
      url: Endpoint.categoryList(),
      queries: [Query.countLimit(pagination: false)],
      fromJson: CategoryModel.listFromJson,
      headers: accessToken == null ? null : StaticValues.defaultHeaders(token: accessToken),
    ).call();
  }

  static Future<ApiResponseModel> createCategory(CategoryModel model) async {
    return await DioHelper(
      method: ApiMethods.post,
      url: Endpoint.addCategory(),
      body: model.toJson(),
      fromJson: (p0) => {},
    ).call();
  }

  static Future<ApiResponseModel> multiDeleteCategory({required List<String> deleteList}) async {
    return await DioHelper(
      method: ApiMethods.patch,
      url: Endpoint.deleteCategories(),
      body: {'category_code': deleteList.map((brand) => brand).toList()},
      fromJson: (p0) {},
    ).call();
  }

  static Future<ApiResponseModel> updateCategory(CategoryModel model) async {
    return await DioHelper(
      method: ApiMethods.put,
      url: Endpoint.updateCategory(),
      body: model.toJson(),
      fromJson: (p0) => {'category_code': model.categoryCode, 'name': model.name},
    ).call();
  }
}
