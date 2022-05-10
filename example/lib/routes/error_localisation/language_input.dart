import 'package:flutter/material.dart';
import 'package:paylike_sdk/paylike_sdk.dart';

/// Implementation of an unvalidated simple note input
class LanguageInput extends PaylikeExtensionInputWidget<String> {
  const LanguageInput(
      {Key? key,
      required SingleCustomRepository<String> repository,
      required InputDisplayService service,
      required this.onChange})
      : super(key: key, repository: repository, service: service, order: 0);

  /// Called when the language is changed
  final Function() onChange;

  /// You can use named constructors to define encapsulated service and repository
  /// if you want to. This makes easier to keep the codebase clean and readable.
  LanguageInput.init({Key? key, required this.onChange})
      : super(
            key: key,
            service: InputDisplayService(),
            repository: SingleCustomRepository<String>.withDefaultValue('',
                validator: (_) => true, serializer: (String value) => {}),
            order: 0);
  @override
  State<StatefulWidget> createState() => _LanguageInputState();
}

class _LanguageInputState extends State<LanguageInput> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: DropdownButton(
          // Initial Value
          value: PaylikeLocalizator.current,
          // Down Arrow Icon
          icon: const Icon(Icons.keyboard_arrow_down),

          // Array list of items
          items: Languages.values.map((Languages item) {
            return DropdownMenuItem(
              value: item,
              child: Text(item.name.toUpperCase()),
            );
          }).toList(),
          // After selecting the desired option,it will
          // change button value to selected value
          onChanged: (Languages? newValue) {
            setState(() {
              PaylikeLocalizator.current = newValue!;
              widget.onChange();
            });
          },
        )),
      ],
    );
  }
}
