import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:paylike_sdk/src/input/base_input.dart';
import 'package:paylike_sdk/src/repository/single.dart';

import 'card_types.dart';
import 'formatters.dart';

/// Used for handling the card input field
class CardInput extends StatefulWidget {
  /// Stores the value of the field
  final SingleRepository<String> fieldRepository;
  const CardInput({Key? key, required this.fieldRepository}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _CardInputState();
}

class _CardInputState extends State<CardInput> with EmptyBuildCounter {
  /// Used for the editable field
  final TextEditingController _numberCtrl = TextEditingController();
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
  void initState() {
    super.initState();
    widget.fieldRepository.set("");
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
      buildCounter: emptyBuildCounter,
      maxLength: 23,
      onChanged: (String? value) {
        if (value != null) {
          widget.fieldRepository.set(value);
        } else {
          widget.fieldRepository.set("");
        }
        setState(() => {});
      },
      decoration: InputDecoration(
          hintText: '0000 0000 0000 0000',
          border: InputBorder.none,
          suffixIcon: _getCardIcon()),
    );
  }
}
