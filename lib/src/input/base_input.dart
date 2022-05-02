import 'package:flutter/widgets.dart';

/// Small mixin to remove unnecessary counter
/// from input fields
mixin EmptyBuildCounter {
  Widget? emptyBuildCounter(
    BuildContext context, {
    required int currentLength,
    int? maxLength,
    required bool isFocused,
  }) =>
      null;
}

/// Describes the 3 different states of an input
enum InputState {
  /// Used when the input state is neither valid or invalid
  unknown,

  /// Used when the input is valid
  valid,

  /// Used when the input is invalid
  invalid,
}

/// Handles validation for inputs
class BaseInputValidator {
  final InputState Function() getInputState;
  BaseInputValidator(this.getInputState);
}
