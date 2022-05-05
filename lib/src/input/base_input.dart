import 'package:flutter/material.dart';
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
enum InputStates {
  /// Used when the input state is neither valid or invalid
  wip,

  /// Used when the input is valid
  valid,

  /// Used when the input is invalid
  invalid,
}

/// Describes an input component that can be validated
mixin ValidatableInput {
  /// Returns the text style that matches the validation state
  Color getColorForValidation(BuildContext context, InputStates state) {
    switch (state) {
      case InputStates.wip:
        return Theme.of(context).colorScheme.secondary;
      case InputStates.valid:
        return Colors.green;
      case InputStates.invalid:
        return Theme.of(context).colorScheme.error;
    }
  }
}
