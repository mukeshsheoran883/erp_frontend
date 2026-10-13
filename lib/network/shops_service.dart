
import 'package:invently/assortment/network/api_helper.dart';
import 'package:invently/assortment/network/api_manager_models.dart';
import 'package:invently/assortment/network/endpoints.dart';
import 'package:invently/models/shop/shop_model.dart';
import 'package:invently/utils/static_values.dart';

class ShopService {
  static UrlQuery _shopCode(String shopCode) => UrlQuery(key: 'shop_code', value: shopCode);

  static Future<ApiResponseModel<List<ShopModel>>> getShopList({String? accessToken, bool? pagination}) async {
    return await DioHelper(
      method: ApiMethods.get,
      url: Endpoint.branchList(),
      queries: [Query.countLimit(pagination: pagination)],
      fromJson: ShopModel.listFromJson,
      headers: accessToken == null ? null : StaticValues.defaultHeaders(token: accessToken),
    ).call();
  }
}
