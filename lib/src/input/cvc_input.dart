import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:paylike_sdk/src/input/base_input.dart';
import 'package:paylike_sdk/src/input/display_service.dart';
import 'package:paylike_sdk/src/repository/single.dart';

import '../styling/styles.dart';

/// Used for handling CVC input
class CVCInput extends PaylikeInputWidget<String> {
  /// Style of the rendered component
  final PaylikeWidgetStyles style;

  /// For more information check [PaylikeInputWidget]
  const CVCInput(
      {Key? key,
      required SingleRepository<String> repository,
      required InputDisplayService service,
      this.style = PaylikeWidgetStyles.material})
      : super(key: key, repository: repository, service: service);

  @override
  State<StatefulWidget> createState() => _CVCInputState();
}

class _CVCInputState extends State<CVCInput>
    with EmptyBuildCounter, ValidatableInput
    implements StylablePaylikeWidget {
  /// Used for the editable field
  final TextEditingController _cvcCtrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return widget.style == PaylikeWidgetStyles.material
        ? material(context)
        : cupertino(context);
  }

  void _onChanged(String? value) {
    if (value != null) {
      widget.repository.set(value);
    }
    if (widget.service.current != InputStates.wip) {
      widget.service.change(InputStates.wip);
    } else {
      setState(() => {});
    }
  }

  @override
  Widget material(BuildContext context) {
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
        onChanged: _onChanged);
  }

  @override
  Widget cupertino(BuildContext context) {
    return CupertinoTextField(
      placeholder: 'XXX',
      maxLength: 3,
      controller: _cvcCtrl,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      textInputAction: TextInputAction.next,
      onChanged: _onChanged,
      decoration: const BoxDecoration(border: Border()),
    );
  }
}
