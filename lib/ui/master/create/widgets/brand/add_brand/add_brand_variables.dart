import 'package:invently/models/brand/brand_model.dart';
import 'package:invently/models/common/form_models.dart';

class AddBrandParams {
  ApiParam<BrandModel> brand = ApiParam<BrandModel>();
  TextFieldParam name = TextFieldParam();

  List<FormParam> allParams() => [
        brand,
        name,
      ];
}
