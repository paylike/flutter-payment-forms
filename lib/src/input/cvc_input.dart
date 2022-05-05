import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:paylike_sdk/src/input/base_input.dart';
import 'package:paylike_sdk/src/input/display_service.dart';
import 'package:paylike_sdk/src/repository/single.dart';

/// Used for handling CVC input
class CVCInput extends StatefulWidget {
  /// Repository to store CVC code
  final SingleRepository<String> repository;

  /// State of the input used for coloring the input field
  final InputDisplayService service;
  const CVCInput({Key? key, required this.repository, required this.service})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => _CVCInputState();
}

class _CVCInputState extends State<CVCInput>
    with EmptyBuildCounter, ValidatableInput {
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

  /// Used for the editable field
  final TextEditingController _cvcCtrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return TextFormField(
        maxLength: 3,
        style: TextStyle(
            color: getColorForValidation(context, widget.service.current)),
        controller: _cvcCtrl,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        textInputAction: TextInputAction.next,
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: 'XXX',
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
