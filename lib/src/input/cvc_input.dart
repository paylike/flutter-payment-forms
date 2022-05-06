import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:paylike_sdk/src/input/base_input.dart';
import 'package:paylike_sdk/src/input/display_service.dart';
import 'package:paylike_sdk/src/repository/single.dart';

mixin on State<PaylikeInputWidget<T>> {
  String fos = '';
}

/// Used for handling CVC input
class CVCInput extends PaylikeInputWidget<String> {
  /// For more information check [PaylikeInputWidget]
  const CVCInput(
      {Key? key,
      required SingleRepository<String> repository,
      required InputDisplayService service})
      : super(key: key, repository: repository, service: service);

  @override
  State<StatefulWidget> createState() => _CVCInputState();
}

class _CVCInputState extends State<CVCInput>
    with EmptyBuildCounter, ValidatableInput {
  /// Updates view if service triggers it
  void _listener() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    widget.service.addListener(_listener);
  }

  @override
  void dispose() {
    super.dispose();
    widget.service.removeListener(_listener);
  }

  /// Used for the editable field
  final TextEditingController _cvcCtrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return TextFormField(
        maxLength: 3,
        style: TextStyle(
            color: getColorForValidation(context, widget.service.current)),
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
            widget.repository.set(value);
          }
          if (widget.service.current != InputStates.wip) {
            widget.service.change(InputStates.wip);
          } else {
            setState(() => {});
          }
        });
  }
}
