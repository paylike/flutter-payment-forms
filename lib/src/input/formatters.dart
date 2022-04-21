import 'package:flutter/services.dart';

/// Responsible for formatting the expiry field
class ExpiryFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.length < oldValue.text.length) {
      if (oldValue.text[oldValue.text.length - 1] == "/") {
        return TextEditingValue(
            selection:
                TextSelection.collapsed(offset: newValue.selection.end - 1),
            text: newValue.text[0]);
      }
    }
    if (newValue.text.length == 2) {
      return TextEditingValue(
          selection:
              TextSelection.collapsed(offset: newValue.selection.end + 1),
          text: '${newValue.text}/');
    }
    return newValue;
  }
}

/// Utility class to help tracking white spaces when the card input happens
class CardNumberWithWhiteSpace {
  String value;
  int numberOfWhiteSpaces;
  CardNumberWithWhiteSpace(this.value, this.numberOfWhiteSpaces);
  CardNumberWithWhiteSpace.fromEmpty(this.value) : numberOfWhiteSpaces = 0;
}

/// Responsible for the modification of the card number
class CardNumberFormatter extends TextInputFormatter {
  CardNumberWithWhiteSpace _getWhiteSpacesInserted(String value) {
    if (value.isEmpty) return CardNumberWithWhiteSpace.fromEmpty(value);
    if (value.length < 4) return CardNumberWithWhiteSpace.fromEmpty(value);
    var text = "";
    var numberOfSpacesAdded = 0;
    for (var i = 0; i < value.length; i++) {
      if (i != 0 && (i + 1) % 4 == 0) {
        text += "${value[i]} ";
        numberOfSpacesAdded++;
        continue;
      }
      text += value[i];
    }
    return CardNumberWithWhiteSpace(text, numberOfSpacesAdded);
  }

  String _getNumberWithoutWhiteSpaces(String value) {
    return value.replaceAll(" ", "");
  }

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (oldValue.text.isEmpty) return newValue;
    var oldWithoutFormat = _getNumberWithoutWhiteSpaces(oldValue.text);
    if (oldWithoutFormat.length == newValue.text.length &&
        oldValue.text[oldValue.text.length - 1] == " ") {
      var reformatted = _getWhiteSpacesInserted(
          newValue.text.substring(0, newValue.text.length - 1));
      return TextEditingValue(
          selection: TextSelection.collapsed(
              offset: (newValue.selection.end - 1) +
                  reformatted.numberOfWhiteSpaces),
          text: reformatted.value);
    }
    if (newValue.text.length > 3) {
      var reformatted = _getWhiteSpacesInserted(newValue.text);
      return TextEditingValue(
          selection: TextSelection.collapsed(
              offset: newValue.selection.end + reformatted.numberOfWhiteSpaces),
          text: reformatted.value);
    }
    return newValue;
  }
}
