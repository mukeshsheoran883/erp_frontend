import 'package:invently/models/category/category_model.dart';
import 'package:invently/models/common/form_models.dart';

class AddCategoryParams {
  ApiParam<CategoryModel> category = ApiParam<CategoryModel>();
  TextFieldParam name = TextFieldParam();

  List<FormParam> allParams() => [
        category,
        name,
      ];
}
