
import 'package:fast_validator/fast_validator.dart';

class Validator {
  static bool validate(List<ValidationModel> validators) {
    bool isAllValid = true;

    for (final i in validators) {
      bool valid = i.validate();

      if (!valid) isAllValid = false;
    }

    return isAllValid;
  }
}

class ValidationModel<T> {
  T data;
  ValidationError? error;
  String fieldName;
  List<FastValidation> validators;

  ValidationModel({
    required this.fieldName,
    required this.data,
    required this.error,
    required this.validators,
  });

  bool validate() {
    ValidationResult result = FastValidator.validate<T>(data, validators: validators, fieldName: fieldName);
    if (result.valid) {
      error?.errorMessage = result.errorMessage;
      error?.isError = false;

      return true;
    }

    error?.errorMessage = result.errorMessage;
    error?.isError = true;
    return false;
  }
}

class ValidationError {
  bool isError;
  String? errorMessage;

  ValidationError({required this.isError, required this.errorMessage});

  factory ValidationError.none() {
    return ValidationError(isError: false, errorMessage: null);
  }

  void reset() {
    isError = false;
    errorMessage = null;
  }
}
