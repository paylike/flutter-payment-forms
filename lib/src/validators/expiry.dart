/// Validator for card numbers
class ExpiryValidator {
  static bool isValid(String expiry) {
    var splitted = expiry.split('/');
    if (splitted.length != 2) {
      return false;
    }
    var month = int.tryParse(splitted.first);
    var year = int.tryParse(splitted.last);
    if (month == null || year == null) {
      return false;
    }
    if (month < 1 || month > 12) {
      return false;
    }
    if (year < (DateTime.now().year - 2000)) {
      return false;
    }
    return true;
  }
}
