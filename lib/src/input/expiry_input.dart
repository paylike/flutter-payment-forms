import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:paylike_sdk/paylike_sdk.dart';

import 'formatters.dart';

/// Used for handling expiry input
class ExpiryInput extends PaylikeInputWidget<String> {
  /// Style of the rendered component
  final PaylikeWidgetStyles style;

  /// For more information check [PaylikeInputWidget]
  const ExpiryInput(
      {Key? key,
      required SingleRepository<String> repository,
      required InputDisplayService service,
      this.style = PaylikeWidgetStyles.material})
      : super(key: key, repository: repository, service: service);

  @override
  State<StatefulWidget> createState() => _ExpiryInputState();
}

class _ExpiryInputState extends State<ExpiryInput>
    with EmptyBuildCounter, ValidatableInput
    implements StylablePaylikeWidget {
  /// Used for the editable field
  final TextEditingController _expiryCtrl = TextEditingController();

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
  Widget build(BuildContext context) {
    return widget.style == PaylikeWidgetStyles.material
        ? material(context)
        : cupertino(context);
  }

  @override
  Widget cupertino(BuildContext context) {
    return CupertinoTextField(
        placeholder: 'MM / YY',
        textInputAction: TextInputAction.next,
        maxLength: 5,
        controller: _expiryCtrl,
        keyboardType: TextInputType.number,
        inputFormatters: [
          ExpiryFormatter(),
        ],
        decoration: const BoxDecoration(border: Border()),
        onChanged: _onChanged);
  }

  @override
  Widget material(BuildContext context) {
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
        onChanged: _onChanged);
  }
}
