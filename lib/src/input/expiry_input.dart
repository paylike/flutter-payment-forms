import 'package:flutter/material.dart';
import 'package:paylike_sdk/src/input/base_input.dart';
import 'package:paylike_sdk/src/repository/single.dart';

import 'formatters.dart';

/// Used for handling expiry input
class ExpiryInput extends StatefulWidget {
  final SingleRepository<String> expiryRepository;
  const ExpiryInput({Key? key, required this.expiryRepository})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => _ExpiryInputState();
}

class _ExpiryInputState extends State<ExpiryInput> with EmptyBuildCounter {
  /// Used for the editable field
  final TextEditingController _expiryCtrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return TextFormField(
        textInputAction: TextInputAction.next,
        maxLength: 5,
        controller: _expiryCtrl,
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
            widget.expiryRepository.set(value);
          }
        });
  }
}
