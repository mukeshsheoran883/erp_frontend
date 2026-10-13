
import 'package:invently/assortment/extensions/date_time_extensions.dart';
import 'package:invently/assortment/utils/file_utils.dart';
import 'package:invently/models/common/country_codes.dart';
import 'package:invently/utils/static_values.dart';
import 'package:invently/utils/validation/validator.dart';
import 'package:fast_validator/fast_validator.dart';

class CustomValidators {
  static ValidationModel fileSizeValidator({
    required String field,
    required FileSize? size,
    FileSize minFileSize = const FileSize(size: 10, unit: FileSizeUnit.kb),
    FileSize maxFileSize = const FileSize(size: 3, unit: FileSizeUnit.mb),
    required ValidationError error,
    bool required = true,
  }) {
    return ValidationModel(
      fieldName: field,
      data: size?.toBytes(),
      error: error,
      validators: [
        if (required) FastRequiredValidation(),
        FastMaxValueValidation(
          maxValue: maxFileSize.toBytes(),
          customMessage: 'Maximum file size must be ${maxFileSize.getHumanReadableForm(inUnit: maxFileSize.unit)}',
        ),
        FastMinValueValidation(
          minValue: minFileSize.toBytes(),
          customMessage: 'Minimum file size must be ${minFileSize.getHumanReadableForm(inUnit: maxFileSize.unit)}',
        ),
      ],
    );
  }

  static ValidationModel nameValidator({
    required String field,
    required String? data,
    required ValidationError error,
    bool required = true,
    int maxLen = 100,
  }) {
    return ValidationModel(
      fieldName: field,
      data: data,
      error: error,
      validators: [
        if (required) FastRequiredValidation(),
        FastMaxLengthValidation(maxLength: maxLen, customMessage: 'Maximum length of $field must be $maxLen'),
      ],
    );
  }

  static ValidationModel emailValidator({
    required String field,
    required String? email,
    required ValidationError error,
    bool required = true,
  }) {
    return ValidationModel(
      fieldName: field,
      data: email,
      error: error,
      validators: [
        if (required) FastRequiredValidation(),
        FastEmailValidation(customMessage: '$field must ba a valid email'),
      ],
    );
  }

  static ValidationModel moneyValidator({
    required String field,
    required String? amount,
    num? minAmount,
    num? maxAmount,
    required ValidationError error,
    bool required = true,
  }) {
    final requiredValidation = ValidationModel(
      fieldName: field,
      data: amount,
      error: error,
      validators: [if (required) FastRequiredValidation()],
    );

    bool isRequiredValid = Validator.validate([requiredValidation]);

    if (!isRequiredValid) return requiredValidation;

    double? numberAmount = double.tryParse(amount ?? '');

    final typeValidation = ValidationModel(
      fieldName: field,
      data: numberAmount,
      error: error,
      validators: [
        FastRequiredValidation(customMessage: '$field must be a valid number'),
        FastTypeValidation(allowedTypes: [double], customMessage: '$field must ba a valid number'),
        if (minAmount != null)
          FastMinValueValidation(minValue: minAmount, customMessage: '$field must be greater than $minAmount'),
        if (maxAmount != null)
          FastMaxValueValidation(maxValue: maxAmount, customMessage: '$field must be lesser than $maxAmount'),
      ],
    );

    return typeValidation;
  }

  static ValidationModel dateValidator({
    required String field,
    required DateTime? date,
    DateTime? maxDate,
    DateTime? minDate,
    String? maxDateString,
    String? minDateString,
    required ValidationError error,
    bool required = true,
  }) {
    return ValidationModel(
      fieldName: field,
      data: date,
      error: error,
      validators: [
        if (required) FastRequiredValidation(),
        if (maxDate != null)
          FastDateValidation(
            maximumDate: maxDate.convertToDateAlone(),
            maxError: '$field must be a date before ${maxDateString ?? StaticValues.commonDateFormat.format(maxDate)}',
          ),
        if (minDate != null)
          FastDateValidation(
            minimumDate: minDate.convertToDateAlone(),
            minError: '$field must be a date after ${minDateString ?? StaticValues.commonDateFormat.format(minDate)}',
          ),
      ],
    );
  }

  static ValidationModel typeValidator({
    required String field,
    required dynamic data,
    required List<Type> types,
    required ValidationError error,
    bool required = true,
  }) {
    return ValidationModel(
      fieldName: field,
      data: data,
      error: error,
      validators: [
        if (required) FastRequiredValidation(),
        FastTypeValidation(allowedTypes: types, customMessage: '$field is invalid'),
      ],
    );
  }

  static ValidationModel minMaxValidator({
    required String field,
    required dynamic value,
    num? min,
    num? max,
    required ValidationError error,
    bool required = true,
  }) {
    return ValidationModel(
      fieldName: field,
      data: value,
      error: error,
      validators: [
        if (required) FastRequiredValidation(),
        if (min != null) FastMinValueValidation(minValue: min, customMessage: 'Must be greater than $min'),
        if (max != null) FastMaxValueValidation(maxValue: max, customMessage: 'Must be lesser than $max'),
      ],
    );
  }

  static ValidationModel phoneValidator({
    required String field,
    required String? code,
    required String? phone,
    required ValidationError error,
    bool required = true,
  }) {
    ValidationModel numberValidation = ValidationModel(
      fieldName: field,
      data: phone,
      error: error,
      validators: [
        if (required || (code?.trim() ?? '').isNotEmpty) FastRequiredValidation(),
        FastPhoneNumberValidation(customMessage: '$field is invalid'),
      ],
    );

    ValidationModel codeValidation = ValidationModel(
      fieldName: field,
      data: code,
      error: error,
      validators: [
        if (required || (phone?.trim() ?? '').isNotEmpty)
          FastRequiredValidation(customMessage: 'Country code is required'),
      ],
    );

    bool validNumber = Validator.validate([numberValidation]);

    bool validCode = Validator.validate([codeValidation]);

    if (!validNumber) return numberValidation;
    if (!validCode) return codeValidation;

    return numberValidation;
  }

  static ValidationModel countryValidator({
    required String field,
    required Country? country,
    required ValidationError error,
    bool required = true,
  }) {
    return ValidationModel(
      fieldName: field,
      data: country,
      error: error,
      validators: [
        if (required) FastRequiredValidation(),
        FastTypeValidation(allowedTypes: [Country], customMessage: '$field is invalid'),
      ],
    );
  }

  static ValidationModel stateValidator({
    required String field,
    required String? state,
    required Country? country,
    required ValidationError error,
    bool required = true,
  }) {
    return ValidationModel(
      fieldName: field,
      data: state,
      error: error,
      validators: [
        if (required) FastRequiredValidation(),
        _StateValidator(country: country),
      ],
    );
  }

  static ValidationModel addressValidator({
    required String field,
    required String? data,
    required ValidationError error,
    bool required = true,
    int maxLen = 300,
  }) {
    return ValidationModel(
      fieldName: field,
      data: data,
      error: error,
      validators: [
        if (required) FastRequiredValidation(),
        FastMaxLengthValidation(maxLength: maxLen, customMessage: 'Maximum length of $field must be $maxLen'),
      ],
    );
  }

  static List<ValidationModel> passwordValidator({
    required String passwordField,
    required String confirmField,
    required String? newPassword,
    required String? confirmPassword,
    required ValidationError newPasswordError,
    required ValidationError confirmPasswordError,
    bool required = true,
  }) {
    ValidationModel passwordValidation = ValidationModel(
      fieldName: passwordField,
      data: newPassword,
      error: newPasswordError,
      validators: [
        if (required) FastRequiredValidation(),
        FastPasswordValidation(minLength: 8, lowercase: true, uppercase: true, number: true, specialCharacter: true),
      ],
    );

    ValidationModel confirmPasswordValidation = ValidationModel(
      fieldName: confirmField,
      data: confirmPassword,
      error: confirmPasswordError,
      validators: [
        if (required) FastRequiredValidation(),
        FastExactValueValidation(
          value: newPassword,
          customMessage: '$confirmField does not match the ${passwordField.toLowerCase()}',
        ),
      ],
    );

    return [passwordValidation, confirmPasswordValidation];
  }

  static ValidationModel urlValidator({
    required String field,
    required String? url,
    required ValidationError error,
    bool required = true,
  }) {
    return ValidationModel(
      fieldName: field,
      data: url,
      error: error,
      validators: [
        if (required) FastRequiredValidation(),
        FastUrlValidation(customMessage: '$field must be a valid URL'),
      ],
    );
  }
}

class _StateValidator extends FastValidation {
  final Country? country;

  _StateValidator({required this.country});

  @override
  validate<T>(T dataToValidate, String? fieldName) {
    String? errorMessage;
    bool valid = true;
    ResultType outputType = ResultType.valid;

    if (dataToValidate == null || country == null || !country!.states.contains(dataToValidate)) {
      errorMessage = customMessage ?? '${fieldName ?? 'this field'} is invalid';
      valid = false;
      outputType = ResultType.invalid;
    }

    return ValidationResult<T>(
      errorMessage: errorMessage,
      type: outputType,
      valid: valid,
      result: dataToValidate,
    );
  }
}
