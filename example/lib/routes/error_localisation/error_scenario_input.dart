import 'package:example/routes/error_localisation/scenarios.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:paylike_sdk/paylike_sdk.dart';

import '../stylable.dart';
import 'picker.dart';

/// Implementation of an unvalidated simple note input
class ErrorScenarioInput extends PaylikeExtensionInputWidget<String> {
  /// Called when the scenario is changed
  final ErrorScenario current;

  /// Called when current needs to be changed
  final Function(ErrorScenario?) onChanged;

  /// Describes the style of the example
  final PaylikeWidgetStyles style;

  const ErrorScenarioInput(
      {Key? key,
      required SingleCustomRepository<String> repository,
      required InputDisplayService service,
      required this.current,
      required this.onChanged,
      this.style = PaylikeWidgetStyles.material})
      : super(key: key, repository: repository, service: service, order: 0);

  /// You can use named constructors to define encapsulated service and repository
  /// if you want to. This makes easier to keep the codebase clean and readable.
  ErrorScenarioInput.init(
      {Key? key,
      required this.current,
      required this.onChanged,
      this.style = PaylikeWidgetStyles.material})
      : super(
            key: key,
            service: InputDisplayService(),
            repository: SingleCustomRepository<String>.withDefaultValue('',
                validator: (_) => true, serializer: (String value) => {}),
            order: 0);
  @override
  State<StatefulWidget> createState() => _ErrorScenarioInputState();
}

class _ErrorScenarioInputState extends State<ErrorScenarioInput>
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
    return Container(
        margin: const EdgeInsets.only(top: 10, bottom: 10),
        child: Row(
          children: [
            Expanded(
                child: CupertinoButton(
                    child: Text(widget.current.title),
                    onPressed: () => showPickerDialog(CupertinoPicker(
                        magnification: 1.22,
                        squeeze: 1.2,
                        useMagnifier: true,
                        itemExtent: 32.0,
                        // This is called when selected item is changed.
                        onSelectedItemChanged: (int selectedItem) {
                          widget
                              .onChanged(ErrorScenarios.getAll()[selectedItem]);
                        },
                        children: List<Widget>.generate(
                            ErrorScenarios.getAll().length, (int index) {
                          return Center(
                            child: Text(
                              ErrorScenarios.getAll()[index].title,
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
          value: widget.current,
          icon: const Icon(Icons.keyboard_arrow_down),
          items: ErrorScenarios.getAll().map((ErrorScenario item) {
            return DropdownMenuItem(
              value: item,
              child: Text(item.title),
            );
          }).toList(),
          onChanged: widget.onChanged,
        )),
      ],
    );
  }
}
