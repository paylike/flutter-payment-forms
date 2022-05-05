import 'package:flutter/widgets.dart';

import 'base_input.dart';

/// Used as the ViewModel component for Input field
class InputDisplayService extends ChangeNotifier {
  /// Current state of the input field display
  InputStates current = InputStates.wip;

  /// Changes the current state of the field
  void change(InputStates state) {
    current = state;
    notifyListeners();
  }
}
