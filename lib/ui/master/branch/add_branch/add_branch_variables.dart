import 'package:invently/models/branch/branch_model.dart';
import 'package:invently/models/common/common_id_value_model.dart';
import 'package:invently/models/common/country_codes.dart';
import 'package:invently/models/common/form_models.dart';
import 'package:gusto_neumorphic/gusto_neumorphic.dart';

class AddBranchParams {
  ApiParam<BranchModel> branch = ApiParam<BranchModel>();
  TextFieldParam name = TextFieldParam();
  TextFieldParam email = TextFieldParam();
  PhoneNumberParam phone = PhoneNumberParam();
  PhoneNumberParam altPhone = PhoneNumberParam();
  DropDownParam<Country> country = DropDownParam(options: []);
  StringParam state = StringParam();
  TextFieldParam buildingStreet = TextFieldParam();
  TextFieldParam website = TextFieldParam();
  DropDownListenableParam<CommonKeyValueModel> type =
      DropDownListenableParam<CommonKeyValueModel>(options: ValueNotifier([]));

  List<FormParam> allParams() => [
        name,
        type,
        phone,
        altPhone,
        country,
        state,
        buildingStreet,
        website,
        branch,
      ];
}
