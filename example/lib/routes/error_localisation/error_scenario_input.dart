import 'package:example/routes/error_localisation/scenarios.dart';
import 'package:flutter/material.dart';
import 'package:paylike_sdk/paylike_sdk.dart';

/// Implementation of an unvalidated simple note input
class ErrorScenarioInput extends PaylikeExtensionInputWidget<String> {
  /// Called when the scenario is changed
  final ErrorScenario current;

  /// Called when current needs to be changed
  final Function(ErrorScenario?) onChanged;

  const ErrorScenarioInput(
      {Key? key,
      required SingleCustomRepository<String> repository,
      required InputDisplayService service,
      required this.current,
      required this.onChanged})
      : super(key: key, repository: repository, service: service, order: 0);

  /// You can use named constructors to define encapsulated service and repository
  /// if you want to. This makes easier to keep the codebase clean and readable.
  ErrorScenarioInput.init(
      {Key? key, required this.current, required this.onChanged})
      : super(
            key: key,
            service: InputDisplayService(),
            repository: SingleCustomRepository<String>.withDefaultValue('',
                validator: (_) => true, serializer: (String value) => {}),
            order: 0);
  @override
  State<StatefulWidget> createState() => _ErrorScenarioInputState();
}

class _ErrorScenarioInputState extends State<ErrorScenarioInput> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: DropdownButton(
          // Initial Value
          value: widget.current,
          // Down Arrow Icon
          icon: const Icon(Icons.keyboard_arrow_down),

          // Array list of items
          items: ErrorScenarios.getAll().map((ErrorScenario item) {
            return DropdownMenuItem(
              value: item,
              child: Text(item.title),
            );
          }).toList(),
          // After selecting the desired option,it will
          // change button value to selected value
          onChanged: widget.onChanged,
        )),
      ],
    );
  }
}
