import 'package:flutter/material.dart';
import 'package:paylike_sdk/paylike_sdk.dart';

/// Describes information in the name input field
class _Name {
  String firstName = '';
  String lastName = '';

  /// Returns the default instance
  _Name();

  /// Used for copying data from the previous state
  _Name.copy(_Name other, {String? firstName, String? lastName}) {
    this.firstName = other.firstName;
    this.lastName = other.lastName;
    if (firstName != null) {
      this.firstName = firstName;
    }
    if (lastName != null) {
      this.lastName = lastName;
    }
  }
}

/// Implementation of an unvalidated simple note input
class CustomNameInput extends PaylikeExtensionInputWidget<_Name> {
  const CustomNameInput(
      {Key? key,
      required SingleCustomRepository<_Name> repository,
      required InputDisplayService service})
      : super(key: key, repository: repository, service: service, order: 0);

  /// You can use named constructors to define encapsulated service and repository
  /// if you want to. This makes easier to keep the codebase clean and readable.
  CustomNameInput.init({Key? key})
      : super(
            key: key,
            order: 0,
            service: InputDisplayService(),
            repository: SingleCustomRepository<_Name>(
                validator: (_Name value) =>
                    value.firstName.isNotEmpty && value.lastName.isNotEmpty,
                serializer: (_Name value) => {
                      'firstName': value.firstName,
                      'lastName': value.lastName
                    }));
  @override
  State<StatefulWidget> createState() => _CustomNameInput();
}

class _CustomNameInput extends State<CustomNameInput>
    with EmptyBuildCounter, ValidatableExtensionInput {
  final TextEditingController _firstNameCtrl = TextEditingController();
  final TextEditingController _lastNameCtrl = TextEditingController();

  /// Used to acquire validation color for each field individually
  Color _getColorForValidation(BuildContext context, String value) {
    var color = getColorForValidation(context, widget.service.current);
    if (widget.service.current == InputStates.invalid && value.isNotEmpty) {
      return getColorForValidation(context, InputStates.valid);
    }
    return color;
  }

  @override
  Widget build(BuildContext context) {
    /// Set repository item to avoid null pointer exception in the first render
    if (!widget.repository.isAvailable) {
      widget.repository.set(_Name());
    }
    return Row(
      children: [
        Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('First name'),
          Row(
            children: [
              Expanded(
                  child: TextFormField(
                      controller: _firstNameCtrl,
                      decoration: const InputDecoration(
                          border: InputBorder.none, hintText: 'John'),
                      style: TextStyle(
                          color: _getColorForValidation(
                              context, widget.repository.item.firstName)),
                      onChanged: (String? value) {
                        if (value != null) {
                          widget.repository.set(_Name.copy(
                              widget.repository.item,
                              firstName: value));
                        }
                        if (widget.service.current != InputStates.wip) {
                          widget.service.change(InputStates.wip);
                        }
                      }))
            ],
          ),
        ])),
        Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Last name'),
            Row(children: [
              Expanded(
                  child: TextFormField(
                      controller: _lastNameCtrl,
                      decoration: const InputDecoration(
                          border: InputBorder.none, hintText: 'Doe'),
                      style: TextStyle(
                          color: _getColorForValidation(
                              context, widget.repository.item.lastName)),
                      onChanged: (String? value) {
                        if (value != null) {
                          widget.repository.set(_Name.copy(
                              widget.repository.item,
                              lastName: value));
                        }
                        if (widget.service.current != InputStates.wip) {
                          widget.service.change(InputStates.wip);
                        }
                      }))
            ]),
          ],
        ))
      ],
    );
  }
}
