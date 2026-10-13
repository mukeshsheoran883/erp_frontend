import 'package:invently/assortment/network/api_helper.dart';
import 'package:invently/assortment/network/api_manager_models.dart';
import 'package:invently/assortment/network/endpoints.dart';
import 'package:invently/models/branch/branch_model.dart';
import 'package:invently/ui/master/branch/widgets/filter_section.dart';
import 'package:invently/utils/static_values.dart';

class BranchService {
  static UrlQuery _branchCode(String branchCode) => UrlQuery(key: 'shop_code', value: branchCode);

  static Future<ApiResponseModel<List<BranchModel>>> getBranchList({
    required int pageNumber,
    required String searchKey,
    required BranchFilterModel? filter,
  }) async {
    return await DioHelper(
      method: ApiMethods.get,
      url: Endpoint.branchList(search: searchKey.trim().isNotEmpty),
      queries: [
        Query.pageNumber(pageNumber),
        Query.countLimit(),
        Query.search(searchKey),
        if (filter != null) ...filter.getFilterQueries(),
      ],
      fromJson: BranchModel.listFromJson,
    ).call();
  }

  static Future<ApiResponseModel<BranchModel>> getBranch({required String branchCode}) async {
    return await DioHelper(
      method: ApiMethods.get,
      url: Endpoint.getBranch(),
      queries: [_branchCode(branchCode)],
      fromJson: BranchModel.fromJson,
    ).call();
  }

  static Future<ApiResponseModel> createBranch(BranchModel model) async {
    return await DioHelper(
      method: ApiMethods.post,
      url: Endpoint.addBranch(),
      body: model.toJson(),
      fromJson: (p0) => {},
    ).call();
  }

  static Future<ApiResponseModel> multiDeleteBranch({required List<String> deleteList}) async {
    return await DioHelper(
      method: ApiMethods.patch,
      url: Endpoint.deleteBranches(),
      body: {'shop_code': deleteList.map((e) => e).toList()},
      fromJson: (p0) {},
    ).call();
  }

  static Future<ApiResponseModel> updateBranch(BranchModel model) async {
    return await DioHelper(
      method: ApiMethods.put,
      url: Endpoint.updateBranch(),
      body: model.toJson(),
      fromJson: (p0) => {},
    ).call();
  }
}
