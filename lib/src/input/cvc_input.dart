import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:paylike_sdk/src/input/base_input.dart';
import 'package:paylike_sdk/src/repository/single.dart';

/// Used for handling CVC input
class CVCInput extends StatefulWidget {
  final SingleRepository<String> cvcRepository;
  const CVCInput({Key? key, required this.cvcRepository}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _CVCInputState();
}

class _CVCInputState extends State<CVCInput> with EmptyBuildCounter {
  /// Used for the editable field
  final TextEditingController _cvcCtrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return TextFormField(
        maxLength: 3,
        style: TextStyle(color: Theme.of(context).colorScheme.error),
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
            widget.cvcRepository.set(value);
          }
        });
  }
}
