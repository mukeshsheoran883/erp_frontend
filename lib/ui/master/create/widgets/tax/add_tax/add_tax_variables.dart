import 'package:invently/models/brand/brand_model.dart';
import 'package:invently/models/common/form_models.dart';

class AddTaxParams {
  ApiParam<BrandModel> taxModel = ApiParam<BrandModel>();
  TextFieldParam totalTax = TextFieldParam();
  TextFieldParam taxTitle = TextFieldParam();

  // Ab single name/tax ki jagah List of splits
  List<TaxSplitParam> taxSplits = [TaxSplitParam()];

  List<FormParam> allParams() => [
    taxModel,
    totalTax,
    taxTitle,
    ...taxSplits.expand((s) => [s.name, s.tax]),
  ];
}

// Ek row ke liye alag class — name (CGST/SGST/etc) + tax%
class TaxSplitParam {
  TextFieldParam name = TextFieldParam();
  TextFieldParam tax = TextFieldParam();

  void dispose() {
    name.dispose();
    tax.dispose();
  }
}