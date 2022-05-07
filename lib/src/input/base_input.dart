import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:paylike_sdk/src/repository/single.dart';
import 'package:paylike_sdk/src/repository/single_custom.dart';

import 'display_service.dart';

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

/// Describes a generic input widget that can be used inside the form and
/// developed by the paylike team. Use [PaylikeExtensionInputWidget] to create extensions!
abstract class PaylikeInputWidget<T> extends StatefulWidget {
  /// State of the input used for coloring the input field
  final InputDisplayService service;

  /// Repository to store the input
  final SingleRepository<T> repository;

  const PaylikeInputWidget(
      {Key? key, required this.repository, required this.service})
      : super(key: key);
}

/// Describes a generic input widget that can be used inside the form and is an extension
/// by an SDK user
abstract class PaylikeExtensionInputWidget<T> extends StatefulWidget {
  /// State of the input used for coloring the input field
  final InputDisplayService service;

  /// Repository to store the input
  final SingleCustomRepository<T> repository;

  const PaylikeExtensionInputWidget(
      {Key? key, required this.repository, required this.service})
      : super(key: key);
}

/// Describes an input component that can be validated
///
/// Under the hood it exposes a function to trigger
/// ```dart
/// setState(() {});
/// ```
/// whenever the input state changes in the service
mixin ValidatableInput<T extends PaylikeInputWidget> on State<T> {
  /// Updates view if service triggers it
  void _listener() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    widget.service.addListener(_listener);
  }

  @override
  void dispose() {
    super.dispose();
    widget.service.removeListener(_listener);
  }

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
