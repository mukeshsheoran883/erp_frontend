
import 'package:invently/assortment/extensions/text_editing_controller_extensions.dart';
import 'package:invently/assortment/status.dart';
import 'package:invently/models/common/common_id_value_model.dart';
import 'package:invently/models/common/custom_image_model.dart';
import 'package:invently/utils/validation/validator.dart';
import 'package:flutter/material.dart';

class StringParam extends FormParam<String?> {
  String? value;
  ValidationError error = ValidationError.none();

  @override
  void dispose() {}

  @override
  void resetError() => error = ValidationError.none();

  @override
  void resetData(data) => value = data;

  @override
  void setError(String errorMsg) => error = ValidationError(errorMessage: errorMsg, isError: true);
}

class CommonKeyValueParam extends FormParam<CommonKeyValueModel?> {
  CommonKeyValueModel? value;
  ValidationError error = ValidationError.none();

  @override
  void dispose() {}

  @override
  void resetError() => error = ValidationError.none();

  @override
  void resetData(data) => value = data;

  @override
  void setError(String errorMsg) => error = ValidationError(errorMessage: errorMsg, isError: true);
}

class TextFieldParam extends FormParam<String?> {
  TextEditingController controller = TextEditingController();
  ValidationError error = ValidationError.none();

  @override
  void dispose() => controller.dispose();

  @override
  void resetError() => error = ValidationError.none();

  @override
  void setError(String errorMsg) => error = ValidationError(errorMessage: errorMsg, isError: true);

  @override
  void resetData(data) => controller.text = data ?? '';

  String get text => controller.trimmedText();
}

class DateTimeParam extends FormParam<DateTime?> {
  DateTime? dateTime;
  ValidationError error = ValidationError.none();

  @override
  void dispose() {}

  @override
  void resetData(DateTime? data) => dateTime = data;

  @override
  void resetError() => error = ValidationError.none();

  @override
  void setError(String errorMsg) => error = ValidationError(errorMessage: errorMsg, isError: true);
}

class FileParam extends FormParam<CustomImageModel?> {
  CustomImageModel? file;
  ValidationError error = ValidationError.none();

  get value => null;

  @override
  void dispose() {}

  @override
  void resetData(data) => file = data;

  @override
  void resetError() => error.reset();

  @override
  void setError(String errorMsg) => error = ValidationError(errorMessage: errorMsg, isError: true);
}

class DropDownParam<T> extends FormParam<T?> {
  DropDownParam({required this.options});

  T? selected;
  List<T> options;
  ValidationError error = ValidationError.none();

  @override
  void dispose() {}

  @override
  void resetData(T? data) => selected = data;

  @override
  void resetError() => error = ValidationError.none();

  @override
  void setError(String errorMsg) => error = ValidationError(errorMessage: errorMsg, isError: true);
}

class DropDownListenableParam<T> extends FormParam<T?> {
  DropDownListenableParam({required this.options});

  T? selected;
  ValueNotifier<List<T>> options;
  ValidationError error = ValidationError.none();

  @override
  void dispose() {}

  @override
  void resetData(T? data) => selected = data;

  @override
  void resetError() => error = ValidationError.none();

  @override
  void setError(String errorMsg) => error = ValidationError(errorMessage: errorMsg, isError: true);
}

class ApiParam<T> extends FormParam<T?> {
  T? value;
  Status _apiStatus = Status.loading;
  ValidationError _error = ValidationError.none();

  @override
  void dispose() {}

  @override
  void resetData(data) => value = data;

  void setStatus(Status a) => _apiStatus = a;

  @override
  void setError(String errorMsg) => _error = ValidationError(isError: true, errorMessage: errorMsg);

  Status get status => _apiStatus;

  ValidationError get error => _error;

  @override
  void reset(T? data) {
    super.reset(data);
    resetData(data);
    resetError();
    setStatus(Status.loading);
  }

  @override
  void resetError() => _error = ValidationError.none();
}

class MultiDropDownParam<T> extends FormParam<T> {
  MultiDropDownParam({required this.options, required this.selected});

  T selected;
  T options;
  ValidationError error = ValidationError.none();

  @override
  void dispose() {}

  @override
  void resetData(T data) => selected = data;

  @override
  void resetError() => error = ValidationError.none();

  @override
  void setError(String errorMsg) => error = ValidationError(errorMessage: errorMsg, isError: true);
}

class PhoneNumberParam extends FormParam<({String? countryCode, String? phone})> {
  TextEditingController phoneController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  ValidationError error = ValidationError.none();

  @override
  void dispose() => {phoneController.dispose(), codeController.dispose()};

  @override
  void resetError() => error = ValidationError.none();

  @override
  void setError(String errorMsg) => error = ValidationError(errorMessage: errorMsg, isError: true);

  @override
  void resetData(data) => {codeController.text = data.countryCode ?? '', phoneController.text = data.phone ?? ''};

  String get code => codeController.trimmedText();

  String get phone => phoneController.trimmedText();
}

class CheckboxParam extends FormParam<bool?> {
  bool? value;
  ValidationError error = ValidationError.none();

  @override
  void dispose() {}

  @override
  void resetData(bool? data) => value = data;

  @override
  void resetError() => error = ValidationError.none();

  @override
  void setError(String errorMsg) => error = ValidationError(errorMessage: errorMsg, isError: true);
}

abstract class FormParam<T> {
  @mustCallSuper
  void reset(T data) {
    resetData(data);
    resetError();
  }

  void resetData(T data);
  void resetError();
  void dispose();

  void setError(String errorMsg);
}
