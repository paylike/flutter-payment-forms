import 'package:flutter/material.dart';
import 'package:paylike_sdk/src/input/base_input.dart';
import 'package:paylike_sdk/src/repository/single.dart';

import 'display_service.dart';
import 'formatters.dart';

/// Used for handling expiry input
class ExpiryInput extends StatefulWidget {
  /// Repository of the input
  final SingleRepository<String> repository;

  /// State of the input used for coloring the input field
  final InputDisplayService service;
  const ExpiryInput({Key? key, required this.repository, required this.service})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => _ExpiryInputState();
}

class _ExpiryInputState extends State<ExpiryInput>
    with EmptyBuildCounter, ValidatableInput {
  /// Used for the editable field
  final TextEditingController _expiryCtrl = TextEditingController();

  /// Listens to service events
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

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        textInputAction: TextInputAction.next,
        maxLength: 5,
        controller: _expiryCtrl,
        style: TextStyle(
            color: getColorForValidation(context, widget.service.current)),
        keyboardType: TextInputType.number,
        inputFormatters: [
          ExpiryFormatter(),
        ],
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: 'MM / YY',
        ),
        buildCounter: emptyBuildCounter,
        onChanged: (String? value) {
          if (value != null) {
            widget.repository.set(value);
          }
          if (widget.service.current != InputStates.wip) {
            widget.service.change(InputStates.wip);
          } else {
            setState(() => {});
          }
        });
  }
}
