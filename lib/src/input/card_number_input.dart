import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:paylike_sdk/src/input/base_input.dart';
import 'package:paylike_sdk/src/repository/single.dart';

import 'card_types.dart';
import 'display_service.dart';
import 'formatters.dart';

/// Used for handling the card input field
class CardInput extends PaylikeInputWidget<String> {
  /// For more information check [PaylikeInputWidget]
  const CardInput(
      {Key? key,
      required SingleRepository<String> repository,
      required InputDisplayService service})
      : super(key: key, repository: repository, service: service);

  @override
  State<StatefulWidget> createState() => _CardInputState();
}

class _CardInputState extends State<CardInput>
    with EmptyBuildCounter, ValidatableInput {
  /// Used for the editable field
  final TextEditingController _numberCtrl = TextEditingController();

  /// Returns a card icon based on the card number (Either Visa or Mastercard)
  Widget _getCardIcon() {
    if (_numberCtrl.text.isEmpty) {
      return CardIcons.get(CardTypes.generic);
    }
    if (_numberCtrl.text.startsWith('4')) {
      return CardIcons.get(CardTypes.visa);
    }
    if (['2', '5', '6'].fold(
        false, (prev, value) => prev || _numberCtrl.text.startsWith(value))) {
      return CardIcons.get(CardTypes.mastercard);
    }
    return CardIcons.get(CardTypes.generic);
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textInputAction: TextInputAction.next,
      controller: _numberCtrl,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        CardNumberFormatter()
      ],
      style: TextStyle(
          color: getColorForValidation(context, widget.service.current)),
      buildCounter: emptyBuildCounter,
      maxLength: 23,
      onChanged: (String? value) {
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
      },
      decoration: InputDecoration(
          hintText: '0000 0000 0000 0000',
          border: InputBorder.none,
          suffixIcon: _getCardIcon()),
    );
  }
}
