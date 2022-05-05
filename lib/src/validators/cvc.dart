/// Validator for CVC code
class CVCValidator {
  static bool isValid(String cvc) {
    return cvc.length == 3;
  }
}
