import 'package:flutter/material.dart';
import 'package:paylike_sdk/paylike_sdk.dart';

/// Implementation of an unvalidated simple note input
class CustomNoteInput extends PaylikeExtensionInputWidget<String> {
  const CustomNoteInput(
      {Key? key,
      required SingleCustomRepository<String> repository,
      required InputDisplayService service})
      : super(key: key, repository: repository, service: service);

  /// You can use named constructors to define encapsulated service and repository
  /// if you want to. This makes easier to keep the codebase clean and readable.
  CustomNoteInput.init({Key? key})
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
    with EmptyBuildCounter {
  final TextEditingController _ctrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: TextFormField(
                controller: _ctrl,
                decoration: const InputDecoration(
                    border: InputBorder.none, hintText: 'Note (optional)'),
                style: const TextStyle(color: Colors.amber),
                onChanged: (String? value) {
                  if (value != null) {
                    widget.repository.set(value);
                  }
                })),
      ],
    );
  }
}
