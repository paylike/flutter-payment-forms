import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:paylike_sdk/paylike_sdk.dart';

import 'card_types.dart';
import 'formatters.dart';

/// Used for handling the card input field
class CardInput extends PaylikeInputWidget<String> {
  /// Style of the rendered component
  final PaylikeWidgetStyles style;

  /// For more information check [PaylikeInputWidget]
  const CardInput(
      {Key? key,
      required SingleRepository<String> repository,
      required InputDisplayService service,
      this.style = PaylikeWidgetStyles.material})
      : super(key: key, repository: repository, service: service);

  @override
  State<StatefulWidget> createState() => _CardInputState();
}

class _CardInputState extends State<CardInput>
    with EmptyBuildCounter, ValidatableInput
    implements StylablePaylikeWidget {
  /// Used for the editable field
  final TextEditingController _ctrl = TextEditingController(text: '');

  /// Returns a card icon based on the card number (Either Visa or Mastercard)
  Widget _getCardIcon() {
    if (_ctrl.text.isEmpty) {
      return CardIcons.get(CardTypes.generic);
    }
    if (_ctrl.text.startsWith('4')) {
      return CardIcons.get(CardTypes.visa);
    }
    if (['2', '5', '6']
        .fold(false, (prev, value) => prev || _ctrl.text.startsWith(value))) {
      return CardIcons.get(CardTypes.mastercard);
    }
    return CardIcons.get(CardTypes.generic);
  }

  void _onChanged(String? value) {
    if (value != null) {
      widget.repository.set(value);
    } else {
      widget.repository.set("");
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
      textInputAction: TextInputAction.next,
      controller: _ctrl,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        CardNumberFormatter()
      ],
      placeholder: '0000 0000 0000 0000',
      maxLength: 23,
      onChanged: _onChanged,
    );
  }

  @override
  Widget material(BuildContext context) {
    return TextFormField(
      textInputAction: TextInputAction.next,
      controller: _ctrl,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        CardNumberFormatter()
      ],
      style: TextStyle(
          color: getColorForValidation(context, widget.service.current)),
      buildCounter: emptyBuildCounter,
      maxLength: 23,
      onChanged: _onChanged,
      decoration: InputDecoration(
          hintText: '0000 0000 0000 0000',
          border: InputBorder.none,
          suffixIcon: _getCardIcon()),
    );
  }
}
