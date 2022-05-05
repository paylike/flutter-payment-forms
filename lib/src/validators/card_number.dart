import 'package:paylike_luhn/paylike_luhn.dart';

/// Validator for card numbers
class CardNumberValidator {
  static bool isValid(String number) {
    if (number.isEmpty) {
      return false;
    }
    return PaylikeLuhn.isValid(number.replaceAll(' ', ''));
  }
}
