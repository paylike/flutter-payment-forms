import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:paylike_sdk/paylike_sdk.dart';

import '../stylable.dart';

/// Implementation of an unvalidated simple note input
class CustomNoteInput extends PaylikeExtensionInputWidget<String> {
  /// Describes the style of the example
  final PaylikeWidgetStyles style;
  const CustomNoteInput(
      {Key? key,
      required SingleCustomRepository<String> repository,
      required InputDisplayService service,
      this.style = PaylikeWidgetStyles.material})
      : super(key: key, repository: repository, service: service);

  /// You can use named constructors to define encapsulated service and repository
  /// if you want to. This makes easier to keep the codebase clean and readable.
  CustomNoteInput.init({Key? key, this.style = PaylikeWidgetStyles.material})
      : super(
            key: key,
            service: InputDisplayService(),
            repository: SingleCustomRepository<String>.withDefaultValue('',
                validator: (_) => true,
                serializer: (String value) =>
                    value.isEmpty ? {} : {'note': value}));
  @override
  State<StatefulWidget> createState() => _CustomNoteInputState();
}

class _CustomNoteInputState extends State<CustomNoteInput>
    with EmptyBuildCounter
    implements StyleableExample {
  final TextEditingController _ctrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: widget.style == PaylikeWidgetStyles.material
                ? material(context)
                : cupertino(context)),
      ],
    );
  }

  @override
  Widget cupertino(BuildContext context) {
    return CupertinoTextField(
      controller: _ctrl,
      onChanged: (String value) {
        widget.repository.set(value);
      },
      placeholder: 'Note',
      placeholderStyle: const TextStyle(color: Colors.grey),
      decoration: const BoxDecoration(border: Border()),
    );
  }

  @override
  Widget material(BuildContext context) {
    return TextFormField(
        controller: _ctrl,
        decoration: const InputDecoration(
            border: InputBorder.none, hintText: 'Note (optional)'),
        style: const TextStyle(color: Colors.amber),
        onChanged: (String? value) {
          if (value != null) {
            widget.repository.set(value);
          }
        });
  }
}
