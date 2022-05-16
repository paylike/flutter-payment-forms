import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:paylike_sdk/paylike_sdk.dart';

import '../stylable.dart';
import 'picker.dart';

/// Implementation of an unvalidated simple note input
class LanguageInput extends PaylikeExtensionInputWidget<String> {
  const LanguageInput(
      {Key? key,
      required SingleCustomRepository<String> repository,
      required InputDisplayService service,
      required this.onChange,
      this.style = PaylikeWidgetStyles.material})
      : super(key: key, repository: repository, service: service, order: 0);

  /// Called when the language is changed
  final Function() onChange;

  /// Describes the style of the example
  final PaylikeWidgetStyles style;

  /// You can use named constructors to define encapsulated service and repository
  /// if you want to. This makes easier to keep the codebase clean and readable.
  LanguageInput.init(
      {Key? key,
      required this.onChange,
      this.style = PaylikeWidgetStyles.material})
      : super(
            key: key,
            service: InputDisplayService(),
            repository: SingleCustomRepository<String>.withDefaultValue('',
                validator: (_) => true, serializer: (String value) => {}),
            order: 0);
  @override
  State<StatefulWidget> createState() => _LanguageInputState();
}

class _LanguageInputState extends State<LanguageInput>
    with Picker
    implements StyleableExample {
  @override
  Widget build(BuildContext context) {
    return widget.style == PaylikeWidgetStyles.material
        ? material(context)
        : cupertino(context);
  }

  @override
  Widget cupertino(BuildContext context) {
    var currentLanguage = PaylikeLocalizator.current;
    return Container(
        margin: const EdgeInsets.only(top: 10, bottom: 10),
        child: Row(
          children: [
            Expanded(
                child: CupertinoButton(
                    child: Text(currentLanguage.name),
                    onPressed: () => showPickerDialog(CupertinoPicker(
                        magnification: 1.22,
                        squeeze: 1.2,
                        useMagnifier: true,
                        itemExtent: 32.0,
                        // This is called when selected item is changed.
                        onSelectedItemChanged: (int selectedItem) {
                          setState(() {
                            PaylikeLocalizator.current =
                                Languages.values[selectedItem];
                            widget.onChange();
                          });
                        },
                        children: List<Widget>.generate(Languages.values.length,
                            (int index) {
                          return Center(
                            child: Text(
                              Languages.values[index].name,
                            ),
                          );
                        })))))
          ],
        ));
  }

  @override
  Widget material(BuildContext context) {
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
